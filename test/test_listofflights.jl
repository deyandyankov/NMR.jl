## Create a list of flights based on the Flight id, this output should include the passenger Id,
# relevant IATA/FAA codes, the departure time, the arrival time
# (times to be converted toHH:MM:SS format), and the flight times.
NMR.clean_split_dir()
jobid = 2
NMR.runjob(NMR.Nmr(jobid, ["AComp_Passenger_data.csv"], NMR.mapper_parserecordacomp, "acompdata.json"))
output = NMR.runcombiner("acompdata.json", NMR.combiner_parsejson)

# store output
NMR.save_job_output(jobid, "", output)
