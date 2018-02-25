using Base.Test
using JSON
using NMR

addprocs(Sys.CPU_CORES)
@everywhere using NMR

include("test_numberofflights.jl")
include("test_listofflights.jl")
include("test_numpassengers.jl")
include("test_lineofsight.jl")
