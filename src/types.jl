"""Passed to NMR.runjob() to specify a MapReduce job"""
struct Nmr
  jobid::Int
  inputs::Array{String}
  fun::Function
  outputfilename::String
end

"""Exception designed to be thrown by mappers when a runtime error occurs"""
struct MapperException <: Exception
  msg::String
end

"""Exception designed to be thrown by type initiations when a runtime error occurs"""
struct UDFException <: Exception
  msg::String
end
