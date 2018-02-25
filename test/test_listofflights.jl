## Create a list of flights based on the Flight id, this output should include the passenger Id,
# relevant IATA/FAA codes, the departure time, the arrival time
# (times to be converted toHH:MM:SS format), and the flight times.
NMR.runjob(NMR.Nmr(2, ["AComp_Passenger_data.csv"], NMR.mapper_parserecordacomp, "acompdata.json"))
c = NMR.runcombiner("acompdata.json", NMR.combiner_parsejson)
@show c
