jupyter_path = ARGS[1]

using Pkg
Pkg.add("Feather")
Pkg.add("DataFrames")
Pkg.add("NamedArrays")

ENV["JUPYTER"] = jupyter_path

Pkg.precompile()
Pkg.add("IJulia")