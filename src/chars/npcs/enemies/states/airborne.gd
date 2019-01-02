"""
filename: airborne.gd
"""

extends "enemy_state.gd"


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data={}, last_state=null):
  # play airborne animation
  # host.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

func _on_physics_process(delta):
  var h_dir = host.get_h_dir()

  if host.is_on_floor():
    if h_dir:
      return 'move'
    return FSM.START_STATE

  move_step(h_dir)

  return ._on_physics_process(delta)


"""
=== CORE METHODS
"""

func move_step(h_dir):
  var _vel = host.velocity
  var max_v = host.MAX_VEL

  # move_cap tells us whether to bother accelerating on the x-axis
  #   move_cap is 0 if the host is already moving faster than the host ought to accelerate themself
  #   e.g. if an explosion pushes a host at velocity MAX*2, the host shouldn't be able to walk any faster, and therefore shouldn't accelerate on the x-axis until their velocity drops below MAX
  var move_cap = int(abs(_vel.x) <= max_v)

  _vel = update_velocity(_vel, host.ACCEL * Vector2(move_cap, 1), h_dir)
  _vel = PHYS.cap_velocity(_vel, max_v, PHYS.CAP_MASK_X)

  host.apply_velocity(_vel)
