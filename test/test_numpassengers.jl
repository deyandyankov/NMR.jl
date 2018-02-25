### Calculate the number of passengers on each flight
NMR.clean_split_dir()
NMR.runjob(NMR.Nmr(3, ["AComp_Passenger_data.csv"], NMR.mapper_parserecordacomp, "acomp.csv"))
NMR.runjob(NMR.Nmr(3, ["acomp.csv"], NMR.reducer_numberofpassengers, "acomp_reduced.json"))
c = NMR.runcombiner("acomp_reduced.json", NMR.combiner_parsejson)

# @show c
