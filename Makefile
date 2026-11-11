KLEE_INC ?= $(HOME)/kleener/include
CLANG    ?= clang
KLEE     ?= klee
PYTHON   ?= python3

all: angr k.bc

angr: angr.c
	gcc -O0 angr.c -o angr

k.bc: klee.c
	$(CLANG) -I $(KLEE_INC) -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone klee.c -o k.bc

run-klee: k.bc
	$(KLEE) k.bc 2>&1 | tee klee.log
	ktest-tool klee-last/test*.ktest | tee -a klee.log

run-angr: angr
	$(PYTHON) run.py | tee angr.log

clean:
	rm -rf angr k.bc klee-out-* klee-last

.PHONY: all run-klee run-angr clean
