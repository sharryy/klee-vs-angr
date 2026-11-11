import logging

import angr
from angr import claripy

logging.getLogger("angr").setLevel(logging.ERROR)  # hide angr's warnings

proj = angr.Project("bin/angr", auto_load_libs=False)

i = claripy.BVS("i", 8)
stdin = angr.SimFileStream(name="stdin", content=i, has_end=True)
state = proj.factory.entry_state(
    stdin=stdin,
    add_options={angr.options.SYMBOLIC_WRITE_ADDRESSES},  # keep buf[i] symbolic
)

simgr = proj.factory.simulation_manager(state)
simgr.run()

print(f"paths: deadended={len(simgr.deadended)} errored={len(simgr.errored)}")
for n, s in enumerate(simgr.deadended):
    vals = sorted(s.solver.eval_upto(i, 256))
    print(f"\npath {n}: i in {vals[0]}..{vals[-1]} ({len(vals)} values)")
    if not s.posix.dumps(1):
        print("  stdout=b''")
        continue
    for v in vals:
        out = s.posix.dumps(1, extra_constraints=[i == v])
        print(f"  i={v:2d}  stdout={out}")
