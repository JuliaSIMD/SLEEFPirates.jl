
@inline sin(v::NTuple{2,Core.VecElement{Float64}}) = ccall((:_ZGVbN2v_sin,MVECLIB), NTuple{2,Core.VecElement{Float64}}, (NTuple{2,Core.VecElement{Float64}},), v)
@inline Base.sin(v::Vec{2,Float64}) = Vec(sin(data(v)))
@inline sin(v::NTuple{4,Core.VecElement{Float32}}) = ccall((:_ZGVbN4v_sinf,MVECLIB), NTuple{4,Core.VecElement{Float32}}, (NTuple{4,Core.VecElement{Float32}},), v)
@inline Base.sin(v::Vec{4,Float32}) = Vec(sin(data(v)))

@inline cos(v::NTuple{2,Core.VecElement{Float64}}) = ccall((:_ZGVbN2v_cos,MVECLIB), NTuple{2,Core.VecElement{Float64}}, (NTuple{2,Core.VecElement{Float64}},), v)
@inline Base.cos(v::Vec{2,Float64}) = Vec(cos(data(v)))
@inline cos(v::NTuple{4,Core.VecElement{Float32}}) = ccall((:_ZGVbN4v_cosf,MVECLIB), NTuple{4,Core.VecElement{Float32}}, (NTuple{4,Core.VecElement{Float32}},), v)
@inline Base.cos(v::Vec{4,Float32}) = Vec(cos(data(v)))

@inline log(v::NTuple{2,Core.VecElement{Float64}}) = ccall((:_ZGVbN2v_log,MVECLIB), NTuple{2,Core.VecElement{Float64}}, (NTuple{2,Core.VecElement{Float64}},), v)
@inline Base.log(v::Vec{2,Float64}) = Vec(log(data(v)))
@inline log(v::NTuple{4,Core.VecElement{Float32}}) = ccall((:_ZGVbN4v_logf,MVECLIB), NTuple{4,Core.VecElement{Float32}}, (NTuple{4,Core.VecElement{Float32}},), v)
@inline Base.log(v::Vec{4,Float32}) = Vec(log(data(v)))

@inline pow(v1::NTuple{2,Core.VecElement{Float64}}, v2::NTuple{2,Core.VecElement{Float64}}) = ccall((:_ZGVbN2vv_pow,MVECLIB), NTuple{2,Core.VecElement{Float64}}, (NTuple{2,Core.VecElement{Float64}},NTuple{2,Core.VecElement{Float64}}), v1, v2)
@inline Base.:(^)(v1::Vec{2,Float64}, v2::Vec{2,Float64}) = Vec(pow(data(v1),data(v2)))
@inline pow(v1::NTuple{4,Core.VecElement{Float32}}, v2::NTuple{4,Core.VecElement{Float32}}) = ccall((:_ZGVbN4vv_powf,MVECLIB), NTuple{4,Core.VecElement{Float32}}, (NTuple{4,Core.VecElement{Float32}},NTuple{4,Core.VecElement{Float32}}), v1, v2)
@inline Base.:(^)(v1::Vec{4,Float32}, v2::Vec{4,Float32}) = Vec(pow(data(v1),data(v2)))


