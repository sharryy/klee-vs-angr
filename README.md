# klee-vs-angr

## Build

```sh
make            # bin/angr and bin/k.bc
```

## Run

```sh
make run-klee   # logs/klee.log
make run-angr   # logs/angr.log
```

Override paths if needed, e.g. `make run-angr PYTHON=/path/to/venv/bin/python` or `make KLEE_INC=/path/to/klee/include`.
