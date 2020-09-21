# Copyright (c) 2016, Johan Mabille, Sylvain Corlay, Wolf Vollprecht and Martin Renou
# Copyright (c) 2016, QuantStack
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.

# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.

# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if Sys.ARCH === :x86_64 && !FMA_FAST
    @inline function Base.expm1(v::Vec{2,Float64})
        Vec(Base.llvmcall(("""
            declare <2 x double> @llvm.fmuladd.v2f64(<2 x double>, <2 x double>, <2 x double>)
            declare <2 x double> @llvm.x86.sse41.round.pd(<2 x double>, i32)
            declare <4 x i32> @llvm.x86.sse2.cvttpd2dq(<2 x double>) #16
        """, """
          %2 = fcmp olt <2 x double> %0, <double 0xC04205966F2B4F12, double 0xC04205966F2B4F12>
          %3 = fcmp ogt <2 x double> %0, <double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF>
          %4 = fmul <2 x double> %0, <double 0x3FF71547652B82FE, double 0x3FF71547652B82FE>
          %5 = tail call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %4, i32 0)
          %6 = fneg <2 x double> %5
          %7 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %6, <2 x double> <double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000>, <2 x double> %0) #16
          %8 = fmul <2 x double> %5, <double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76>
          %9 = fsub <2 x double> %7, %8
          %10 = fmul <2 x double> %9, %9
          %11 = fmul <2 x double> %10, <double 5.000000e-01, double 5.000000e-01>
          %12 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %11, <2 x double> <double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D>, <2 x double> <double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239>) #16
          %13 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %11, <2 x double> %12, <2 x double> <double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7>) #16
          %14 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %11, <2 x double> %13, <2 x double> <double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585>) #16
          %15 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %11, <2 x double> %14, <2 x double> <double 0xBFA11111111110F4, double 0xBFA11111111110F4>) #16
          %16 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %11, <2 x double> %15, <2 x double> <double 1.000000e+00, double 1.000000e+00>) #16
          %17 = fmul <2 x double> %16, <double 5.000000e-01, double 5.000000e-01>
          %18 = fmul <2 x double> %9, %17
          %19 = fsub <2 x double> <double 3.000000e+00, double 3.000000e+00>, %18
          %20 = fsub <2 x double> %16, %19
          %21 = fmul <2 x double> %9, %19
          %22 = fsub <2 x double> <double 6.000000e+00, double 6.000000e+00>, %21
          %23 = fdiv <2 x double> %20, %22
          %24 = fmul <2 x double> %11, %23
          %25 = fsub <2 x double> %7, %9
          %26 = fsub <2 x double> %25, %8
          %27 = fsub <2 x double> %24, %26
          %28 = fmul <2 x double> %9, %27
          %29 = fsub <2 x double> %28, %26
          %30 = fsub <2 x double> %29, %11
          %31 = tail call <4 x i32> @llvm.x86.sse2.cvttpd2dq(<2 x double> %5) #16
          %32 = bitcast <4 x i32> %31 to <2 x i64>
          %33 = ashr <2 x i64> %32, <i64 63, i64 63>
          %34 = bitcast <2 x i64> %33 to <4 x i32>
          %35 = shufflevector <4 x i32> %31, <4 x i32> %34, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
          %36 = bitcast <4 x i32> %35 to <2 x i64>
          %37 = shl <2 x i64> %36, <i64 52, i64 52>
          %38 = sub <2 x i64> <i64 4607182418800017408, i64 4607182418800017408>, %37
          %39 = bitcast <2 x i64> %38 to <2 x double>
          %40 = fsub <2 x double> <double 1.000000e+00, double 1.000000e+00>, %39
          %41 = fsub <2 x double> %30, %9
          %42 = fsub <2 x double> %40, %41
          %43 = fadd <2 x double> %30, %39
          %44 = fsub <2 x double> %9, %43
          %45 = fadd <2 x double> %44, <double 1.000000e+00, double 1.000000e+00>
          %46 = fcmp olt <2 x double> %5, <double 2.000000e+01, double 2.000000e+01>
          %47 = select <2 x i1> %46, <2 x double> %42, <2 x double> %45
          %48 = add <2 x i64> %37, <i64 4607182418800017408, i64 4607182418800017408>
          %49 = bitcast <2 x i64> %48 to <2 x double>
          %50 = fmul <2 x double> %47, %49
          %51 = select <2 x i1> %3, <2 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000>, <2 x double> %50
          %52 = select <2 x i1> %2, <2 x double> <double -1.000000e+00, double -1.000000e+00>, <2 x double> %51
          ret <2 x double> %52
        """), _Vec{2,Float64}, Tuple{_Vec{2,Float64}}, data(v)))
    end
