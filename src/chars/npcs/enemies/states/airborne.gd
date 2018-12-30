"""
filename: airborne.gd
"""

extends "enemy_state.gd"


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data, last_state):
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
  var _vel = update_velocity()
  var max_v = host.MAX_VEL
  _vel = PHYSICS.cap_velocity(_vel, max_v) # , host.get_friction())

  host.apply_velocity(_vel)
