
struct PReLu{T}; a::T; end
@inline (p::PReLu)(x) = ifelse(x <= 0, x * p.a, x)

@inline Φ(x::T) where {T} = @fastmath T(0.5) * (one(T) + VectorizationBase.verf(x * T(0.7071067811865476)))
@inline gelu(x) = Base.FastMath.mul_fast(x, Φ(x))

@inline softplus(x) = log1p(exp(x))
@inline silu(x) = Base.FastMath.mul_fast(x, sigmoid_fast(x))

struct Elu{T}; a::T; end
@inline (e::Elu)(x) = ifelse(x <= 0, Base.FastMath.mul_fast(e.a, expm1_fast(x)), x)

