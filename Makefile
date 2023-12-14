#####################################
## PROJECT      : C GAME - PUNTO   ##
## DATE         : 2023             ##
## ENVIRONEMENT : Unix             ##
## DEPENDENCIES : OCML OCL CSFML   ##
## AUTHOR       : ORNSOLOT         ##
#####################################

##################
## Project Tree ##
##################

## Environement file(s)
#######################
EDR	= env
LOG = $(EDR)/$(BIN).log
ENV	= $(EDR)/$(BIN).toml

## Binary file(s)
#################
BDR	= bin
BXT	= .exe
BIN	= $(shell basename $(shell pwd))

## Source file(s)
#################
SDR	= src
SXT	= .c
SRC = $(shell find $(SDR) -name '*$(SXT)' ! -path '*/lib/*')

ODR	= obj
OXT	= .o
OBJ = $(subst $(SXT),$(OXT), $(subst $(SDR),$(ODR),$(SRC)))

## Dependencies file(s)
#######################
LDR	= $(SDR)/lib
IDR = -I $(SDR)/inc -I $(LDR)/*/$(SDR)/inc -I $(LDR)/*/$(LDR)/*/$(SDR)/inc
ELB = $(shell find $(LDR) -mindepth 1 -maxdepth 1 -not -empty -type d -printf '%f\n' | sort -k 2)
CLN = $(addprefix clean_, $(ELB))
LXT	= .a
LIB	= $(addprefix -l, $(ELB) csfml-graphics csfml-window csfml-audio csfml-system) 

#################
## Compilation ##
#################
CC		= gcc
CCFLAGS	= -g3 -Wall -Wextra $(IDR)

LK		= gcc
LDFLAGS	= -L $(LDR)

#######################
## MAKEFILE VARIABLE ##
#######################
MAKEFLAGS	+= --no-print-directory
HEAD		= $(LIFELINE)" ├──"
LEFT		= $(LIFELINE)" │ "
NODE		= $(LIFELINE)" ├── [✓]"
TAIL		= $(LIFELINE)" └── [✓]"

####################
## Makefile Rules ##
####################
.PHONY: re all clean $(BIN)

re: clean all

all: $(BIN)

clean: $(CLN)
	@rm -Rf $(ODR)
	@rm -f $(BDR)/$(BIN)$(BXT)

$(ELB):
	@echo "$(HEAD) $@"
	@make -C $(LDR)/$@ lib$@ LIFELINE='$(LEFT) '
	@echo "$(LEFT)"

$(ODR)/%.o: $(SDR)/%.c
	@mkdir -p $(@D)
	@$(CC) $(CCFLAGS) -o $@ -c $<
	@echo "$(NODE) $<"

$(BIN): $(ELB) $(OBJ)
	$(LK) $(CCFLAGS) $(LDFLAGS) -o $(BDR)/$@$(BXT) $(OBJ) $(LIB) 
	@echo "$(TAIL) $@$(BXT)"

$(CLN):
	@make -C $(LDR)/$(subst clean_,,$@) clean

#$(foreach src, $(ELB), make -C "$(LDR)/${src} clean") 