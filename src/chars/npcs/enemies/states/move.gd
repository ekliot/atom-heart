"""
filename: move.gd
"""

extends "enemy_state.gd"

var to = null


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data:={}, last_state:=''):
  if state_data.has('to'):
    to = state_data['to']
  # play movement animation
  # host.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

func _on_leave():
  to = null
  return ._on_leave()

func _on_physics_process(delta):
  var next = brain.move(to):
  if next:
    return next

  if not host.is_on_floor():
    return 'airborne'

  move_step(h_dir)

  # if we've stopped moving (such as hitting a wall), return to our last state (idle)
  if not host.velocity.x:
    return FSM.START_STATE

  return ._on_physics_process(delta)


"""
=== CORE METHODS
"""

func move_step():
  var _vel = host.velocity
  var max_v = host.MAX_VEL

  # move_cap tells us whether to bother accelerating on the x-axis
  #   move_cap is 0 if the host is already moving faster than the host ought to accelerate themself
  #   e.g. if an explosion pushes a host at velocity MAX*2, the host shouldn't be able to walk any faster, and therefore shouldn't accelerate on the x-axis until their velocity drops below MAX
  # var v_cap = host.MAX_VEL * _vel.normalized().abs()
  var move_cap = int(abs(_vel.x) <= max_v)

  _vel = update_velocity(_vel, host.ACCEL * Vector2(move_cap, 1), h_dir)
  _vel = PHYS.cap_velocity(_vel, host.MAX_VEL)

  # TODO friction?
  host.apply_velocity(_vel)
