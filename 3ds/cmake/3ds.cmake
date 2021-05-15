include(/opt/devkitpro/devkitARM/share/devkitarm.cmake)

set (DKA_3DS_C_FLAGS "-D__3DS__ -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft -mword-relocations -ffunction-sections -fdata-sections")
set(CMAKE_C_FLAGS   "${DKA_3DS_C_FLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS "${DKA_3DS_C_FLAGS}" CACHE STRING "")
set(CMAKE_ASM_FLAGS "${DKA_3DS_C_FLAGS}" CACHE STRING "")

set(CMAKE_EXE_LINKER_FLAGS_INIT "-march=armv6k -mtune=mpcore -specs=3ds.specs")

set(CMAKE_FIND_ROOT_PATH
  ${DEVKITPRO}/devkitARM
  ${DEVKITPRO}/tools
  ${DEVKITPRO}/portlibs/3ds
  ${DEVKITPRO}/libctru
)

# Set pkg-config for the same
find_program(PKG_CONFIG_EXECUTABLE NAMES arm-none-eabi-pkg-config HINTS "${DEVKITPRO}/portlibs/3ds/bin")
if (NOT PKG_CONFIG_EXECUTABLE)
   message(WARNING "Could not find arm-none-eabi-pkg-config: try installing 3ds-pkg-config")
endif()

find_program(CTR_SMDHTOOL_EXE NAMES smdhtool HINTS "${DEVKITPRO}/tools/bin")
if (NOT CTR_SMDHTOOL_EXE)
	message(WARNING "Could not find smdhtool: try installing 3ds-tools")
endif()

find_program(CTR_3DSXTOOL_EXE NAMES 3dsxtool HINTS "${DEVKITPRO}/tools/bin")
if (NOT CTR_3DSXTOOL_EXE)
	message(WARNING "Could not find 3dsxtool: try installing 3ds-tools")
endif()

find_file(CTR_DEFAULT_ICON NAMES default_icon.png HINTS "${DEVKITPRO}/libctru" NO_CMAKE_FIND_ROOT_PATH)
if (NOT CTR_DEFAULT_ICON)
	message(WARNING "Could not find default icon: try installing libctru")
endif()

function(ctr_generate_smdh target)
	cmake_parse_arguments(SMDH "" "NAME;DESCRIPTION;AUTHOR;ICON" "" "${ARGN}")
	if (NOT DEFINED SMDH_NAME)
		set(SMDH_NAME "${CMAKE_PROJECT_NAME}")
	endif()
	if (NOT DEFINED SMDH_DESCRIPTION)
		set(SMDH_DESCRIPTION "Built with devkitARM & libctru")
	if (NOT DEFINED SMDH_AUTHOR)
		set(SMDH_AUTHOR "Unspecified Author")
	endif()
	endif()
	if (NOT DEFINED SMDH_ICON)
		set(SMDH_ICON "${CTR_DEFAULT_ICON}")
	endif()

	add_custom_command(
		OUTPUT "${target}"
		COMMAND ${CTR_SMDHTOOL_EXE} --create "${SMDH_NAME}" "${SMDH_DESCRIPTION}" "${SMDH_AUTHOR}" "${SMDH_ICON}" "${target}"
		VERBATIM
	)
endfunction()

function(ctr_create_3dsx target)


endfunction()

set(NINTENDO_3DS TRUE)


set(CTR_ROOT ${DEVKITPRO}/libctru)

set(CTR_STANDARD_LIBRARIES "-lctru -lm")
set(CMAKE_C_STANDARD_LIBRARIES "${CTR_STANDARD_LIBRARIES}" CACHE STRING "")
set(CMAKE_CXX_STANDARD_LIBRARIES "${CTR_STANDARD_LIBRARIES}" CACHE STRING "")
set(CMAKE_ASM_STANDARD_LIBRARIES "${CTR_STANDARD_LIBRARIES}" CACHE STRING "")

#for some reason cmake (3.14.3) doesn't appreciate having \" here
set(CTR_STANDARD_INCLUDE_DIRECTORIES "${CTR_ROOT}/include")
set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES "${CTR_STANDARD_INCLUDE_DIRECTORIES}" CACHE STRING "")
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES "${CTR_STANDARD_INCLUDE_DIRECTORIES}" CACHE STRING "")
set(CMAKE_ASM_STANDARD_INCLUDE_DIRECTORIES "${CTR_STANDARD_INCLUDE_DIRECTORIES}" CACHE STRING "")

link_directories( ${DEVKITPRO}/libctru/lib ${DEVKITPRO}/portlibs/3ds/lib )
