reducer_noop(s) = s

"""Used in to calculate number of flughts"""
function reducer_numberofflights(s)
  j = JSON.parse(s)
  fromairport = j["originairport"]
  ctx[fromairport] = get(ctx, fromairport, 0) + 1
  return ""
end

"""Used to calculate number of passengers"""
function reducer_numberofpassengers(s)
  j = JSON.parse(s)
  flightid = j["flightid"]
  passengerid = j["passengerid"]
  ctx[flightid] = get(ctx, flightid, 0) + 1
  return ""
end

"""Used to calculate line of sight"""
function reducer_lineofsightpassenger(s)
  j = JSON.parse(s)
  key = j["flightid"]
  value = (j["originairport"], j["dstairport"])
  ctx[key] = value
  return ""
end
