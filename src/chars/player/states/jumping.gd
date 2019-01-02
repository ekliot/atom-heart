"""
filename: jumping.gd
"""

extends "player_state.gd"

# func _init():
#   ID = 'jumping'


const JUMP_IMPULSE = 300
const MAX_JUMP_TIME = 1.0 / 6.0
const JUMP_FORCE = JUMP_IMPULSE * MAX_JUMP_TIME / 3.0
var jumped = false
var jump_time = 0.0

"""
=== STATE OVERRIDES
"""

func _on_enter(state_data, last_state):
  # play airborne animation
  # player.animate(ID + move_dir_as_str())
  jumped = false
  jump_time = 0.0
  return ._on_enter(state_data, last_state)

func _on_physics_process(delta):
  var h_dir = player.get_h_dir()

  if player.is_on_wall():
    return 'move' # TODO 'wall jump'
  else:
    move_step(h_dir, delta)

  if player.velocity.y > 0:
    return 'airborne'

  return ._on_physics_process(delta)


"""
=== CORE METHODS
"""

func move_step(h_dir, delta):
  var _vel = player.velocity

  # so long as we are holding the jump button within the jump time, and this is the first time we tried to jump
  if Input.is_action_pressed('move_jump') and jump_time < MAX_JUMP_TIME and not jumped:
    var force = JUMP_FORCE if jump_time > 0.0 else JUMP_IMPULSE
    _vel = jump(player.velocity, force)
    jump_time += delta
  elif Input.is_action_just_released('move_jump') or jump_time >= MAX_JUMP_TIME:
    jumped = true

  _vel = update_velocity(_vel)

  var max_v = player.MAX_VEL
  _vel = PHYS.cap_velocity(_vel, max_v, PHYS.CAP_MASK_X)

  player.apply_velocity(_vel)


"""
=== HELPERS
"""

func get_jump_force():
  return JUMP_FORCE
