#
# Makefile for UNIX - unrar

# Mingw
CXX=c++
CXXFLAGS=-march=native -Os
DEFINES=-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_M_X64
STRIP=strip
AR=ar
LDFLAGS=-pthread
LIBS=-lPowrProf -lOleAut32 -lOle32 -lwbemuuid

##########################

COMPILE=$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEFINES)
LINK=$(CXX)

WHAT=UNRAR

UNRAR_OBJ=filestr.o recvol.o rs.o scantree.o qopen.o
LIB_OBJ=filestr.o scantree.o dll.o qopen.o

OBJECTS=rar.o strlist.o strfn.o pathfn.o smallfn.o global.o file.o filefn.o filcreat.o \
	archive.o arcread.o unicode.o system.o crypt.o crc.o rawread.o encname.o \
	resource.o match.o timefn.o rdwrfn.o consio.o options.o errhnd.o rarvm.o secpassword.o \
	rijndael.o getbits.o sha1.o sha256.o blake2s.o hash.o extinfo.o extract.o volume.o \
	list.o find.o unpack.o headers.o threadpool.o rs16.o cmddata.o ui.o isnt.o

.cpp.o:
	$(COMPILE) -D$(WHAT) -c $<

all:	unrar

install:	install-unrar

uninstall:	uninstall-unrar

clean:
	@del *.bak *~
	@del $(OBJECTS) $(UNRAR_OBJ) $(LIB_OBJ)
	@del unrar.exe libunrar.*

# We removed 'clean' from dependencies, because it prevented parallel
# 'make -Jn' builds.

unrar:	$(OBJECTS) $(UNRAR_OBJ)
	@del unrar.exe
	$(LINK) -o unrar $(LDFLAGS) $(OBJECTS) $(UNRAR_OBJ) $(LIBS)
	$(STRIP) unrar.exe

sfx:	WHAT=SFX_MODULE
sfx:	$(OBJECTS)
	@del default.sfx
	$(LINK) -o default.sfx $(LDFLAGS) $(OBJECTS)
	$(STRIP) default.sfx

lib:	WHAT=RARDLL
lib:	CXXFLAGS+=$(LIBFLAGS)
lib:	$(OBJECTS) $(LIB_OBJ)
	@del libunrar.*
	$(LINK) -shared -o libunrar.dll $(LDFLAGS) $(OBJECTS) $(LIB_OBJ)
	$(AR) rcs libunrar.a $(OBJECTS) $(LIB_OBJ)

install-unrar:
			install -D unrar $(DESTDIR)/bin/unrar

uninstall-unrar:
			rm -f $(DESTDIR)/bin/unrar

install-lib:
		install libunrar.so $(DESTDIR)/lib
		install libunrar.a $(DESTDIR)/lib

uninstall-lib:
		rm -f $(DESTDIR)/lib/libunrar.so
