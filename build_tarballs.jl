# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build GMPBuilder
name = "GMP"
version = v"6.1.2"
sources = [
    "https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2" =>
    "5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2",

]

# Bash recipe for building across all platforms
script = raw"""
cd gmp-6.1.2
flags="--enable-cxx"
# On x86_64 architectures, build fat binary
if [[ ${proc_family} == intel ]]; then
    flags="${flags} --enable-fat"
fi
./configure --prefix=$prefix --host=$target --enable-shared --disable-static ${flags}
make -j
make install


"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libgmp", :libgmp)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
