"""Initiates a phase"""
function phase_run(j)
  info("initiating run phase")
  r = [@spawnat w runfun(j) for w in workers()]
  map(wait, r)
  info("run phase finished")
end

"""Runs a MapReduce job"""
function runfun(j)
  info("runfun worker $(myid()) initiated")
  length(j.inputs) > 2 && throw(ArgumentError("Cannot operate on more than two inputs."))
  length(j.inputs) == 1 && runfunsinglearg(j)
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

"""Runs a combiner"""
function runcombiner(filename, fun_combiner)
  r = [@spawnat w readlines(joinpath(splitdir, string(w), filename)) for w in workers()]
  combined = []
  map(wait, r)
  for p in r
    append!(combined, fetch(p))
  end
  fun_combiner(combined)
end

"""Runs a combiner and stores the result in an output file"""
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
