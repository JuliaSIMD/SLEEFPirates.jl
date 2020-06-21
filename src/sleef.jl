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
p """), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
end
@inline expversion2(v::SVec{8,Float64}) = SVec(expversion2(extract_data(v)))


@inline function log1p(v::Vec{8,Float64})
    Base.llvmcall(("""
declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)
""","""
  %2 = fadd <8 x double> %0, <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
  %3 = fcmp one <8 x double> %2, zeroinitializer
  %4 = bitcast <8 x double> %2 to <8 x i64>
  %5 = lshr <8 x i64> %4, <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
  %6 = add nuw nsw <8 x i64> %5, <i64 614242, i64 614242, i64 614242, i64 614242, i64 614242, i64 614242, i64 614242, i64 614242>
  %7 = lshr <8 x i64> %6, <i64 20, i64 20, i64 20, i64 20, i64 20, i64 20, i64 20, i64 20>
  %8 = add nsw <8 x i64> %7, <i64 -1023, i64 -1023, i64 -1023, i64 -1023, i64 -1023, i64 -1023, i64 -1023, i64 -1023>
  %9 = icmp ugt <8 x i64> %4, <i64 4613551468752928767, i64 4613551468752928767, i64 4613551468752928767, i64 4613551468752928767, i64 4613551468752928767, i64 4613551468752928767, i64 4613551468752928767, i64 4613551468752928767>
  %10 = fsub <8 x double> %2, %0
  %11 = fsub <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, %10
  %12 = fadd <8 x double> %2, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
  %13 = fsub <8 x double> %0, %12
  %14 = select <8 x i1> %9, <8 x double> %11, <8 x double> %13
  %15 = fdiv <8 x double> %14, %2
  %16 = shl <8 x i64> %6, <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
  %17 = and <8 x i64> %16, <i64 4503595332403200, i64 4503595332403200, i64 4503595332403200, i64 4503595332403200, i64 4503595332403200, i64 4503595332403200, i64 4503595332403200, i64 4503595332403200>
  %18 = add nuw nsw <8 x i64> %17, <i64 4604544269498187776, i64 4604544269498187776, i64 4604544269498187776, i64 4604544269498187776, i64 4604544269498187776, i64 4604544269498187776, i64 4604544269498187776, i64 4604544269498187776>
  %19 = and <8 x i64> %4, <i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295>
  %20 = or <8 x i64> %18, %19
  %21 = bitcast <8 x i64> %20 to <8 x double>
  %22 = fadd <8 x double> %21, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
  %23 = fmul <8 x double> %22, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
  %24 = fmul <8 x double> %22, %23
  %25 = fadd <8 x double> %22, <double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00>
  %26 = fdiv <8 x double> %22, %25
  %27 = fmul <8 x double> %26, %26
  %28 = fmul <8 x double> %27, %27
  %29 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %28, <8 x double> <double 0x3FC39A09D078C69F, double 0x3FC39A09D078C69F, double 0x3FC39A09D078C69F, double 0x3FC39A09D078C69F, double 0x3FC39A09D078C69F, double 0x3FC39A09D078C69F, double 0x3FC39A09D078C69F, double 0x3FC39A09D078C69F>, <8 x double> <double 0x3FCC71C51D8E78AF, double 0x3FCC71C51D8E78AF, double 0x3FCC71C51D8E78AF, double 0x3FCC71C51D8E78AF, double 0x3FCC71C51D8E78AF, double 0x3FCC71C51D8E78AF, double 0x3FCC71C51D8E78AF, double 0x3FCC71C51D8E78AF>) #16
  %30 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %28, <8 x double> %29, <8 x double> <double 0x3FD999999997FA04, double 0x3FD999999997FA04, double 0x3FD999999997FA04, double 0x3FD999999997FA04, double 0x3FD999999997FA04, double 0x3FD999999997FA04, double 0x3FD999999997FA04, double 0x3FD999999997FA04>) #16
  %31 = fmul <8 x double> %28, %30
  %32 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %28, <8 x double> <double 0x3FC2F112DF3E5244, double 0x3FC2F112DF3E5244, double 0x3FC2F112DF3E5244, double 0x3FC2F112DF3E5244, double 0x3FC2F112DF3E5244, double 0x3FC2F112DF3E5244, double 0x3FC2F112DF3E5244, double 0x3FC2F112DF3E5244>, <8 x double> <double 0x3FC7466496CB03DE, double 0x3FC7466496CB03DE, double 0x3FC7466496CB03DE, double 0x3FC7466496CB03DE, double 0x3FC7466496CB03DE, double 0x3FC7466496CB03DE, double 0x3FC7466496CB03DE, double 0x3FC7466496CB03DE>) #16
  %33 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %28, <8 x double> %32, <8 x double> <double 0x3FD2492494229359, double 0x3FD2492494229359, double 0x3FD2492494229359, double 0x3FD2492494229359, double 0x3FD2492494229359, double 0x3FD2492494229359, double 0x3FD2492494229359, double 0x3FD2492494229359>) #16
  %34 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %28, <8 x double> %33, <8 x double> <double 0x3FE5555555555593, double 0x3FE5555555555593, double 0x3FE5555555555593, double 0x3FE5555555555593, double 0x3FE5555555555593, double 0x3FE5555555555593, double 0x3FE5555555555593, double 0x3FE5555555555593>) #16
  %35 = fmul <8 x double> %27, %34
  %36 = fadd <8 x double> %31, %35
  %37 = sitofp <8 x i64> %8 to <8 x double>
  %38 = fadd <8 x double> %24, %36
  %39 = fmul <8 x double> %37, <double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76, double 0x3DEA39EF35793C76>
  %40 = fadd <8 x double> %15, %39
  %41 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %26, <8 x double> %38, <8 x double> %40) #16
  %42 = fsub <8 x double> %41, %24
  %43 = fadd <8 x double> %22, %42
  %44 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %37, <8 x double> <double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000, double 0x3FE62E42FEE00000>, <8 x double> %43) #16
  %45 = fcmp oeq <8 x double> %0, <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>
  %46 = select <8 x i1> %45, <8 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>, <8 x double> %44
  %47 = select <8 x i1> %3, <8 x double> %46, <8 x double> <double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000>
  %48 = fcmp oge <8 x double> %2, zeroinitializer
  %49 = bitcast <8 x i1> %48 to i8
  %50 = xor i8 %49, -1
  %51 = bitcast i8 %50 to <8 x i1>
  %52 = select <8 x i1> %51, <8 x double> <double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF>, <8 x double> %47
  ret <8 x double> %52
