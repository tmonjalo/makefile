# files
SRCS = $(wildcard *.c)
OBJS = $(SRCS:%.c=%.o)
BINS = foo

# options
override CPPFLAGS +=
override CFLAGS += -Wall -Wextra -Werror
override LDFLAGS +=

# rules

.PHONY: all
all: $(BINS)
$(BINS): $(OBJS)

.PHONY: clean
clean:
	- rm -f $(OBJS) $(BINS)
