CC = processing-java
PWD = $(shell pwd)
SRC_DIR = $(PWD)/src
BIN_DIR = $(PWD)/bin
OBJ_DIR = $(PWD)/obj
EXEC_NAME = main
DUMMY_DIR = $(PWD)/$(EXEC_NAME)

all: run

# If folder is named src, Processing demands main file to be src.pde. Let's fix that the dirty way!
link:
	@ln -s $(SRC_DIR) $(PWD)/$(EXEC_NAME)
	@echo "> Creating a symlink for the src/ directory..."

build: clean link
	@echo "> Building..."
	@echo ""
	@processing-java --sketch="$(DUMMY_DIR)" --build --output="$(OBJ_DIR)"

run: clean link
	@echo "> Building..."
	@echo ""
	@echo "> Application will start shortly..."
	@echo "? Press Ctrl+C to terminate the execution."
	@echo ""
	@processing-java --sketch="$(DUMMY_DIR)" --run --output="$(BIN_DIR)"

present: clean link
	@echo "> Building..."
	@echo ""
	@echo "> Application will start shortly..."
	@echo "? Press Ctrl+C to terminate the execution."
	@echo ""
	@processing-java --sketch="$(DUMMY_DIR)" --present --output="$(BIN_DIR)"

export: clean link
	@echo "> Exporting..."
	@echo ""
	@processing-java --sketch="$(DUMMY_DIR)" --export --output="$(BIN_DIR)"

clean:
	@echo "> Cleaning..."
	@rm -rf "$(OBJ_DIR)"
	@rm -rf "$(BIN_DIR)"
	@rm -rf "$(DUMMY_DIR)"
