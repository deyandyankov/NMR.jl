"""A join function used for the line of sight objective"""
function joiner_lineofsight(jsonlinex, jsonliney)
  x = JSON.parse(jsonlinex)
  y = JSON.parse(jsonliney)
  key = ""
  value = ""
  if y[1] == x["flightid"]
    key = x["flightid"] * "_" * x["originairport"] * "_" * x["dstairport"]
    value = x["passengerid"]
  end
  ret = Dict(key => value)
  return ret
end
