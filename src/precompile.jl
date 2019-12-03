function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{SLEEFPirates.var"##s13#4",Any,Any,Any,Any,Any})
end
