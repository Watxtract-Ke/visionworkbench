
# This file generates config.h from config.h.in

include(CheckIncludeFiles)
include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckTypeSize)
include(CheckCXXSymbolExists)
include(CheckCXXSourceCompiles)


###########################################################################
# These are some options that the user might like to set manually

#TODO: Where does all this get set?
set(VW_DEFAULT_CACHE_SIZE_MB 768)

# set the default number of processing threads for multi-threaded operations
set(VW_NUM_THREADS 4)

# enable image bounds checking (SLOW!) 
set(VW_ENABLE_BOUNDS_CHECK 0)

# ~/.vwrc support
set(VW_ENABLE_CONFIG_FILE 1) 

# enable the C++ exception mechanism 
set(VW_ENABLE_EXCEPTIONS 1) 

# enable SSE optimizations in some places (development) 
set(VW_ENABLE_SSE 1) 


# Define to `int' if <sys/types.h> does not define. 
#define VW_ssize_t





###########################################################################

# Check if certain include files are present
# - Define to 1 if present, blank otherwise.
# - TODO: Probably need to set to zero if not present
CHECK_INCLUDE_FILES(ext/stdio_filebuf.h VW_HAVE_EXT_STDIO_FILEBUF_H) # TODO
CHECK_INCLUDE_FILES(fenv.h              VW_HAVE_FENV_H)
CHECK_INCLUDE_FILES(inttypes.h          VW_HAVE_INTTYPES_H)
CHECK_INCLUDE_FILES(memory.h            VW_HAVE_MEMORY_H)
CHECK_INCLUDE_FILES(pwd.h               VW_HAVE_PWD_H)
CHECK_INCLUDE_FILES(stdint.h            VW_HAVE_STDINT_H)
CHECK_INCLUDE_FILES(stdlib.h            VW_HAVE_STDLIB_H)
CHECK_INCLUDE_FILES(strings.h           VW_HAVE_STRINGS_H)
CHECK_INCLUDE_FILES(string.h            VW_HAVE_STRING_H)
CHECK_INCLUDE_FILES(sys/stat.h          VW_HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILES(sys/types.h         VW_HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILES(dlfcn.h             VW_HAVE_DLFCN_H)
CHECK_INCLUDE_FILES(unistd.h            VW_HAVE_UNISTD_H)

# Ignore, only used by plate.
# Define to 1 if you have the ANSI C header files. 
#define VW_STDC_HEADERS @STDC_HEADERS@


###########################################################################
# Check if certain compiler features are available

set(emptyIncludeList )

CHECK_CXX_SOURCE_COMPILES("void testFunc() __attribute__((deprecated));         void testFunc(){}   int main(){return 0;}" VW_COMPILER_HAS_ATTRIBUTE_DEPRECATED)
CHECK_CXX_SOURCE_COMPILES("void testFunc() __attribute__((noreturn));           void testFunc(){}   int main(){return 0;}" VW_COMPILER_HAS_ATTRIBUTE_NORETURN)
CHECK_CXX_SOURCE_COMPILES("void testFunc() __attribute__((warn_unused_result)); void testFunc(){}   int main(){return 0;}" VW_COMPILER_HAS_ATTRIBUTE_WARN_UNUSED_RESULT)


# Check for some supported functions (could probably streamline ssize_t check)
check_cxx_symbol_exists(exp2            cmath                  VW_HAVE_EXP2)
check_cxx_symbol_exists(fabsl           cmath                  VW_HAVE_FABSL)
check_cxx_symbol_exists(feenableexcept  "fenv.h"               VW_HAVE_FEENABLEEXCEPT)
check_cxx_symbol_exists(getpid          "unistd.h;sys/types.h" VW_HAVE_GETPID)
check_cxx_symbol_exists(getpwuid        "pwd.h;sys/types.h"    VW_HAVE_GETPWUID)
check_cxx_symbol_exists(llabs           "stdlib.h"             VW_HAVE_LLABS)
check_cxx_symbol_exists(log2            cmath                  VW_HAVE_LOG2)
check_cxx_symbol_exists(mkstemps        "stdlib.h"             VW_HAVE_MKSTEMPS)
check_cxx_symbol_exists(tgamma          cmath                  VW_HAVE_TGAMMA)
CHECK_CXX_SOURCE_COMPILES("
                          #include <sys/types.h>
                          int main(){ssize_t a=2; return a;}" VW_HAVE_SSIZET)




###########################################################################
# Determine which libraries we can build

# If we made it to here we can build these modules
# TODO: Do we need to check any other dependencies here?
set(VW_HAVE_PKG_CORE 1)
set(VW_HAVE_PKG_MATH 1)
set(VW_HAVE_PKG_IMAGE 1)
set(VW_HAVE_PKG_FILEIO 1)
set(VW_HAVE_PKG_MATH 1)
set(VW_HAVE_PKG_VW 1) # This is not actually a module
set(VW_HAVE_PKG_CAMERA 1)
set(VW_HAVE_PKG_INTERESTPOINT 1)
set(VW_HAVE_PKG_CARTOGRAPHY 1)
set(VW_HAVE_PKG_MOSAIC 1)
set(VW_HAVE_PKG_HDR 1)
set(VW_HAVE_PKG_STEREO 1)
set(VW_HAVE_PKG_GEOMETRY 1)
set(VW_HAVE_PKG_BUNDLEADJUSTMENT 1)

# The next few libraries are deprecated!
if (false)
#if (${VW_HAVE_PKG_RABBITMQ_C} and ${VW_HAVE_PKG_ZEROMQ} and ${VW_HAVE_PKG_LIBKML})
  set(VW_HAVE_PKG_PLATE 1)
endif()

if (false)
#if (${VW_HAVE_PKG_PLATE} and ${VW_HAVE_PKG_QT})
  set(VW_HAVE_PKG_GUI 1)
endif()

if (false)
#if (${VW_HAVE_PKG_GL} and ${VW_HAVE_PKG_GLEW})
  set(VW_HAVE_PKG_GPU 1)
endif()


set(VW_HAVE_PKG_TOOLS 1)





#######################################################################
# Finished setting up variables, now call the function to paste them into a file

# Each value like "@VAR@ is replaced by the CMake variable of the same name
configure_file(${CMAKE_SOURCE_DIR}/vw/config.h.in ${CMAKE_SOURCE_DIR}/vw/config.h)



###
###
###   TODO: These variables are used, try to find them!
###
###


#/* Define to 1 if VW has BigTIFF support */
##define VW_HAS_BIGTIFF @HAS_BIGTIFF@



#/* Define to 1 if the CG package is available. */
##define VW_HAVE_PKG_CG @HAVE_PKG_CG@


#/* Define to 1 if the HDR module is available. */
##define VW_HAVE_PKG_HDR @HAVE_PKG_HDR@

#/* Define to 1 if the HDF package is available */
##define VW_HAVE_PKG_HDF @HAVE_PKG_HDF@

#/* Define to 1 if the INTEL_LAPACK package is available. */
##define VW_HAVE_PKG_INTEL_LAPACK @HAVE_PKG_INTEL_LAPACK@


#/* Define to 1 if the CLAPACK package is available. */
##define VW_HAVE_PKG_CLAPACK @VW_HAVE_PKG_CLAPACK@

#///* Define to 1 if the pkg package is available */
#//#define VW_HAVE_PKG_APPLE_LAPACK @PKG_APPLE_LAPACK@

#/* Define to 1 if the SLAPACK package is available. */
##define VW_HAVE_PKG_SLAPACK @VW_HAVE_PKG_SLAPACK@

#///* Define to 1 if the STANDALONE_FLAPACK package is available. */
#//#define VW_HAVE_PKG_STANDALONE_FLAPACK

#///* Define to 1 if the pkg package is available */
#//#define VW_HAVE_PKG_STANDALONE_LAPACK_AND_BLAS


## Needed for plate
#///* Define to 1 if the RABBITMQ_C package is available. */
#//#define VW_HAVE_PKG_RABBITMQ_C

#/* Define to 1 if the LIBKML package is available. */
##define VW_HAVE_PKG_LIBKML @VW_HAVE_PKG_LIBKML@



#/* Define to 1 if the PTHREADS package is available. */
##define VW_HAVE_PKG_PTHREADS @VW_HAVE_PKG_PROTOBUF@ #TODO?


#//DELETE ME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#///* Define to 1 if the THREADS package is available. */
#//#define VW_HAVE_PKG_THREADS


#/* Define to 1 if the ZEROMQ package is available. */
##define VW_HAVE_PKG_ZEROMQ @VW_HAVE_PKG_ZEROMQ@













