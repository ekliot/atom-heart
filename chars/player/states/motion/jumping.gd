"""
filename: jumping.gd
"""

extends '../player_state.gd'

func _init():
  ID = 'jumping'


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data, last_state):
  # play airborne animation
  # player.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

# func _physics_update(delta):
#   var h_dir = player.get_h_dir()
#
#   if player.is_on_floor():
#     if h_dir:
#       return 'move'
#     return 'idle'
#   elif player.is_on_wall():
#     return 'move' # TODO 'on_wall'
#
#   move_step(h_dir)
#
#   return ._physics_update(delta)
#
#
# """
# === CORE METHODS
# """
#
# func move_step(h_dir):
#   var _vel = player.velocity
#
#   var accel = player.ACCEL
#   accel.x *= player.AIR_ACCEL_MOD
#
#   _vel = update_velocity(_vel, accel)
#
#   var max_v = player.MAX_VEL
#   max_v.x *= player.AIR_VEL_MOD
#   # max_v *= int(h_dir != 0)
#
#   _vel = PHYSICS.cap_velocity(_vel, max_v, player.get_friction()):
#
#   player.apply_velocity(_vel)