"""), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
end

# @inline function log1p(v::Vec{8,Float64})
#     Base.llvmcall(("""
# declare <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double>, <8 x i64>, i8, i32)
# declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)
# declare <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double>, <8 x double>, i8, i32)
# ""","""
#   %2 = fadd <8 x double> %0, <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
#   %3 = fmul <8 x double> %2, <double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555, double 0x3FF5555555555555>
#   %4 = tail call <8 x double> @llvm.x86.avx512.mask.getexp.pd.512(<8 x double> %3, <8 x double> zeroinitializer, i8 -1, i32 4) #13
#   %5 = fcmp oeq <8 x double> %4, <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>
#   %6 = select <8 x i1> %5, <8 x double> <double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03, double 1.024000e+03>, <8 x double> %4
#   %7 = tail call <8 x i64> @llvm.x86.avx512.mask.cvtpd2qq.512(<8 x double> %6, <8 x i64> zeroinitializer, i8 -1, i32 8) #13
#   %8 = sub <8 x i64> zeroinitializer, %7
#   %9 = shl <8 x i64> %8, <i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52, i64 52>
#   %10 = add <8 x i64> %9, <i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408, i64 4607182418800017408>
#   %11 = bitcast <8 x i64> %10 to <8 x double>
#   %12 = fadd <8 x double> %11, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
#   %13 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %0, <8 x double> %11, <8 x double> %12) #13
#   %14 = fmul <8 x double> %6, <double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF>
#   %15 = fsub <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %14
#   %16 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> <double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF, double 0x3FE62E42FEFA39EF>, <8 x double> %15) #13
#   %17 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %6, <8 x double> <double 0x3C7ABC9E3B39803F, double 0x3C7ABC9E3B39803F, double 0x3C7ABC9E3B39803F, double 0x3C7ABC9E3B39803F, double 0x3C7ABC9E3B39803F, double 0x3C7ABC9E3B39803F, double 0x3C7ABC9E3B39803F, double 0x3C7ABC9E3B39803F>, <8 x double> %16) #13
#   %18 = fadd <8 x double> %13, <double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00>
#   %19 = fsub <8 x double> <double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00>, %18
#   %20 = fadd <8 x double> %13, %19
#   %21 = fdiv <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, %18
#   %22 = fmul <8 x double> %13, %21
#   %23 = fsub <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %22
#   %24 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %21, <8 x double> %13, <8 x double> %23) #13
#   %25 = fsub <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %21
#   %26 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %18, <8 x double> %25, <8 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>) #13
#   %27 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %20, <8 x double> %25, <8 x double> %26) #13
#   %28 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %21, <8 x double> zeroinitializer, <8 x double> %24) #13
#   %29 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %22, <8 x double> %27, <8 x double> %28) #13
#   %30 = fmul <8 x double> %22, %22
#   %31 = fmul <8 x double> %30, %30
#   %32 = fmul <8 x double> %31, %31
#   %33 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %30, <8 x double> <double 0x3FC3872E67FE8E84, double 0x3FC3872E67FE8E84, double 0x3FC3872E67FE8E84, double 0x3FC3872E67FE8E84, double 0x3FC3872E67FE8E84, double 0x3FC3872E67FE8E84, double 0x3FC3872E67FE8E84, double 0x3FC3872E67FE8E84>, <8 x double> <double 0x3FC747353A506035, double 0x3FC747353A506035, double 0x3FC747353A506035, double 0x3FC747353A506035, double 0x3FC747353A506035, double 0x3FC747353A506035, double 0x3FC747353A506035, double 0x3FC747353A506035>) #13
#   %34 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %31, <8 x double> <double 0x3FC39C4F5407567E, double 0x3FC39C4F5407567E, double 0x3FC39C4F5407567E, double 0x3FC39C4F5407567E, double 0x3FC39C4F5407567E, double 0x3FC39C4F5407567E, double 0x3FC39C4F5407567E, double 0x3FC39C4F5407567E>, <8 x double> %33) #13
#   %35 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %30, <8 x double> <double 0x3FCC71C0A65ECD8E, double 0x3FCC71C0A65ECD8E, double 0x3FCC71C0A65ECD8E, double 0x3FCC71C0A65ECD8E, double 0x3FCC71C0A65ECD8E, double 0x3FCC71C0A65ECD8E, double 0x3FCC71C0A65ECD8E, double 0x3FCC71C0A65ECD8E>, <8 x double> <double 0x3FD249249A68A245, double 0x3FD249249A68A245, double 0x3FD249249A68A245, double 0x3FD249249A68A245, double 0x3FD249249A68A245, double 0x3FD249249A68A245, double 0x3FD249249A68A245, double 0x3FD249249A68A245>) #13
#   %36 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %30, <8 x double> <double 0x3FD99999998F92EA, double 0x3FD99999998F92EA, double 0x3FD99999998F92EA, double 0x3FD99999998F92EA, double 0x3FD99999998F92EA, double 0x3FD99999998F92EA, double 0x3FD99999998F92EA, double 0x3FD99999998F92EA>, <8 x double> <double 0x3FE55555555557AE, double 0x3FE55555555557AE, double 0x3FE55555555557AE, double 0x3FE55555555557AE, double 0x3FE55555555557AE, double 0x3FE55555555557AE, double 0x3FE55555555557AE, double 0x3FE55555555557AE>) #13
#   %37 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %31, <8 x double> %35, <8 x double> %36) #13
#   %38 = tail call <8 x double> @llvm.fma.v8f64(<8 x double> %32, <8 x double> %34, <8 x double> %37) #13
#   %39 = fmul <8 x double> %22, <double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00>
#   %40 = fmul <8 x double> %29, <double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00, double 2.000000e+00>
#   %41 = fadd <8 x double> %14, %39
#   %42 = fsub <8 x double> %14, %41
#   %43 = fadd <8 x double> %39, %42
#   %44 = fadd <8 x double> %17, %43
#   %45 = fadd <8 x double> %40, %44
#   %46 = fmul <8 x double> %22, %30
#   %47 = fmul <8 x double> %46, %38
#   %48 = fadd <8 x double> %41, %47
#   %49 = fsub <8 x double> %41, %48
#   %50 = fadd <8 x double> %47, %49
#   %51 = fadd <8 x double> %45, %50
#   %52 = fadd <8 x double> %48, %51
#   %53 = fcmp ogt <8 x double> %0, <double 0x7FAC7B1F3CAC7433, double 0x7FAC7B1F3CAC7433, double 0x7FAC7B1F3CAC7433, double 0x7FAC7B1F3CAC7433, double 0x7FAC7B1F3CAC7433, double 0x7FAC7B1F3CAC7433, double 0x7FAC7B1F3CAC7433, double 0x7FAC7B1F3CAC7433>
#   %54 = select <8 x i1> %53, <8 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000, double 0x7FF0000000000000>, <8 x double> %52
#   %55 = fcmp olt <8 x double> %0, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
#   %56 = fcmp uno <8 x double> %0, zeroinitializer
#   %57 = or <8 x i1> %56, %55
#   %58 = select <8 x i1> %57, <8 x double> <double 0x7FF8000000000000, double 0x7FF8000000000000, double 0x7FF8000000000000, double 0x7FF8000000000000, double 0x7FF8000000000000, double 0x7FF8000000000000, double 0x7FF8000000000000, double 0x7FF8000000000000>, <8 x double> %54
#   %59 = fcmp oeq <8 x double> %0, <double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00, double -1.000000e+00>
#   %60 = select <8 x i1> %59, <8 x double> <double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000, double 0xFFF0000000000000>, <8 x double> %58
#   %61 = bitcast <8 x double> %0 to <8 x i64>
#   %62 = icmp eq <8 x i64> %61, <i64 -9223372036854775808, i64 -9223372036854775808, i64 -9223372036854775808, i64 -9223372036854775808, i64 -9223372036854775808, i64 -9223372036854775808, i64 -9223372036854775808, i64 -9223372036854775808>
#   %63 = select <8 x i1> %62, <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, <8 x double> %60
#   ret <8 x double> %63
# """), Vec{8,Float64}, Tuple{Vec{8,Float64}}, v)
# end

