"""
nmr - Naive MapReduce module

NMR is a Naive MapReduce implementation.
It has a simple interface that allows the user to input a filename and process it in a map-reduce fashion.
"""
module NMR
  using JSON

  pkgdir = Pkg.dir("NMR")
  datadir = "NMR_DATADIR" in keys(ENV) ? ENV["NMR_DATADIR"] : joinpath(pkgdir, "test", "data")
  splitdir = "NMR_SPLITDIR" in keys(ENV) ? ENV["NMR_SPLITDIR"] : joinpath(pkgdir, "test", "split")
  outputdir = "NMR_OUTPUTDIR" in keys(ENV) ? ENV["NMR_OUTPUTDIR"] : joinpath(pkgdir, "test", "output")

  ctx = Dict{String, Any}()
  default_ctx = Dict{String, Any}()

  function runjob(j)
    info("Running job: $j")
    split_raw_data(j)
    create_job_area(j)
    phase_run(j)
    ctx = copy(default_ctx)

    return true
  end

end # module
