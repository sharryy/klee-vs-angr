KLEE_INC ?= $(HOME)/kleener/include
CLANG    ?= clang
KLEE     ?= klee
PYTHON   ?= python3

all: bin/angr bin/k.bc

bin/angr: angr.c
	mkdir -p bin
	gcc -O0 angr.c -o bin/angr

bin/k.bc: klee.c
	mkdir -p bin
	$(CLANG) -I $(KLEE_INC) -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone klee.c -o bin/k.bc

run-klee: bin/k.bc
	mkdir -p logs
	$(KLEE) bin/k.bc 2>&1 | tee logs/klee.log
	ktest-tool klee-last/test*.ktest | tee -a logs/klee.log

run-angr: bin/angr
	mkdir -p logs
	$(PYTHON) run.py | tee logs/angr.log

clean:
	rm -rf bin klee-out-* klee-last

.PHONY: all run-klee run-angr clean
