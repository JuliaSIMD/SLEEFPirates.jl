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

