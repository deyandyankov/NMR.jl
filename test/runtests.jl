using Base.Test
using JSON
using NMR

addprocs(Sys.CPU_CORES)

@time cd(joinpath(Pkg.dir("NMR"), "test")) do
  function run_test(testfile)
    info("Running test file $(testfile)")
    include(testfile)
  end
  testfiles = [f for f in readdir(".") if isfile(f) && startswith(f, "test_") && endswith(f, ".jl")]
  map(run_test, testfiles)
end
