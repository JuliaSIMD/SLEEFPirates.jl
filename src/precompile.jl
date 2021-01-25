# function _precompile_()
#     ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
#     for T ∈ (Float32,Float64)
#         W = VectorizationBase.pick_vector_width(T)
#         for f ∈ (log, exp, sin, cos, tan, tanh, tanh_fast)
#             precompile(f, (Vec{W, T}, ))
#         end
#     end
# end

