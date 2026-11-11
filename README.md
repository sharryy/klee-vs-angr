# klee-vs-angr

The same one-byte out-of-bounds write (`buf[i]` with `buf[8]`, `i` up to 15/16), run under KLEE and under angr.

| File | What |
|---|---|
| `klee.c` | KLEE harness: `i` symbolic, `klee_assume(i < 16)` |
| `k.bc` | LLVM bitcode of `klee.c` (what KLEE runs) |
| `klee.log` | KLEE output plus `ktest-tool` dump of the generated tests |
| `angr.c` | Native program: reads `i` from stdin, rejects `i > 16` |
| `angr` | x86-64 binary of `angr.c` (`gcc -O0`) |
| `run.py` | Runs the binary in angr once for each `i` in 0..15 |
| `angr.log` | Output of `run.py` |

## Results

- KLEE: `memory error: out of bound pointer` at `klee.c:12`, test case `i = 8`.
- angr: all 16 inputs end normally (`errored=0`) and print `SECRET!`. angr reports nothing for `i >= 8`.

## Rebuild and run

```sh
make                     # builds angr and k.bc
make run-klee            # writes klee.log
make run-angr            # writes angr.log (needs angr installed)
```

`KLEE_INC`, `CLANG`, `KLEE` and `PYTHON` can be overridden, e.g. `make run-angr PYTHON=/path/to/venv/bin/python`.
