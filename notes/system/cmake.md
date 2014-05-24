# CMake Tips and Tricks


Cmake's tutorial is pretty good.




## Common command line


* List all modules availables

		cmake --help-module-list



## Using external libraries at non-default location

This is my typical setup, where `FILEUTILS_EXT` as environment variable is set to whatever location.


	if (DEFINED ENV{FILEUTILS_EXT})
	    message("-- Using $ENV{FILEUTILS_EXT}")
	    set(ENV{PKG_CONFIG_PATH} "$ENV{FILEUTILS_EXT}/lib/pkgconfig" )
	endif()

	pkg_check_modules(CIRCLE REQUIRED libcircle)
	add_definitions(${CIRCLE_CFLAGS})

Notice that `pkg_check_modules()` will set corresponding flags, but you have to add it manually through `add_definitions()`.





## Using find_package()


	find_package(BZip2 required)

	if (BZIP2_FOUND)
	  include_directories(${BZIP2_INCLUDE_DIRS})
	  target_link_libraries (helloworld ${BZIP2_LIBRARIES})
	endif (BZIP2_FOUND)



## Using find_library()

Without writing a specific script, this appears to be a easy way to quickly locate the library in specific path and use it.


	find_library(TCL_LIBRARY
		NAMES tcl tcl84 tcl83 tcl82 tcl80
		PATHS /usr/lib /usr/local/lib
	)
	if (TCL_LIBRARY)
		target_link_library(Hello ${TCL_LIBRARY})
	endif ()


Another example - fatal error if not found

    find_library(AIO
            NAMES aio
            PATHS /usr/lib64 /usr/local/lib
    )

    if (AIO)
            message("-- Found libaio")
    else()
            message("-- Required libaio not found")
            message(FATAL_ERROR "is libaio-devel rpm installed?")
    endif()


## Specify compiler through command line


	cmake -DCMAKE_CXX_COMPILER=g++-4.7 .. -DCMAKE_C_COMPILER=gcc-4.7

This wiki page provides more information on 
[setting alternative compiler](http://www.cmake.org/Wiki/CMake_FAQ#How_do_I_use_a_different_compiler.3F)




## Install Prefix Default and User-Specified


First, in the `CMakeList.txt` file, we need a few install commands:

    install(TARGETS fgr DESTINATION lib)
    install(FILES fgr.h DESTINATION include)

We can also copy arbitrary files such as:

    install( FILES "${PROJECT_SOURCE_DIR}/x.map" DESTINATION etc)
    install( FILES "${PROJECT_SOURCE_DIR}/y.map" DESTINATION etc)
    install( FILES "${PROJECT_SOURCE_DIR}/z.map" DESTINATION etc)



The equivalent to autotools configure prefix command are
`CMAKE_INSTALL_PREFIX` variable, which you can set when you initiate cmake:

	cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make all install

If you want to specify a default, then

	set (CMAKE_INSTALL_PREFIX /usr/local/)


As far as uninstall goes, CMake doesn't provide such built-in, but the
[FAQ](http://www.cmake.org/Wiki/CMake_FAQ#Can_I_do_.22make_uninstall.22_with_CMake.3F)
does provide examples for doing so. For Unix, an easier way out is:

    xargs rm < install_manifest.txt

