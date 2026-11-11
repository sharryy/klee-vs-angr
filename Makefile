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
	rm -rf klee-out
	$(KLEE) --output-dir=klee-out bin/k.bc 2>&1 | tee logs/klee.log
	ktest-tool klee-out/test*.ktest >> logs/klee.log

run-angr: bin/angr
	mkdir -p logs
	$(PYTHON) run.py | tee logs/angr.log

clean:
	rm -rf bin klee-out

.PHONY: all run-klee run-angr clean
