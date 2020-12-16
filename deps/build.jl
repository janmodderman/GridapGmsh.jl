gmsh_root = nothing

if haskey(ENV,"GMSHROOT") && !isempty(ENV["GMSHROOT"])
  gmsh_root = ENV["GMSHROOT"]
  @info """
  Using the gmsh installation found via the GMSHROOT environment variable.
  GMSHROOT=$gmsh_root"""
else
  gmsh = Sys.which("gmsh")
  if gmsh === nothing
    s = """
    The automatic discovery of a gmsh installation failed.
    Try one of the following:

    - Install gmsh and make sure that the gmsh executable
      can be found via the PATH environment variable.

    - Set an environemnt variable called GMSHROOT with the path 
    to the location of a gmsh installation. Make sure that:
      GMSHROOT/bin/gmsh is the path of the gmsh binary and
      GMSHROOT/lib/gmsh.jl is the path of the gmsh Julia API.
    """
    @warn s
  else
    gmsh_root = dirname(gmsh)[1:end-4]
    @info """
    Using the gmsh installation automatically found in $gmsh_root"""
  end
end

GMSH_FOUND = false
if gmsh_root != nothing
  gmsh_bin = joinpath(gmsh_root,"bin","gmsh")
  if isfile(gmsh_bin)
    GMSH_FOUND = true
    @info "gmsh binary found in $gmsh_bin"
  else
    @warn """
    gmsh binary not found in $gmsh_bin
    Make sure that GMSHROOT points to a correct gmsh installation"""
  end
  gmsh_jl = joinpath(gmsh_root,"lib","gmsh.jl")
  if isfile(gmsh_jl)
    GMSH_FOUND = true
    @info "Using the gmsh Julia API found in $gmsh_jl"
  else
    @warn """
    gmsh Julia API not found in $gmsh_jl
    Make sure that you have installed the full gmsh SDK"""
  end
end

open("deps.jl","w") do f
  println(f, "# This file is automatically generated")
  println(f, "# Do not edit")
  println(f)
  println(f, :(const GMSH_FOUND = $GMSH_FOUND))
  println(f, :(const gmsh_jl    = $gmsh_jl))
end
