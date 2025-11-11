# Architecture: x86 (default) or x64
ARCH ?= x86

# Use cmd.exe as shell on Windows
SHELL = cmd.exe

# Set architecture-specific flags
ifeq ($(ARCH),x64)
    MACHINE=/MACHINE:X64
else
    MACHINE=/MACHINE:X86
endif

CPPFLAGS= /nologo /W3 /c /EHsc /O2 /wd4819
CPPSOURCES= common.cpp ctlcolor.cpp findradiobuttons.cpp
OBJS=$(patsubst %.cpp, %_$(ARCH).obj, $(CPPSOURCES))
LIBS= user32.lib Ole32.lib gdi32.lib
TARGET=viewHelper_$(ARCH).dll

.SILENT:

$(TARGET): $(OBJS)
	link /nologo /DLL $(MACHINE) $(OBJS) $(LIBS) /OUT:$(TARGET)

$(OBJS): %_$(ARCH).obj: %.cpp
	cl $(CPPFLAGS) /Fo:$@ $<

.PHONY: clean
clean:
	-del /Q *_x86.obj *_x64.obj viewHelper_x86.* viewHelper_x64.*
