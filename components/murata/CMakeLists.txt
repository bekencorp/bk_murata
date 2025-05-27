
set(incs
	.
	${project_dir}/main
	)

set(srcs
	)

armino_component_register(SRCS "${srcs}"
    INCLUDE_DIRS "${incs}")

target_link_libraries(${COMPONENT_LIB} INTERFACE "-Wl,--whole-archive")

if (CONFIG_MURATA_2KU)
	set (lib_murata lib2ku.a)
	foreach(lib_name ${lib_murata})
		add_prebuilt_library(${lib_name} "${CMAKE_CURRENT_SOURCE_DIR}/${lib_name}")
		target_link_libraries(${COMPONENT_LIB} INTERFACE ${lib_name})
	endforeach()
endif()

if (CONFIG_MURATA_2JS)
	set (lib_murata lib2js.a)
	foreach(lib_name ${lib_murata})
		add_prebuilt_library(${lib_name} "${CMAKE_CURRENT_SOURCE_DIR}/${lib_name}")
		target_link_libraries(${COMPONENT_LIB} INTERFACE ${lib_name})
	endforeach()
endif()

target_link_libraries(${COMPONENT_LIB} INTERFACE "-Wl,--no-whole-archive")