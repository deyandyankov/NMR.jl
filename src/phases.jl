function phase_run(j)
  info("initiating run phase")
  r = [@spawnat w runfun(j) for w in workers()]
  map(wait, r)
  info("run phase finished")
end

function runfun(j)
  info("runfun worker $(myid()) initiated")
  length(j.inputs) > 2 && throw(ArgumentError("Cannot operate on more than two inputs."))
  length(j.inputs) == 1 && runfunsinglearg(j)
#  length(j.inputs) == 2 && runfunmultiplearg(j)
  info("runfun worker $(myid()) finished")
end

function runfunsinglearg(j)
  info("runfunsinglearg $(myid()) initiated")
  input_filename = j.inputs[1]
  inputfile = joinpath(splitdir, string(myid()), input_filename)
  io_input = open(inputfile)
  io_output = write_sink(j)
  for (linenum, line) in enumerate(eachline(io_input))
    try
      v = j.fun(line)
      v == "" && continue
      write(io_output, json(v) * "\n")
    catch e
      if typeof(e) in [MapperException, UDFException]
        warn("[JOB $(j.jobid)] mapper encountered an exception of type $(typeof(e)) on line $(linenum): $(e.msg)")
      else
        rethrow(e)
      end
    end
  end

  if length(ctx) > 0
    for (k, v) in ctx
      write(io_output, json((k, v)) * "\n")
    end
  end
  close(io_input)
  close(io_output)
  info("runfunsinglearg $(myid()) finished")
end

function runfunmultiplearg(j)
  info("runfunmultiplearg $(myid()) initiated")
  input_filenamex = j.inputs[1]
  input_filenamey = j.inputs[2]
  io_output = write_sink(j)
  inputfilex = joinpath(splitdir, string(myid()), input_filenamex)
  for worker in workers()
    inputfiley = joinpath(splitdir, string(worker), input_filenamey)
    io_inputy = open(inputfiley)
    io_inputx = open(inputfilex)
    for (lineynum, liney) in enumerate(eachline(io_inputy))
      for (linexnum, linex) in enumerate(eachline(io_inputx))
        try
          v = j.fun(linex, liney)
          v == "" && continue
          write(io_output, json(v) * "\n")
        catch e
          if typeof(e) in [MapperException, UDFException]
            warn("[JOB $(j.jobid)] mapper encountered an exception of type $(typeof(e)) on line $(linenum): $(e.msg)")
          else
            rethrow(e)
          end
        end
      end
    end
    close(io_inputy)
    close(io_inputx)
  end
  if length(ctx) > 0
    for (k, v) in ctx
      write(io_output, json((k, v)) * "\n")
    end
  end
  close(io_output)
  info("runfunmultiplearg $(myid()) finished")
end

function runcombiner(filename, fun_combiner)
  r = [@spawnat w readlines(joinpath(splitdir, string(w), filename)) for w in workers()]
  combined = []
  map(wait, r)
  for p in r
    append!(combined, fetch(p))
  end
  fun_combiner(combined)
end

function runcombiner(filename, fun_combiner, outputfilename)
  output = runcombiner(filename, fun_combiner)
  output_file_path = joinpath(datadir, outputfilename)
  isfile(output_file_path) && rm(output_file_path)
  fh = open(output_file_path, "w")
  for l in output
    write(fh, l * "\n")
  end
  close(fh)

  output
end
