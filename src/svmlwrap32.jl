@inline sin(v::NTuple{4,Core.VecElement{Float64}}) = ccall((:_ZGVdN4v_sin,MVECLIB), NTuple{4,Core.VecElement{Float64}}, (NTuple{4,Core.VecElement{Float64}},), v)
@inline Base.sin(v::Vec{4,Float64}) = Vec(sin(data(v)))
@inline sin(v::NTuple{8,Core.VecElement{Float32}}) = ccall((:_ZGVdN8v_sinf,MVECLIB), NTuple{8,Core.VecElement{Float32}}, (NTuple{8,Core.VecElement{Float32}},), v)
@inline Base.sin(v::Vec{8,Float32}) = Vec(sin(data(v)))

@inline cos(v::NTuple{4,Core.VecElement{Float64}}) = ccall((:_ZGVdN4v_cos,MVECLIB), NTuple{4,Core.VecElement{Float64}}, (NTuple{4,Core.VecElement{Float64}},), v)
@inline Base.cos(v::Vec{4,Float64}) = Vec(cos(data(v)))
@inline cos(v::NTuple{8,Core.VecElement{Float32}}) = ccall((:_ZGVdN8v_cosf,MVECLIB), NTuple{8,Core.VecElement{Float32}}, (NTuple{8,Core.VecElement{Float32}},), v)
@inline Base.cos(v::Vec{8,Float32}) = Vec(cos(data(v)))

@inline log(v::NTuple{4,Core.VecElement{Float64}}) = ccall((:_ZGVdN4v_log,MVECLIB), NTuple{4,Core.VecElement{Float64}}, (NTuple{4,Core.VecElement{Float64}},), v)
@inline Base.log(v::Vec{4,Float64}) = Vec(log(data(v)))
@inline log(v::NTuple{8,Core.VecElement{Float32}}) = ccall((:_ZGVdN8v_logf,MVECLIB), NTuple{8,Core.VecElement{Float32}}, (NTuple{8,Core.VecElement{Float32}},), v)
@inline Base.log(v::Vec{8,Float32}) = Vec(log(data(v)))

@inline pow(v1::NTuple{4,Core.VecElement{Float64}}, v2::NTuple{4,Core.VecElement{Float64}}) = ccall((:_ZGVdN4vv_pow,MVECLIB), NTuple{4,Core.VecElement{Float64}}, (NTuple{4,Core.VecElement{Float64}},NTuple{4,Core.VecElement{Float64}}), v1, v2)
@inline Base.:(^)(v1::Vec{4,Float64}, v2::Vec{4,Float64}) = Vec(pow(data(v1),data(v2)))
@inline pow(v1::NTuple{8,Core.VecElement{Float32}}, v2::NTuple{8,Core.VecElement{Float32}}) = ccall((:_ZGVdN8vv_powf,MVECLIB), NTuple{8,Core.VecElement{Float32}}, (NTuple{8,Core.VecElement{Float32}},NTuple{8,Core.VecElement{Float32}}), v1, v2)
@inline Base.:(^)(v1::Vec{8,Float32}, v2::Vec{8,Float32}) = Vec(pow(data(v1),data(v2)))

