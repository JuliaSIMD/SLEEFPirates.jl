
@inline sin(v::NTuple{8,Core.VecElement{Float64}}) = ccall((:_ZGVeN8v_sin,MVECLIB), NTuple{8,Core.VecElement{Float64}}, (NTuple{8,Core.VecElement{Float64}},), v)
@inline Base.sin(v::Vec{8,Float64}) = Vec(sin(data(v)))
@inline sin(v::NTuple{16,Core.VecElement{Float32}}) = ccall((:_ZGVeN16v_sinf,MVECLIB), NTuple{16,Core.VecElement{Float32}}, (NTuple{16,Core.VecElement{Float32}},), v)
@inline Base.sin(v::Vec{16,Float32}) = Vec(sin(data(v)))

@inline cos(v::NTuple{8,Core.VecElement{Float64}}) = ccall((:_ZGVeN8v_cos,MVECLIB), NTuple{8,Core.VecElement{Float64}}, (NTuple{8,Core.VecElement{Float64}},), v)
@inline Base.cos(v::Vec{8,Float64}) = Vec(cos(data(v)))
@inline cos(v::NTuple{16,Core.VecElement{Float32}}) = ccall((:_ZGVeN16v_cosf,MVECLIB), NTuple{16,Core.VecElement{Float32}}, (NTuple{16,Core.VecElement{Float32}},), v)
@inline Base.cos(v::Vec{16,Float32}) = Vec(cos(data(v)))

# @inline log(v::NTuple{8,Core.VecElement{Float64}}) = ccall((:_ZGVeN8v_log,MVECLIB), NTuple{8,Core.VecElement{Float64}}, (NTuple{8,Core.VecElement{Float64}},), v)
# @inline Base.log(v::Vec{8,Float64}) = Vec(log(data(v)))
@inline log(v::NTuple{16,Core.VecElement{Float32}}) = ccall((:_ZGVeN16v_logf,MVECLIB), NTuple{16,Core.VecElement{Float32}}, (NTuple{16,Core.VecElement{Float32}},), v)
@inline Base.log(v::Vec{16,Float32}) = Vec(log(data(v)))

@inline pow(v1::NTuple{8,Core.VecElement{Float64}}, v2::NTuple{8,Core.VecElement{Float64}}) = ccall((:_ZGVeN8vv_pow,MVECLIB), NTuple{8,Core.VecElement{Float64}}, (NTuple{8,Core.VecElement{Float64}},NTuple{8,Core.VecElement{Float64}}), v1, v2)
@inline Base.:(^)(v1::Vec{8,Float64}, v2::Vec{8,Float64}) = Vec(pow(data(v1),data(v2)))
@inline pow(v1::NTuple{16,Core.VecElement{Float32}}, v2::NTuple{16,Core.VecElement{Float32}}) = ccall((:_ZGVeN16vv_powf,MVECLIB), NTuple{16,Core.VecElement{Float32}}, (NTuple{16,Core.VecElement{Float32}},NTuple{16,Core.VecElement{Float32}}), v1, v2)
@inline Base.:(^)(v1::Vec{16,Float32}, v2::Vec{16,Float32}) = Vec(pow(data(v1),data(v2)))

