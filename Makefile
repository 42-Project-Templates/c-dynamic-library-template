ifeq ($(HOSTTYPE),)
	HOSTTYPE := $(shell uname -m)_$(shell uname -s)
endif

NAME := libft_template_$(HOSTTYPE).so
LIB_NAME := libft_template.so

INCS := include

LDFLAGS :=
LDLIBS :=

SRC_DIR := src
BUILD_DIR := .build

SRCS := ft_putchar.c

OBJS := $(SRCS:%.c=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CC := gcc
CFLAGS := -Wall -Werror -Wextra
CPPFLAGS := $(addprefix -I, $(INCS)) -MMD -MP

RM := rm -rf

all: $(NAME)

debug: CFLAGS += -g -DDEBUG
debug: all

address: CFLAGS += -fsanitize=address -g
address: re

thread: CFLAGS += -fsanitize=thread -g
thread: re

print-%: ; @echo $* = $($*)

$(NAME): $(BUILD_DIR) $(OBJS)
	$(CC) $(CFLAGS) -shared $(CPPFLAGS) $(OBJS) -o $(NAME) $(LDFLAGS) $(LDLIBS)
	ln -sf ./$(NAME) ./$(LIB_NAME)

$(BUILD_DIR):
	@test -d $@ || mkdir -p $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -fPIC $(CPPFLAGS) -c $< -o $@

clean:
	$(RM) $(BUILD_DIR)

fclean: clean
	$(RM) $(NAME) $(LIB_NAME)

re: fclean all

-include $(DEPS)

.PHONY: all clean fclean re debug address thread
