# O (Output) is the build directory
ifeq ($O,)
O = .
endif
# V (Verbosity) is 0 (quiet) or 1 (verbose)
ifeq ($V,0)
override V =
endif

# files
SRCS = $(wildcard *.c)
DEPS = $(SRCS:%.c=$O/%.d)
OBJS = $(SRCS:%.c=$O/%.o)
BINS = $O/foo $O/bar

# options
override CPPFLAGS +=
override CFLAGS += -Wall -Wextra -Werror
override LDFLAGS +=

# first rule (default)
all:

# dependencies
ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
$O/foo: $O/foo.o
$O/bar: $O/bar.o $O/baz.o
endif

# rules verbosity
define ECHO_DO
@ $(if $V, echo $2, $(if $(strip $1), echo $1))
@ $2
endef

# rules

$O:
	$(call ECHO_DO, '  MKDIR   $@', \
	mkdir -p $O )

$O/%.d: $(notdir %.c) | $O
	$(call ECHO_DO, '  DEP     $(notdir $@)', \
	$(CC) -MM -MT '$@ $O/$*.o' $(CPPFLAGS) -MF $@ $< || rm -f $@ )

$O/%.o: $(notdir %.c)
	$(call ECHO_DO, '  CC      $(notdir $@)', \
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $< )

$(BINS):
	$(call ECHO_DO, '  LD      $(notdir $@)', \
	$(CC) $(LDFLAGS) -o $@ $^ )

.PHONY: all
all: $(BINS)

.PHONY: clean
clean:
	$(call ECHO_DO, '  RM      deps objs bins', \
	- rm -f $(DEPS) $(OBJS) $(BINS) )
