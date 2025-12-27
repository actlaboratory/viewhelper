# Architecture: x86 (default) or x64
!IF !DEFINED(ARCH)
ARCH=x86
!ENDIF

# Set architecture-specific flags
!IF "$(ARCH)"=="x64"
MACHINE=/MACHINE:X64
!ELSE
MACHINE=/MACHINE:X86
!ENDIF

CPPFLAGS= /nologo /W3 /c /EHsc /O2 /wd4819
LIBS= user32.lib Ole32.lib gdi32.lib
TARGET=viewHelper_$(ARCH).dll

# Object files with architecture suffix
COMMON_OBJ=common_$(ARCH).obj
CTLCOLOR_OBJ=ctlcolor_$(ARCH).obj
FINDRADIO_OBJ=findradiobuttons_$(ARCH).obj
OBJS=$(COMMON_OBJ) $(CTLCOLOR_OBJ) $(FINDRADIO_OBJ)

all: $(TARGET)

$(TARGET): $(OBJS)
	link /nologo /DLL $(MACHINE) $(OBJS) $(LIBS) /OUT:$(TARGET)

$(COMMON_OBJ): common.cpp
	cl $(CPPFLAGS) /Fo:$(COMMON_OBJ) common.cpp

$(CTLCOLOR_OBJ): ctlcolor.cpp
	cl $(CPPFLAGS) /Fo:$(CTLCOLOR_OBJ) ctlcolor.cpp

$(FINDRADIO_OBJ): findradiobuttons.cpp
	cl $(CPPFLAGS) /Fo:$(FINDRADIO_OBJ) findradiobuttons.cpp

clean:
	-del /Q *_x86.obj *_x64.obj viewHelper_x86.* viewHelper_x64.* 2>nul
