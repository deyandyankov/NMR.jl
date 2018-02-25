function mapper_parserecordacomp(x::AbstractString)
  line = chomp(x)
  separator = ","
  isempty(line) && throw(MapperException("line is empty"))
  s = split(line, separator)
  length(s) < 6 && throw(MapperException("malformed line has less than six elements when split by ,"))

  departuretime = UDFDepartureTime(s[5])
  totalflighttime = UDFTotalFlightTime(s[6])
  arrivaltime = departuretime + Dates.Minute(totalflighttime)
  UDFRAcomp(
    UDFPassengerId(s[1]),
    UDFFlightId(s[2]),
    UDFAirportCode(s[3]),
    UDFAirportCode(s[4]),
    departuretime,
    arrivaltime,
    totalflighttime
  )
end

function mapper_airportlatlon(x::AbstractString)
  line = chomp(x)
  separator = ","
  isempty(line) && throw(MapperException("line is empty"))
  s = split(line, separator)
  Dict(
    :airportcode => s[2],
    :lat => parse(Float64, s[3]),
    :lon => parse(Float64, s[4])
  )
end
