### Calculate the line-of-sight (nautical) miles for each flight and the total travelled by each passenger

# this parses records in AComp_Passenger_data.cs into JSON, handling errors
NMR.runjob(NMR.Nmr(4, ["AComp_Passenger_data.csv"], NMR.mapper_parserecordacomp, "acomplineofsight.json"))

# this gives us list of flights with [flightid, [srcairport, dstairport]]
NMR.runjob(NMR.Nmr(4, ["acomplineofsight.json"], NMR.reducer_lineofsightpassenger, "lineofsightpassenger.json"))

# combine results
c = NMR.runcombiner("lineofsightpassenger.json", NMR.combiner_parsejson)

# sanity checks
@show c

# we need to join the above with airport coordinates to calculate line of sight for each flight
# we must then create a MR job to calculate passengers and their flights with src and dst airport
# .. to calculate total miles travelled by each passenger

# join the two output files
NMR.runjob(NMR.Nmr(4, ["acomplineofsight.json", "lineofsightpassenger.json"], NMR.joiner_lineofsight, "joinedlineofsight.json"))
