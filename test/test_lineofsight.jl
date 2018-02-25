### Calculate the line-of-sight (nautical) miles for each flight and the total travelled by each passenger

NMR.clean_split_dir()
jobid = 4

# this parses records in AComp_Passenger_data.cs into JSON, handling errors
NMR.runjob(NMR.Nmr(jobid, ["AComp_Passenger_data.csv"], NMR.mapper_parserecordacomp, "acomplineofsight.json"))
psgr = NMR.runcombiner("acomplineofsight.json", NMR.combiner_parsejson)

# this gives us list of flights with [flightid, [srcairport, dstairport]]
NMR.runjob(NMR.Nmr(jobid, ["acomplineofsight.json"], NMR.reducer_lineofsightpassenger, "lineofsightpassenger.json"))
# combine results
flights = NMR.runcombiner("lineofsightpassenger.json", NMR.combiner_parsejson, "lineofsightpassenger.json")

# This gives us Airport Lat Long
NMR.runjob(NMR.Nmr(jobid, ["Top30_airports_LatLong.csv"], NMR.mapper_airportlatlon, "airportlatlon.json"))
# combine results
latlon = NMR.runcombiner("airportlatlon.json", NMR.combiner_parsejson, "airportlatlon.json")

function airport_latlon(airportid)
 for a in latlon
  a = JSON.parse(a)
  a["airportcode"] == airportid || continue
  return a["lat"], a["lon"]
 end
end

function getnauticalmiles()
 flight_miles = Dict{String, Float64}()
 for j in flights
  p = JSON.parse(j)
  srcairport = p[2][1]
  dstairport = p[2][2]
  srclatlon = airport_latlon(srcairport)
  dstlatlon = airport_latlon(dstairport)
  if srclatlon === nothing
   warn("Unable to find location of airport $srcairport")
   continue
  end
  if dstlatlon === nothing
   warn("Unable to find location of airport $dstairport")
   continue
  end
  miles = haversine(airport_latlon(srcairport), airport_latlon(dstairport))
  flight_miles[p[1]] = miles
 end
 flight_miles
end
flight_miles = getnauticalmiles()

passenger_miles = Dict{String, Float64}()
for p in psgr
 j = JSON.parse(p)
 passenger = j["passengerid"]
 flight = j["flightid"]
 if ! (flight in keys(flight_miles))
  continue
 end
 if passenger in keys(passenger_miles)
  passenger_miles[passenger] += flight_miles[flight]
 else
  passenger_miles[passenger] = flight_miles[flight]
 end
end
@show passenger_miles

header = "passenger,miles"
output = ["$(k),$(passenger_miles[k])" for k in keys(passenger_miles)]
NMR.save_job_output(jobid, header, output)