end

if Sys.ARCH === :x86_64 && VectorizationBase.REGISTER_SIZE ≥ 32 && !FMA_FAST # In earlier Julia versions, AVX will not be defined
    @inline function Base.expm1(v::Vec{4,Float64})
        Vec(Base.llvmcall(("""
                declare <4 x double> @llvm.fmuladd.v4f64(<4 x double>, <4 x double>, <4 x double>)
                declare <4 x double> @llvm.x86.avx.round.pd.256(<4 x double>, i32)
                declare <4 x i32> @llvm.x86.avx.cvtt.pd2dq.256(<4 x double>) #16
            """, """
              %2 = fcmp olt <4 x double> %0, <double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12>
              %3 = fcmp ogt <4 x double> %0, <double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF>
              %4 = fmul <4 x double> %0, <double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE>
              %5 = tail call <4 x double> @llvm.x86.avx.round.pd.256(<4 x double> %4, i32 0)
              %6 = fneg <4 x double> %5
              %7 = tail call <4 x double> @llvm.fmuladd.v4f64(<4 x double> %6, <4 x double> <double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000>, <4 x double> %0) #16
              %8 = fmul <4 x double> %5, <double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76>
              %9 = fsub <4 x double> %7, %8
              %10 = fmul <4 x double> %9, %9
              %11 = fmul <4 x double> %10, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
              %12 = tail call <4 x double> @llvm.fmuladd.v4f64(<4 x double> %11, <4 x double> <double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D>, <4 x double> <double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239>) #16
              %13 = tail call <4 x double> @llvm.fmuladd.v4f64(<4 x double> %11, <4 x double> %12, <4 x double> <double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7>) #16
              %14 = tail call <4 x double> @llvm.fmuladd.v4f64(<4 x double> %11, <4 x double> %13, <4 x double> <double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585>) #16
              %15 = tail call <4 x double> @llvm.fmuladd.v4f64(<4 x double> %11, <4 x double> %14, <4 x double> <double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4>) #16
              %16 = tail call <4 x double> @llvm.fmuladd.v4f64(<4 x double> %11, <4 x double> %15, <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>) #16
              %17 = fmul <4 x double> %16, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
              %18 = fmul <4 x double> %9, %17
              %19 = fsub <4 x double> <double 3.000000e+00, double 3.000000e+00, double 3.000000e+00, double 3.000000e+00>, %18
              %20 = fsub <4 x double> %16, %19
              %21 = fmul <4 x double> %9, %19
              %22 = fsub <4 x double> <double 6.000000e+00, double 6.000000e+00, double 6.000000e+00, double 6.000000e+00>, %21
              %23 = fdiv <4 x double> %20, %22
              %24 = fmul <4 x double> %11, %23
              %25 = fsub <4 x double> %7, %9
              %26 = fsub <4 x double> %25, %8
              %27 = fsub <4 x double> %24, %26
              %28 = fmul <4 x double> %9, %27
              %29 = fsub <4 x double> %28, %26
              %30 = fsub <4 x double> %29, %11
              %31 = tail call <4 x i32> @llvm.x86.avx.cvtt.pd2dq.256(<4 x double> %5) #16
              %32 = zext <4 x i32> %31 to <4 x i64>
              %33 = shl <4 x i64> %32, <i64 52, i64 52, i64 52, i64 52>
              %34 = sub <4 x i64> <i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408>, %33
              %35 = bitcast <4 x i64> %34 to <4 x double>
              %36 = fsub <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, %35
              %37 = fsub <4 x double> %30, %9
              %38 = fsub <4 x double> %36, %37
              %39 = fadd <4 x double> %30, %35
              %40 = fsub <4 x double> %9, %39
              %41 = fadd <4 x double> %40, <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
              %42 = fcmp olt <4 x double> %5, <double 2.000000e+01, double 2.000000e+01, double 2.000000e+01, double 2.000000e+01>
              %43 = select <4 x i1> %42, <4 x double> %38, <4 x double> %41
              %44 = add <4 x i64> %33, <i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408>
              %45 = bitcast <4 x i64> %44 to <4 x double>
              %46 = fmul <4 x double> %43, %45
              %47 = select <4 x i1> %3, <4 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>, <4 x double> %46
              %48 = select <4 x i1> %2, <4 x double> <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>, <4 x double> %47
              ret <4 x double> %48
          """), _Vec{4,Float64}, Tuple{_Vec{4,Float64}}, data(v)))
    end
    @inline function Base.expm1(v::Vec{8,Float32})
        Vec(Base.llvmcall(("""
        declare <8 x float> @llvm.x86.avx.round.ps.256(<8 x float>, i32)
        declare <8 x float> @llvm.fmuladd.v8f32(<8 x float>, <8 x float>, <8 x float>) #16
        declare <8 x i32> @llvm.x86.avx.cvtt.ps2dq.256(<8 x float>) #16
    """, """
      %2 = fcmp olt <8 x float> %0, <float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000>
      %3 = fcmp ogt <8 x float> %0, <float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000>
      %4 = fmul <8 x float> %0, <float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000>
      %5 = tail call <8 x float> @llvm.x86.avx.round.ps.256(<8 x float> %4, i32 0)
      %6 = fneg <8 x float> %5
      %7 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %6, <8 x float> <float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000>, <8 x float> %0) #16
      %8 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %6, <8 x float> <float 0xBF2BD01060000000, float 0xBF2BD01060000000, float 0xBF2BD01060000000, float 0xBF2BD01060000000, float 0xBF2BD01060000000, float 0xBF2BD01060000000, float 0xBF2BD01060000000, float 0xBF2BD01060000000>, <8 x float> %7) #16
      %9 = fmul <8 x float> %8, <float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01>
      %10 = fmul <8 x float> %8, %9
      %11 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %10, <8 x float> <float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000>, <8 x float> <float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000>) #16
      %12 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %10, <8 x float> %11, <8 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>) #16
      %13 = fneg <8 x float> %12
      %14 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %13, <8 x float> %9, <8 x float> <float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00>) #16
      %15 = fsub <8 x float> %12, %14
      %16 = fmul <8 x float> %8, %14
      %17 = fsub <8 x float> <float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00>, %16
      %18 = fdiv <8 x float> %15, %17
      %19 = fmul <8 x float> %10, %18
      %20 = fneg <8 x float> %10
      %21 = tail call <8 x float> @llvm.fmuladd.v8f32(<8 x float> %8, <8 x float> %19, <8 x float> %20) #16
      %22 = tail call <8 x i32> @llvm.x86.avx.cvtt.ps2dq.256(<8 x float> %5) #16
      %23 = shl <8 x i32> %22, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
      %24 = sub <8 x i32> <i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216>, %23
      %25 = bitcast <8 x i32> %24 to <8 x float>
      %26 = fsub <8 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %25
      %27 = fsub <8 x float> %21, %8
      %28 = fsub <8 x float> %26, %27
      %29 = add <8 x i32> %23, <i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216>
      %30 = bitcast <8 x i32> %29 to <8 x float>
      %31 = fmul <8 x float> %28, %30
      %32 = select <8 x i1> %3, <8 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000>, <8 x float> %31
      %33 = select <8 x i1> %2, <8 x float> <float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00>, <8 x float> %32
      ret <8 x float> %33
      """), _Vec{8,Float32}, Tuple{_Vec{8,Float32}}, data(v)))
        
    end
