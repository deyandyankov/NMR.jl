immutable NMR
  jobid::Int
  inputs::Array{String}
  fun::Function
  outputfilename::String
end

type MapperException <: Exception
  msg::String
end

type UDFException <: Exception
  msg::String
end
