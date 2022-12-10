PROGRAM=geo
MAKE_INSTALL_BINDIR=/usr/bin
EXECUTABLE_NAME=$(PROGRAM)
INSTALLPATH=$(MAKE_INSTALL_BINDIR)

CC=gcc
LD=gcc
CFLAGS=-std=c11 -Og -g -Wall -Wextra -pedantic -pedantic-errors -Wconversion -Wsign-compare
# math
LDFLAGS=-lm
DEBUGGER=gdb

SOURCEFILES=$(wildcard *.c)
OBJECTFILES=$(wildcard *.c=.o)

DEPENDFILE=dependencies.mk

# Make Main Program
$(EXECUTABLE_NAME): depend $(OBJECTFILES)
	$(LD) -o $@ $(OBJECTFILES) $(LDFLAGS)

# $(LD) -o $@ $^ $(LDFLAGS)

# How to build Objects
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o$@

# Clean Build
rebuild: clean $(EXECUTABLE_NAME)

install: $(EXECUTABLE_NAME)
	install -m 0755 $(EXECUTABLE_NAME) $(INSTALLPATH)

uninstall:$(INSTALLPATH)/$(EXECUTABLE_NAME)
	rm -rf $(INSTALLPATH)/$(EXECUTABLE_NAME)


.PHONY: clean depend rebuild run debug install uninstall

run: $(EXECUTABLE_NAME)
	./$(EXECUTABLE_NAME) $(ARGS)

debug: $(EXECUTABLE_NAME)
	$(DEBUGGER) $(EXECUTABLE_NAME) $(ARGS)

depend: $(DEPENDFILE) $(SOURCEFILES)
	@gcc -MM $^ > $(DEPENDFILE)

force_depend: $(SOURCEFILES)
	@gcc -MM $^ > $(DEPENDFILE)

clean:
	rm -rf $(OBJECTFILES)
	rm -rf geo

# -include dont require include file needs to exist
-include $(DEPENDFILE)

# $@ target name
# $< first prereq
# $^ all prereq space sep
#
# gcc -M main.c Lists all includes
# gcc -MM main.c Lists local includes for main.c
