# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-src"
  "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-build"
  "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-subbuild/ds-populate-prefix"
  "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-subbuild/ds-populate-prefix/tmp"
  "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-subbuild/ds-populate-prefix/src/ds-populate-stamp"
  "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-subbuild/ds-populate-prefix/src"
  "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-subbuild/ds-populate-prefix/src/ds-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-subbuild/ds-populate-prefix/src/ds-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/Users/alitty/Documents/GitRepo/TechnoAesthetics/build/Qt_6_7_0_for_macOS-Release/_deps/ds-subbuild/ds-populate-prefix/src/ds-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
