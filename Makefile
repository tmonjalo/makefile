# files
SRCS = $(wildcard *.c)
DEPS = $(SRCS:%.c=%.d)
OBJS = $(SRCS:%.c=%.o)
BINS = foo

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

%.d: %.c
	@ $(CC) -MM -MT '$@ $*.o' $(CPPFLAGS) -MF $@ $< || rm -f $@

%.o: %.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(BINS): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

.PHONY: all
all: $(BINS)

.PHONY: clean
clean:
	- rm -f $(DEPS) $(OBJS) $(BINS)
