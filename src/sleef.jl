@inline function log(v::Vec{8,Float64})
    Base.llvmcall(("""
declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)
declare <8 x double> @llvm.x86.avx512.mask.fixupimm.pd.512(<8 x double>, <8 x double>, <8 x i64>, i32, i8, i32)
declare <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double>, <8 x double>, i8, i32)
declare <8 x double> @llvm.x86.avx512.mask.getmant.pd.512(<8 x double>, i32, <8 x double>, i8, i32)
""","""
 %2 = fmul <8 x double> %0, <double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555>
  %3 = tail call <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double> %2, <8 x double> zeroinitializer, i8 -1, i32 4) #13
  %4 = fcmp oeq <8 x double> %3, <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>
  %5 = tail call <8 x double> @llvm.x86.avx512.mask.getmant.pd.512(<8 x double> %0, i32 11, <8 x double> zeroinitializer, i8 -1, i32 4) #13
  %6 = fadd <8 x double> %5, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
  %7 = fadd <8 x double> %5, <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
  %8 = fdiv <8 x double> %6, %7
  %9 = fmul <8 x double> %8, %8
  %10 = fmul <8 x double> %9, %9
  %11 = fmul <8 x double> %10, %10
  %12 = fmul <8 x double> %8, %9
  %13 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %9, <8 x double> <double 0x3FC385C5CBC3F50D, double 0x3FC385C5CBC3F50D, double 0x3FC385C5CBC3F50D, double 0x3FC385C5CBC3F50D, double 0x3FC385C5CBC3F50D, double 0x3FC385C5CBC3F50D, double 0x3FC385C5CBC3F50D, double 0x3FC385C5CBC3F50D>, <8 x double> <double 0x3FC7474BA672B05F, double 0x3FC7474BA672B05F, double 0x3FC7474BA672B05F, double 0x3FC7474BA672B05F, double 0x3FC7474BA672B05F, double 0x3FC7474BA672B05F, double 0x3FC7474BA672B05F, double 0x3FC7474BA672B05F>) #13
  %14 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> <double 0x3FC3A5791D95DB39, double 0x3FC3A5791D95DB39, double 0x3FC3A5791D95DB39, double 0x3FC3A5791D95DB39, double 0x3FC3A5791D95DB39, double 0x3FC3A5791D95DB39, double 0x3FC3A5791D95DB39, double 0x3FC3A5791D95DB39>, <8 x double> %13) #13
  %15 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %9, <8 x double> <double 0x3FCC71BFEED5D419, double 0x3FCC71BFEED5D419, double 0x3FCC71BFEED5D419, double 0x3FCC71BFEED5D419, double 0x3FCC71BFEED5D419, double 0x3FCC71BFEED5D419, double 0x3FCC71BFEED5D419, double 0x3FCC71BFEED5D419>, <8 x double> <double 0x3FD249249BFBE987, double 0x3FD249249BFBE987, double 0x3FD249249BFBE987, double 0x3FD249249BFBE987, double 0x3FD249249BFBE987, double 0x3FD249249BFBE987, double 0x3FD249249BFBE987, double 0x3FD249249BFBE987>) #13
  %16 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %9, <8 x double> <double 0x3FD99999998C136E, double 0x3FD99999998C136E, double 0x3FD99999998C136E, double 0x3FD99999998C136E, double 0x3FD99999998C136E, double 0x3FD99999998C136E, double 0x3FD99999998C136E, double 0x3FD99999998C136E>, <8 x double> <double 0x3FE555555555593F, double 0x3FE555555555593F, double 0x3FE555555555593F, double 0x3FE555555555593F, double 0x3FE555555555593F, double 0x3FE555555555593F, double 0x3FE555555555593F, double 0x3FE555555555593F>) #13
  %17 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> %15, <8 x double> %16) #13
  %18 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %11, <8 x double> %14, <8 x double> %17) #13
  %19 = fmul <8 x double> %3, <double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF>
  %20 = select <8 x i1> %4, <8 x double> <double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF, double 0x40862E42FEFA39EF>, <8 x double> %19
  %21 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %8, <8 x double> <double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00>, <8 x double> %20) #13
  %22 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %12, <8 x double> %18, <8 x double> %21) #13
  %23 = tail call <8 x double> @llvm.x86.avx512.mask.fixupimm.pd.512(<8 x double> %22, <8 x double> %0, <8 x i64> <i64 22517998142095360, i64 22517998142095360, i64 22517998142095360, i64 22517998142095360, i64 22517998142095360, i64 22517998142095360, i64 22517998142095360, i64 22517998142095360>, i32 0, i8 -1, i32 4)
  ret <8 x double> %23
"""), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
end

@static if Base.libllvm_version > v"8"
    # Support different LLVM versions. Only difference is fneg in llvm 8+
    @inline function log2(v::Vec{8,Float64})
        Base.llvmcall(("""
    declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)
    declare <8 x double> @llvm.x86.avx512.mask.fixupimm.pd.512(<8 x double>, <8 x double>, <8 x i64>, i32, i8, i32)
    declare <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double>, <8 x double>, i8, i32)
    declare <8 x double> @llvm.x86.avx512.mask.getmant.pd.512(<8 x double>, i32, <8 x double>, i8, i32)
    ""","""
      %2 = fmul <8 x double> %0, <double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555>
      %3 = tail call <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double> %2, <8 x double> zeroinitializer, i8 -1, i32 4) #13
      %4 = fcmp oeq <8 x double> %3, <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>
      %5 = select <8 x i1> %4, <8 x double> <double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03>, <8 x double> %3
      %6 = tail call <8 x double> @llvm.x86.avx512.mask.getmant.pd.512(<8 x double> %0, i32 11, <8 x double> zeroinitializer, i8 -1, i32 4) #13
      %7 = fadd <8 x double> %6, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
      %8 = fadd <8 x double> %6, <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
      %9 = fdiv <8 x double> %7, %8
      %10 = fmul <8 x double> %9, %9
      %11 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> <double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9>, <8 x double> <double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9>) #13
      %12 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %11, <8 x double> %10, <8 x double> <double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481>) #13
      %13 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %12, <8 x double> %10, <8 x double> <double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD>) #13
      %14 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %13, <8 x double> %10, <8 x double> <double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254>) #13
      %15 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %14, <8 x double> %10, <8 x double> <double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9>) #13
      %16 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %15, <8 x double> %10, <8 x double> <double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2>) #13
      %17 = fmul <8 x double> %9, <double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE>
      %18 = fneg <8 x double> %17
      %19 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %9, <8 x double> <double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE>, <8 x double> %18) #13
      %20 = fadd <8 x double> %5, %17
      %21 = fsub <8 x double> %5, %20
      %22 = fadd <8 x double> %17, %21
      %23 = fadd <8 x double> %19, %22
      %24 = fmul <8 x double> %9, %10
      %25 = fadd <8 x double> %20, %23
      %26 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %16, <8 x double> %24, <8 x double> %25) #13
      %27 = tail call <8 x double> @llvm.x86.avx512.mask.fixupimm.pd.512(<8 x double> %26, <8 x double> %0, <8 x i64> <i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368>, i32 0, i8 -1, i32 4)
      ret <8 x double> %27
    """), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
    end
else
    @inline function log2(v::Vec{8,Float64})
        Base.llvmcall(("""
    declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)
    declare <8 x double> @llvm.x86.avx512.mask.fixupimm.pd.512(<8 x double>, <8 x double>, <8 x i64>, i32, i8, i32)
    declare <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double>, <8 x double>, i8, i32)
    declare <8 x double> @llvm.x86.avx512.mask.getmant.pd.512(<8 x double>, i32, <8 x double>, i8, i32)
    ""","""
      %2 = fmul <8 x double> %0, <double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555>
      %3 = tail call <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double> %2, <8 x double> zeroinitializer, i8 -1, i32 4) #13
      %4 = fcmp oeq <8 x double> %3, <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>
      %5 = select <8 x i1> %4, <8 x double> <double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03>, <8 x double> %3
      %6 = tail call <8 x double> @llvm.x86.avx512.mask.getmant.pd.512(<8 x double> %0, i32 11, <8 x double> zeroinitializer, i8 -1, i32 4) #13
      %7 = fadd <8 x double> %6, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
      %8 = fadd <8 x double> %6, <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
      %9 = fdiv <8 x double> %7, %8
      %10 = fmul <8 x double> %9, %9
      %11 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %10, <8 x double> <double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9, double 0x3FCC501739F17BA9>, <8 x double> <double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9, double 0x3FCC2B7A962850E9>) #13
      %12 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %11, <8 x double> %10, <8 x double> <double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481, double 0x3FD0CAAEEB877481>) #13
      %13 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %12, <8 x double> %10, <8 x double> <double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD, double 0x3FD484AC6A7CB2DD>) #13
      %14 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %13, <8 x double> %10, <8 x double> <double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254, double 0x3FDA617636C2C254>) #13
      %15 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %14, <8 x double> %10, <8 x double> <double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9, double 0x3FE2776C50E7EDE9>) #13
      %16 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %15, <8 x double> %10, <8 x double> <double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2, double 0x3FEEC709DC3A07B2>) #13
      %17 = fmul <8 x double> %9, <double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE>
      %18 = fsub fast <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %17
      %19 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %9, <8 x double> <double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE, double 0x40071547652B82FE>, <8 x double> %18) #13
      %20 = fadd <8 x double> %5, %17
      %21 = fsub <8 x double> %5, %20
      %22 = fadd <8 x double> %17, %21
      %23 = fadd <8 x double> %19, %22
      %24 = fmul <8 x double> %9, %10
      %25 = fadd <8 x double> %20, %23
      %26 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %16, <8 x double> %24, <8 x double> %25) #13
      %27 = tail call <8 x double> @llvm.x86.avx512.mask.fixupimm.pd.512(<8 x double> %26, <8 x double> %0, <8 x i64> <i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368, i64 167482009228346368>, i32 0, i8 -1, i32 4)
      ret <8 x double> %27
    """), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
    end
end

@inline log(v::SVec{8,Float64}) = SVec(log(extract_data(v)))
@inline Base.log(v::SVec{8,Float64}) = SVec(log(extract_data(v)))
@inline log2(v::SVec{8,Float64}) = SVec(log2(extract_data(v)))
@inline Base.log2(v::SVec{8,Float64}) = SVec(log2(extract_data(v)))



@inline function exp2(v::Vec{8,Float64})
    Base.llvmcall(("""
declare <8 x double> @llvm.x86.avx512.mask.rndscale.pd.512(<8 x double>, i32, <8 x double>, i8, i32)
declare <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double>, <8 x i64>, i8, i32)
declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)
""","""
  %2 = tail call <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double> %0, <8 x i64> zeroinitializer, i8 -1, i32 8) #13
  %3 = tail call <8 x double> @llvm.x86.avx512.mask.rndscale.pd.512(<8 x double> %0, i32 8, <8 x double> zeroinitializer, i8 -1, i32 4)
  %4 = fsub <8 x double> %0, %3
  %5 = fmul <8 x double> %4, %4
  %6 = fmul <8 x double> %5, %5
  %7 = fmul <8 x double> %6, %6
  %8 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %4, <8 x double> <double 0x3DFE7901CA95E150, double 0x3DFE7901CA95E150, double 0x3DFE7901CA95E150, double 0x3DFE7901CA95E150, double 0x3DFE7901CA95E150, double 0x3DFE7901CA95E150, double 0x3DFE7901CA95E150, double 0x3DFE7901CA95E150>, <8 x double> <double 0x3E3E6106D72C1C17, double 0x3E3E6106D72C1C17, double 0x3E3E6106D72C1C17, double 0x3E3E6106D72C1C17, double 0x3E3E6106D72C1C17, double 0x3E3E6106D72C1C17, double 0x3E3E6106D72C1C17, double 0x3E3E6106D72C1C17>) #13
  %9 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %4, <8 x double> <double 0x3E7B5266946BF979, double 0x3E7B5266946BF979, double 0x3E7B5266946BF979, double 0x3E7B5266946BF979, double 0x3E7B5266946BF979, double 0x3E7B5266946BF979, double 0x3E7B5266946BF979, double 0x3E7B5266946BF979>, <8 x double> <double 0x3EB62BFCDABCBB81, double 0x3EB62BFCDABCBB81, double 0x3EB62BFCDABCBB81, double 0x3EB62BFCDABCBB81, double 0x3EB62BFCDABCBB81, double 0x3EB62BFCDABCBB81, double 0x3EB62BFCDABCBB81, double 0x3EB62BFCDABCBB81>) #13
  %10 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %4, <8 x double> <double 0x3EEFFCBFBC12CC80, double 0x3EEFFCBFBC12CC80, double 0x3EEFFCBFBC12CC80, double 0x3EEFFCBFBC12CC80, double 0x3EEFFCBFBC12CC80, double 0x3EEFFCBFBC12CC80, double 0x3EEFFCBFBC12CC80, double 0x3EEFFCBFBC12CC80>, <8 x double> <double 0x3F24309130CB34EC, double 0x3F24309130CB34EC, double 0x3F24309130CB34EC, double 0x3F24309130CB34EC, double 0x3F24309130CB34EC, double 0x3F24309130CB34EC, double 0x3F24309130CB34EC, double 0x3F24309130CB34EC>) #13
  %11 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %5, <8 x double> %9, <8 x double> %10) #13
  %12 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %4, <8 x double> <double 0x3F55D87FE78C5960, double 0x3F55D87FE78C5960, double 0x3F55D87FE78C5960, double 0x3F55D87FE78C5960, double 0x3F55D87FE78C5960, double 0x3F55D87FE78C5960, double 0x3F55D87FE78C5960, double 0x3F55D87FE78C5960>, <8 x double> <double 0x3F83B2AB6FBA08F0, double 0x3F83B2AB6FBA08F0, double 0x3F83B2AB6FBA08F0, double 0x3F83B2AB6FBA08F0, double 0x3F83B2AB6FBA08F0, double 0x3F83B2AB6FBA08F0, double 0x3F83B2AB6FBA08F0, double 0x3F83B2AB6FBA08F0>) #13
  %13 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %4, <8 x double> <double 0x3FAC6B08D704A01F, double 0x3FAC6B08D704A01F, double 0x3FAC6B08D704A01F, double 0x3FAC6B08D704A01F, double 0x3FAC6B08D704A01F, double 0x3FAC6B08D704A01F, double 0x3FAC6B08D704A01F, double 0x3FAC6B08D704A01F>, <8 x double> <double 0x3FCEBFBDFF82C5A1, double 0x3FCEBFBDFF82C5A1, double 0x3FCEBFBDFF82C5A1, double 0x3FCEBFBDFF82C5A1, double 0x3FCEBFBDFF82C5A1, double 0x3FCEBFBDFF82C5A1, double 0x3FCEBFBDFF82C5A1, double 0x3FCEBFBDFF82C5A1>) #13
  %14 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %5, <8 x double> %12, <8 x double> %13) #13
  %15 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> %11, <8 x double> %14) #13
  %16 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %7, <8 x double> %8, <8 x double> %15) #13
  %17 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %16, <8 x double> %4, <8 x double> <double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF>) #13
  %18 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %17, <8 x double> %4, <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>) #13
  %19 = ashr <8 x i64> %2, <i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1>
  %20 = add nsw <8 x i64> %19, <i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023>
  %21 = shl <8 x i64> %20, <i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52>
  %22 = bitcast <8 x i64> %21 to <8 x double>
  %23 = fmul <8 x double> %18, %22
  %24 = add <8 x i64> %2, <i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023>
  %25 = sub <8 x i64> %24, %19
  %26 = shl <8 x i64> %25, <i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52>
  %27 = bitcast <8 x i64> %26 to <8 x double>
  %28 = fmul <8 x double> %23, %27
   %29 = fcmp oge <8 x double> %0, <double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03>
   %30 = select <8 x i1> %29, <8 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>, <8 x double> %28
   %31 = fcmp olt <8 x double> %0, <double -2.000000e+03, double -2.000000e+03, double -2.000000e+03, double -2.000000e+03, double -2.000000e+03, double -2.000000e+03, double -2.000000e+03, double -2.000000e+03>
   %32 = select <8 x i1> %31, <8 x double> zeroinitializer, <8 x double> %30
   ret <8 x double> %32
 """), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
#       ret <8 x double> %28
# """), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
end
@inline exp2(v::SVec{8,Float64}) = SVec(exp2(extract_data(v)))
@inline Base.exp2(v::SVec{8,Float64}) = SVec(exp2(extract_data(v)))

@inline function expversion2(v::Vec{8,Float64})
    Base.llvmcall(("""
declare <8 x double> @llvm.x86.avx512.mask.rndscale.pd.512(<8 x double>, i32, <8 x double>, i8, i32)
declare <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double>, <8 x i64>, i8, i32)
declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)
""","""
  %2 = fmul <8 x double> %0, <double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE, double 0x3FF71547652B82FE>
  %3 = tail call <8 x double> @llvm.x86.avx512.mask.rndscale.pd.512(<8 x double> %2, i32 8, <8 x double> zeroinitializer, i8 -1, i32 4) #13
  %4 = tail call <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double> %3, <8 x i64> zeroinitializer, i8 -1, i32 8) #13
  %5 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %3, <8 x double> <double 0xBFE62E42FEFA3000, double 0xBFE62E42FEFA3000, double 0xBFE62E42FEFA3000, double 0xBFE62E42FEFA3000, double 0xBFE62E42FEFA3000, double 0xBFE62E42FEFA3000, double 0xBFE62E42FEFA3000, double 0xBFE62E42FEFA3000>, <8 x double> %0) #13
  %6 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %3, <8 x double> <double 0xBD53DE6AF278ECE6, double 0xBD53DE6AF278ECE6, double 0xBD53DE6AF278ECE6, double 0xBD53DE6AF278ECE6, double 0xBD53DE6AF278ECE6, double 0xBD53DE6AF278ECE6, double 0xBD53DE6AF278ECE6, double 0xBD53DE6AF278ECE6>, <8 x double> %5) #13
  %7 = fmul <8 x double> %6, %6
  %8 = fmul <8 x double> %7, %7
  %9 = fmul <8 x double> %8, %8
  %10 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> <double 0x3E21E0C670AFFF06, double 0x3E21E0C670AFFF06, double 0x3E21E0C670AFFF06, double 0x3E21E0C670AFFF06, double 0x3E21E0C670AFFF06, double 0x3E21E0C670AFFF06, double 0x3E21E0C670AFFF06, double 0x3E21E0C670AFFF06>, <8 x double> <double 0x3E5AF6C36F75740C, double 0x3E5AF6C36F75740C, double 0x3E5AF6C36F75740C, double 0x3E5AF6C36F75740C, double 0x3E5AF6C36F75740C, double 0x3E5AF6C36F75740C, double 0x3E5AF6C36F75740C, double 0x3E5AF6C36F75740C>) #13
  %11 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> <double 0x3E927E5D38A23654, double 0x3E927E5D38A23654, double 0x3E927E5D38A23654, double 0x3E927E5D38A23654, double 0x3E927E5D38A23654, double 0x3E927E5D38A23654, double 0x3E927E5D38A23654, double 0x3E927E5D38A23654>, <8 x double> <double 0x3EC71DDEF633FB47, double 0x3EC71DDEF633FB47, double 0x3EC71DDEF633FB47, double 0x3EC71DDEF633FB47, double 0x3EC71DDEF633FB47, double 0x3EC71DDEF633FB47, double 0x3EC71DDEF633FB47, double 0x3EC71DDEF633FB47>) #13
  %12 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> <double 0x3EFA01A0127F883A, double 0x3EFA01A0127F883A, double 0x3EFA01A0127F883A, double 0x3EFA01A0127F883A, double 0x3EFA01A0127F883A, double 0x3EFA01A0127F883A, double 0x3EFA01A0127F883A, double 0x3EFA01A0127F883A>, <8 x double> <double 0x3F2A01A01B4421FD, double 0x3F2A01A01B4421FD, double 0x3F2A01A01B4421FD, double 0x3F2A01A01B4421FD, double 0x3F2A01A01B4421FD, double 0x3F2A01A01B4421FD, double 0x3F2A01A01B4421FD, double 0x3F2A01A01B4421FD>) #13
  %13 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %7, <8 x double> %11, <8 x double> %12) #13
  %14 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> <double 0x3F56C16C16C3396B, double 0x3F56C16C16C3396B, double 0x3F56C16C16C3396B, double 0x3F56C16C16C3396B, double 0x3F56C16C16C3396B, double 0x3F56C16C16C3396B, double 0x3F56C16C16C3396B, double 0x3F56C16C16C3396B>, <8 x double> <double 0x3F8111111110E7A5, double 0x3F8111111110E7A5, double 0x3F8111111110E7A5, double 0x3F8111111110E7A5, double 0x3F8111111110E7A5, double 0x3F8111111110E7A5, double 0x3F8111111110E7A5, double 0x3F8111111110E7A5>) #13
  %15 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> <double 0x3FA55555555554F9, double 0x3FA55555555554F9, double 0x3FA55555555554F9, double 0x3FA55555555554F9, double 0x3FA55555555554F9, double 0x3FA55555555554F9, double 0x3FA55555555554F9, double 0x3FA55555555554F9>, <8 x double> <double 0x3FC555555555555E, double 0x3FC555555555555E, double 0x3FC555555555555E, double 0x3FC555555555555E, double 0x3FC555555555555E, double 0x3FC555555555555E, double 0x3FC555555555555E, double 0x3FC555555555555E>) #13
  %16 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %7, <8 x double> %14, <8 x double> %15) #13
  %17 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %8, <8 x double> %13, <8 x double> %16) #13
  %18 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %9, <8 x double> %10, <8 x double> %17) #13
  %19 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %18, <8 x double> %6, <8 x double> <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>) #13
  %20 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %19, <8 x double> %6, <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>) #13
  %21 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %20, <8 x double> %6, <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>) #13
  %22 = ashr <8 x i64> %4, <i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1>
  %23 = add nsw <8 x i64> %22, <i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023>
  %24 = shl <8 x i64> %23, <i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52>
  %25 = bitcast <8 x i64> %24 to <8 x double>
  %26 = fmul <8 x double> %21, %25
  %27 = add <8 x i64> %4, <i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023, i64 1023>
  %28 = sub <8 x i64> %27, %22
  %29 = shl <8 x i64> %28, <i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52>
  %30 = bitcast <8 x i64> %29 to <8 x double>
  %31 = fmul <8 x double> %26, %30
  %32 = fcmp ogt <8 x double> %0, <double 0x40862E42FE102C83, double 0x40862E42FE102C83, double 0x40862E42FE102C83, double 0x40862E42FE102C83, double 0x40862E42FE102C83, double 0x40862E42FE102C83, double 0x40862E42FE102C83, double 0x40862E42FE102C83>
  %33 = select <8 x i1> %32, <8 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>, <8 x double> %31
  %34 = fcmp olt <8 x double> %0, <double -1.000000e+03, double -1.000000e+03, double -1.000000e+03, double -1.000000e+03, double -1.000000e+03, double -1.000000e+03, double -1.000000e+03, double -1.000000e+03>
  %35 = select <8 x i1> %34, <8 x double> zeroinitializer, <8 x double> %33
  ret <8 x double> %35
 """), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
end
@inline expversion2(v::SVec{8,Float64}) = SVec(expversion2(extract_data(v)))
