# todo: potentially add caching. only execute if input filename has been modified after the splitdir contents
function split_raw_data(j)
  for filename in j.inputs
    wrkrs = workers()
    input_filename = joinpath(datadir, filename)
    !isfile(input_filename) && return true # not in data/ but already in split/
    info("Splitting $input_filename using $(length(wrkrs)) workers")
    output_filenames = Array{String}(length(wrkrs))
    for i in 1:length(wrkrs)
      output_dir = joinpath(splitdir, string(wrkrs[i]))
      !isdir(output_dir) && mkdir(output_dir)
      output_filenames[i] = joinpath(output_dir, filename)
    end
    # open the files for writing (1 file per core)
    handles = [open(f, "w") for f in output_filenames]
    handle = 1
    for ln in readlines(input_filename)
      current_output_file = output_filenames[handle]
      # println("current handle: $(handle) and current output filename $(output_filenames[handle])")
      current_handle = handles[handle]
      write(current_handle, ln * "\n") # write line into current handle
      handle += 1 # get next handle
      if handle > length(handles)
        handle = 1 # cycle back to first handle once handles have been exhausted
      end
    end
    map(close, handles) # close all output handles
  end
  return true
end

job_output_dir(j) = joinpath(outputdir, string(j.jobid))

function create_job_area(j)
  info("Creating job area...")
  joboutputdir = job_output_dir(j)
  isdir(joboutputdir) && rm(joboutputdir, force=true, recursive=true)
  mkdir(joboutputdir)
end

function read_sink(j, phase)
  inputfile = joinpath(job_output_dir(j), string(myid()) * "." * phase)
  open(inputfile)
end

function write_sink(j)
  outputfile = joinpath(splitdir, string(myid()), j.outputfilename)
  isfile(outputfile) && rm(outputfile)
  open(outputfile, "w")
end
