"""
filename: move.gd
"""

extends "enemy_state.gd"

var to = null


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data, last_state):
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

  move_step()

  # if we've stopped moving (such as hitting a wall), return to our last state (idle)
  if not host.velocity.x:
    return FSM.START_STATE

  return ._on_physics_process(delta)


"""
=== CORE METHODS
"""

func move_step():
  var _vel = update_velocity()
  _vel = PHYSICS.cap_velocity(_vel, player.MAX_VEL)
  # TODO friction?
  player.apply_velocity(_vel)
