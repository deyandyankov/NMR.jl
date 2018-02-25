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

  # required for correct module operation
  include("types.jl")
  include("io.jl")
  include("phases.jl")
  include("haversine.jl")
  
  # user defined functions and types
  include("udf/types.jl")
  include("udf/mappers.jl")
  include("udf/joiners.jl")
  include("udf/reducers.jl")
  include("udf/combiners.jl")

  function runjob(j)
    info("Running job: $j")
    split_raw_data(j)
    create_job_area(j)
    phase_run(j)
    @everywhere NMR.reset_ctx!()

    return true
  end

  function reset_ctx!()
    global ctx
    ctx = Dict{String, Any}()
  end

end # module
