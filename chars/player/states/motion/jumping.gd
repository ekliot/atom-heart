"""
filename: jumping.gd
"""

extends '../player_state.gd'

# func _init():
#   ID = 'jumping'


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data, last_state):
  # play airborne animation
  # player.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

func _physics_update(delta):
  var h_dir = player.get_h_dir()

  if player.is_on_floor():
    move_step(h_dir)
  elif player.is_on_wall():
    return 'move' # TODO 'wall jump'


  if player.velocity.y <= 0:
    return 'airborne'

  return ._physics_update(delta)


"""
=== CORE METHODS
"""

func move_step(h_dir):
  var _vel = jump(player.velocity)
  _vel = update_velocity(_vel)

  var max_v = player.MAX_VEL
  _vel = PHYSICS.cap_velocity(_vel, max_v)

  player.apply_velocity(_vel)