end
# if VectorizationBase.AVX512F

#     @eval @inline function Base.expm1(v::Vec{8,Float64})
#         $(VectorizationBase.llvmcall_expr("""
#         declare <8 x double> @llvm.x86.avx512.mask.rndscale.pd.512(<8 x double>, i32, <8 x double>, i8, i32)
#         declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>) #16
#         declare <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double>, <8 x i64>, i8, i32) #16
#         """, """
#       %1 = fcmp olt <8 x double> %0, <double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12>
#       %2 = fcmp olt <8 x double> %0, <double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12, double 0xC04205966F2B4F12>
#       %3 = fcmp ogt <8 x double> %0, <double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF>
#       %4 = fmul <8 x double> %0, <double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE>
#       %5 = tail call <8 x double> @llvm.x86.avx512.mask.rndscale.pd.512(<8 x double> %4, i32 0, <8 x double> zeroinitializer, i8 -1, i32 4)
#       %6 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %5, <8 x double> <double 0xBFE62E42FEE00000, double 0xBFE62E42FEE00000, double 0xBFE62E42FEE00000, double 0xBFE62E42FEE00000, double 0xBFE62E42FEE00000, double 0xBFE62E42FEE00000, double 0xBFE62E42FEE00000, double 0xBFE62E42FEE00000>, <8 x double> %0) #16
#       %7 = fmul <8 x double> %5, <double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76>
#       %8 = fsub <8 x double> %6, %7
#       %9 = fmul <8 x double> %8, %8
#       %10 = fmul <8 x double> %9, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
#       %11 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> <double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D, double 0xBE8AFDB76E09C32D>, <8 x double> <double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239, double 0x3ED0CFCA86E65239>) #16
#       %12 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> %11, <8 x double> <double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7, double 0xBF14CE199EAADBB7>) #16
#       %13 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> %12, <8 x double> <double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585, double 0x3F5A01A019FE5585>) #16
#       %14 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> %13, <8 x double> <double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4, double 0xBFA11111111110F4>) #16
#       %15 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> %14, <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>) #16
#       %16 = fmul <8 x double> %15, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
#       %17 = fmul <8 x double> %8, %16
#       %18 = fsub <8 x double> <double 3.000000e+00, double 3.000000e+00, double 3.000000e+00, double 3.000000e+00, double 3.000000e+00, double 3.000000e+00, double 3.000000e+00, double 3.000000e+00>, %17
#       %19 = fsub <8 x double> %15, %18
#       %20 = fmul <8 x double> %8, %18
#       %21 = fsub <8 x double> <double 6.000000e+00, double 6.000000e+00, double 6.000000e+00, double 6.000000e+00, double 6.000000e+00, double 6.000000e+00, double 6.000000e+00, double 6.000000e+00>, %20
#       %22 = fdiv <8 x double> %19, %21
#       %23 = fmul <8 x double> %10, %22
#       %24 = fsub <8 x double> %6, %8
#       %25 = fsub <8 x double> %24, %7
#       %26 = fsub <8 x double> %23, %25
#       %27 = fmul <8 x double> %8, %26
#       %28 = fsub <8 x double> %27, %25
#       %29 = fsub <8 x double> %28, %10
#       %30 = tail call <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double> %5, <8 x i64> zeroinitializer, i8 -1, i32 4) #16
#       %31 = shl <8 x i64> %30, <i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52>
#       %32 = sub <8 x i64> <i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408>, %31
#       %33 = bitcast <8 x i64> %32 to <8 x double>
#       %34 = fsub <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, %33
#       %35 = fsub <8 x double> %29, %8
#       %36 = fsub <8 x double> %34, %35
#       %37 = fadd <8 x double> %29, %33
#       %38 = fsub <8 x double> %8, %37
#       %39 = fadd <8 x double> %38, <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
#       %40 = fcmp olt <8 x double> %5, <double 2.000000e+01, double 2.000000e+01, double 2.000000e+01, double 2.000000e+01, double 2.000000e+01, double 2.000000e+01, double 2.000000e+01, double 2.000000e+01>
#       %41 = select <8 x i1> %40, <8 x double> %36, <8 x double> %39
#       %42 = add <8 x i64> %31, <i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408>
#       %43 = bitcast <8 x i64> %42 to <8 x double>
#       %44 = fmul <8 x double> %41, %43
#       %45 = select <8 x i1> %3, <8 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>, <8 x double> %44
#       %46 = select <8 x i1> %2, <8 x double> <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>, <8 x double> %45
#       ret <8 x double> %46
#         """, _Vec{8,Float64}, Tuple{_Vec{8,Float64}}, "<8 x double>", ["<8 x double>"], [:(data(v))], true))
#     end
#     @inline function Base.expm1(v::Vec{16,Float32})
#         Vec(Base.llvmcall(("""
#             declare <16 x float> @llvm.x86.avx512.mask.rndscale.ps.512(<16 x float>, i32, <16 x float>, i16, i32)
#             declare <16 x float> @llvm.fma.v16f32(<16 x float>, <16 x float>, <16 x float>) #16
#             declare <16 x i32> @llvm.x86.avx512.mask.cvttps2dq.512(<16 x float>, <16 x i32>, i16, i32) #16
#         """, """
#           %2 = fcmp olt <16 x float> %0, <float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000, float 0xC02FE28040000000>
#           %3 = fcmp ogt <16 x float> %0, <float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000>
#           %4 = fmul <16 x float> %0, <float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000>
#           %5 = tail call <16 x float> @llvm.x86.avx512.mask.rndscale.ps.512(<16 x float> %4, i32 0, <16 x float> zeroinitializer, i16 -1, i32 4)
#           %6 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %5, <16 x float> <float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000>, <16 x float> %0) #16
#           %7 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %5, <16 x float> <float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000>, <16 x float> %6) #16
#           %8 = fmul <16 x float> %7, <float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01>
#           %9 = fmul <16 x float> %7, %8
#           %10 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %9, <16 x float> <float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000, float 0x3F59EDB680000000>, <16 x float> <float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000, float 0xBFA1110FE0000000>) #16
#           %11 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %9, <16 x float> %10, <16 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>) #16
#           %12 = fneg <16 x float> %8
#           %13 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %11, <16 x float> %12, <16 x float> <float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00>) #16
#           %14 = fsub <16 x float> %11, %13
#           %15 = fmul <16 x float> %7, %13
#           %16 = fsub <16 x float> <float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00, float 6.000000e+00>, %15
#           %17 = fdiv <16 x float> %14, %16
#           %18 = fmul <16 x float> %9, %17
#           %19 = fneg <16 x float> %9
#           %20 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %7, <16 x float> %18, <16 x float> %19) #16
#           %21 = tail call <16 x i32> @llvm.x86.avx512.mask.cvttps2dq.512(<16 x float> %5, <16 x i32> zeroinitializer, i16 -1, i32 4) #16
#           %22 = shl <16 x i32> %21, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
#           %23 = sub <16 x i32> <i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216>, %22
#           %24 = bitcast <16 x i32> %23 to <16 x float>
#           %25 = fsub <16 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %24
#           %26 = fsub <16 x float> %20, %7
#           %27 = fsub <16 x float> %25, %26
#           %28 = add <16 x i32> %22, <i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216>
#           %29 = bitcast <16 x i32> %28 to <16 x float>
#           %30 = fmul <16 x float> %27, %29
#           %31 = select <16 x i1> %3, <16 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000, float 0x7FF0000000000000>, <16 x float> %30
#           %32 = select <16 x i1> %2, <16 x float> <float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00, float -1.000000e+00>, <16 x float> %31
#           ret <16 x float> %32
#         """), Vec{16,Float32}, Tuple{Vec{16,Float32}}, data(v)))
#     end
# end



