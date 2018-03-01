### Calculate the number of passengers on each flight
NMR.clean_split_dir()
jobid = 3
NMR.runjob(NMR.Nmr(jobid, ["AComp_Passenger_data.csv"], NMR.mapper_parserecordacomp, "acomp.csv"))
NMR.runjob(NMR.Nmr(jobid, ["acomp.csv"], NMR.reducer_numberofpassengers, "acomp_reduced.json"))
output = NMR.runcombiner("acomp_reduced.json", NMR.combiner_parsejson)
output = map(x -> string(JSON.parse(x)[1]) * "," * string(JSON.parse(x)[2]), output)

# store output
header = "flightid,passengers"
NMR.save_job_output(jobid, header, output)
