## Determine the number of flights from each airport, include a list of any airports not used.
NMR.clean_split_dir()

NMR.runjob(NMR.Nmr(1, ["AComp_Passenger_data.csv"], NMR.mapper_parserecordacomp, "acomp.csv"))
NMR.runjob(NMR.Nmr(1, ["acomp.csv"], NMR.reducer_numberofflights, "acomp_flights_reduced.csv"))
c = NMR.runcombiner("acomp_flights_reduced.csv", NMR.combiner_parsejson)

# record output
header = "airportid,flights"
output = [string(JSON.parse(l)[1]) * "," * string(JSON.parse(l)[2]) for l in c]
NMR.save_job_output(1, header, output)
