# NMR.jl - Naive MapReduce

The NMR package implements a MapReduce-like system working on a single system.  
It allows one to run mappers and reducers on a number of asynchronous workers. By default the number of those workers is the number of CPU cores available in the system.  

# Installation
From within julia, execute:
Pkg.clone("https://github.com/deyandyankov/NMR.jl")

# Testing
From within julia, execute:
Pkg.test(“NMR”)

