# O (Output) is the build directory
ifeq ($O,)
O = .
endif

# files
SRCS = $(wildcard *.c)
DEPS = $(SRCS:%.c=$O/%.d)
OBJS = $(SRCS:%.c=$O/%.o)
BINS = $O/foo

# options
override CPPFLAGS +=
override CFLAGS += -Wall -Wextra -Werror
override LDFLAGS +=

# first rule (default)
all:

# dependencies
ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

# rules

$O:
	@ mkdir -p $O

$O/%.d: $(notdir %.c) | $O
	@ $(CC) -MM -MT '$@ $O/$*.o' $(CPPFLAGS) -MF $@ $< || rm -f $@

$O/%.o: $(notdir %.c)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(BINS): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

.PHONY: all
all: $(BINS)

.PHONY: clean
clean:
	- rm -f $(DEPS) $(OBJS) $(BINS)
