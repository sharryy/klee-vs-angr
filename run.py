import logging

import angr

logging.getLogger("angr").setLevel(logging.ERROR)  # hide angr's warnings

proj = angr.Project("bin/angr", auto_load_libs=False)

for i in range(16):
    state = proj.factory.entry_state(stdin=bytes([i]))
    simgr = proj.factory.simulation_manager(state)
    simgr.run()  # step until no state is left running

    out = simgr.deadended[0].posix.dumps(1) if simgr.deadended else None
    print(f"i={i:2d}  stdout={out}  errored={len(simgr.errored)}")
