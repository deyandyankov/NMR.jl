struct Nmr
  jobid::Int
  inputs::Array{String}
  fun::Function
  outputfilename::String
end

struct MapperException <: Exception
  msg::String
end

struct UDFException <: Exception
  msg::String
end
