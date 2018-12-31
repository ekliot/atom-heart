"""
filename: airborne.gd
"""

extends "player_state.gd"

# func _init():
#   ID = 'airborne'


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data, last_state):
  # play airborne animation
  # player.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

func _on_physics_process(delta):
  var h_dir = player.get_h_dir()

  if player.is_on_floor():
    if h_dir:
      return 'move'
    return FSM.START_STATE
  elif player.is_on_wall():
    return 'move' # TODO 'on_wall'

  move_step(h_dir)

  return ._on_physics_process(delta)


"""
=== CORE METHODS
"""

func move_step(h_dir):
  var _vel = update_velocity()
  var max_v = player.MAX_VEL
  _vel = PHYSICS.cap_velocity(_vel, max_v) # , player.get_friction())

  player.apply_velocity(_vel)