@static if SIMDPirates.VectorizationBase.AVX512F && VERSION ≥ v"1.4"
@inline function tanh(v::Vec{16,Float32})
    Base.llvmcall(("""
declare <16 x float> @llvm.fma.v16f32(<16 x float>, <16 x float>, <16 x float> )
declare <16 x float> @llvm.x86.avx512.mask.rndscale.ps.512(<16 x float>, i32, <16 x float>, i16, i32)
declare <16 x i32> @llvm.x86.avx512.mask.cvttps2dq.512(<16 x float>, <16 x i32>, i16, i32)
""", """
  %2 = bitcast <16 x float> %0 to <8 x i64>
  %3 = and <8 x i64> %2, <i64 9223372034707292159, i64 9223372034707292159, i64 9223372034707292159, i64 9223372034707292159, i64 9223372034707292159, i64 9223372034707292159, i64 9223372034707292159, i64 9223372034707292159>
  %4 = bitcast <8 x i64> %3 to <16 x float>
  %5 = fcmp olt <16 x float> %4, <float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01, float 6.250000e-01>
  %6 = bitcast <16 x i1> %5 to i16
  %7 = bitcast <16 x float> %0 to <16 x i32>
  %8 = and <16 x i32> %7, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %9 = icmp eq i16 %6, 0
  br i1 %9, label %20, label %10

10:                                               ; preds = %1
  %11 = fmul <16 x float> %4, %4
  %12 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %11, <16 x float> <float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000, float 0xBF775E1D40000000>, <16 x float> <float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000, float 0x3F952269C0000000>) #16
  %13 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %11, <16 x float> %12, <16 x float> <float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000, float 0xBFAB83C5A0000000>) #16
  %14 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %11, <16 x float> %13, <16 x float> <float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000, float 0x3FC1107260000000>) #16
  %15 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %11, <16 x float> %14, <16 x float> <float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000, float 0xBFD5555320000000>) #16
  %16 = fmul <16 x float> %11, %15
  %17 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %16, <16 x float> %4, <16 x float> %4) #16
  %18 = bitcast <16 x float> %17 to <16 x i32>
  %19 = icmp eq i16 %6, -1
  br i1 %19, label %48, label %20

20:                                               ; preds = %10, %1
  %21 = phi <16 x i32> [ %18, %10 ], [ <i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216>, %1 ]
  %22 = fadd <16 x float> %4, %4
  %23 = fmul <16 x float> %22, <float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000, float 0x3FF7154760000000>
  %24 = tail call <16 x float> @llvm.x86.avx512.mask.rndscale.ps.512(<16 x float> %23, i32 0, <16 x float> zeroinitializer, i16 -1, i32 4)
  %25 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %24, <16 x float> <float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000, float 0xBFE6300000000000>, <16 x float> %22) #16
  %26 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %24, <16 x float> <float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000, float 0x3F2BD01060000000>, <16 x float> %25) #16
  %27 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %26, <16 x float> <float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000, float 0x3F56EF19E0000000>, <16 x float> <float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000, float 0x3F8131B160000000>) #16
  %28 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %26, <16 x float> %27, <16 x float> <float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000, float 0x3FA5552AE0000000>) #16
  %29 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %26, <16 x float> %28, <16 x float> <float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000, float 0x3FC55534A0000000>) #16
  %30 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %26, <16 x float> %29, <16 x float> <float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01, float 5.000000e-01>) #16
  %31 = fmul <16 x float> %26, %26
  %32 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %30, <16 x float> %31, <16 x float> %26) #16
  %33 = fadd <16 x float> %32, <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
  %34 = fcmp ole <16 x float> %22, <float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000, float 0xC0561814A0000000>
  %35 = tail call <16 x i32> @llvm.x86.avx512.mask.cvttps2dq.512(<16 x float> %24, <16 x i32> zeroinitializer, i16 -1, i32 4) #16
  %36 = shl <16 x i32> %35, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
  %37 = add <16 x i32> %36, <i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216, i32 1065353216>
  %38 = bitcast <16 x i32> %37 to <16 x float>
  %39 = fmul <16 x float> %33, %38
  %40 = fcmp oge <16 x float> %22, <float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000, float 0x40561814A0000000>
  %41 = fadd <16 x float> %39, <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
  %42 = fdiv <16 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %41
  %43 = select <16 x i1> %34, <16 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, <16 x float> %42
  %44 = select <16 x i1> %40, <16 x float> zeroinitializer, <16 x float> %43
  %45 = tail call <16 x float> @llvm.fma.v16f32(<16 x float> %44, <16 x float> <float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00, float -2.000000e+00>, <16 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>) #16
  %46 = bitcast <16 x float> %45 to <16 x i32>
  %47 = select <16 x i1> %5, <16 x i32> %21, <16 x i32> %46
  br label %48

48:                                               ; preds = %10, %20
  %49 = phi <16 x i32> [ %47, %20 ], [ %18, %10 ]
  %50 = xor <16 x i32> %49, %8
  %51 = bitcast <16 x i32> %50 to <16 x float>
  ret <16 x float> %51
"""), Vec{16,Float32}, Tuple{Vec{16,Float32}}, v)
end
@inline tanh(v::SVec{16,Float32}) = SVec(tanh(extract_data(v)))
end # AVX512F
    
