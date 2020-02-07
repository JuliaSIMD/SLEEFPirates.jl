using VectorizationBase: REGISTER_SIZE
using Libdl

function try_to_find_libmvec()
    Sys.islinux() || return ""
    libnames = [
        "libmvec.so"
    ]
    paths = [
        "/usr/lib64/", "/usr/lib", "/lib/x86_64-linux-gnu"
    ]
    find_library(libnames, paths)
end

function create_svmlwrap_file(mveclib)
    mveclib == "" && return mveclib
    lib = dlopen(mveclib)
    file = ["const MVECLIB = \"$mveclib\""]
    sizes = [(:b,16),(:d,32),(:e,64)]
    for f ∈ [:log, :exp, :sin, :cos]
        for (l,s) ∈ sizes
            s > REGISTER_SIZE && continue
            for isdouble ∈ (true,false)
                ts = s >> (2 + isdouble)
                func = Symbol(:_ZGV, l, :N, ts, :v_, f, isdouble ? Symbol("") : :f)
                sym = dlsym(lib, func, throw_error = false)
                if sym != C_NULL
                    typ = "Float$(isdouble ? 64 : 32)"
                    vtyp = "NTuple{$ts,Core.VecElement{$typ}}"
                    svtyp = "SVec{$ts,$typ}"
                    def1 = "@inline $f(v::$vtyp) = ccall((:$func,MVECLIB), $vtyp, ($vtyp,), v)"
                    def2 = "@inline Base.$f(v::$svtyp) = SVec($f(extract_data(v)))"
                    push!(file, def1)
                    push!(file, def2)
                end
            end
        end
    end
    let f = :pow, sf = :^
        for (l,s) ∈ sizes
            if s ≤ REGISTER_SIZE
                for isdouble ∈ (true,false)
                    ts = s >> (2 + isdouble)
                    func = Symbol(:_ZGV, l, :N, ts, :vv_, f, isdouble ? Symbol("") : :f)
                    sym = dlsym(lib, func, throw_error = false)
                    if sym != C_NULL
                        typ = "Float$(isdouble ? 64 : 32)"
                        vtyp = "NTuple{$ts,Core.VecElement{$typ}}"
                        svtyp = "SVec{$ts,$typ}"
                        def1 = "@inline $f(v1::$vtyp, v2::$vtyp) = ccall((:$func,MVECLIB), $vtyp, ($vtyp,$vtyp), v1, v2)"
                        def2 = "@inline $sf(v1::$svtyp, v2::$svtyp) = SVec($f(extract_data(v1),extract_data(v2)))"
                        push!(file, def1)
                        push!(file, def2)
                    end
                end
            end
        end        
    end
    join(file, "\n")
end

open(joinpath(@__DIR__, "..", "src", "svmlwrap.jl"), "w") do f
    write(f, create_svmlwrap_file(try_to_find_libmvec()))
end




