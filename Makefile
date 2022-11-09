PROGRAM=geo

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
$(PROGRAM): depend $(OBJECTFILES)
	$(LD) -o $@ $(OBJECTFILES) $(LDFLAGS)

# $(LD) -o $@ $^ $(LDFLAGS)

# How to build Objects
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o$@

# Clean Build
rebuild: clean $(PROGRAM)

.PHONY: clean depend rebuild run debug

run: $(PROGRAM)
	./$(PROGRAM) $(ARGS)

debug: $(PROGRAM)
	$(DEBUGGER) $(PROGRAM) $(ARGS)

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
