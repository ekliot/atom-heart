"""
filename: airborne.gd
"""

extends "player_state.gd"

# func _init():
#   ID = 'airborne'


"""
=== STATE OVERRIDES
"""

func _on_enter(state_data={}, last_state=null):
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
  var _vel = player.velocity
  var max_v = player.MAX_VEL

  # move_cap tells us whether to bother accelerating on the x-axis
  #   move_cap is 0 if the player is already moving faster than the player ought to accelerate themself
  #   e.g. if an explosion pushes a player at velocity MAX*2, the player shouldn't be able to walk any faster, and therefore shouldn't accelerate on the x-axis until their velocity drops below MAX
  var move_cap = int(abs(_vel.x) <= max_v)

  _vel = update_velocity(_vel, player.ACCEL * Vector2(move_cap, 1), h_dir)
  _vel = PHYS.cap_velocity(_vel, max_v, PHYS.CAP_MASK_X)

  player.apply_velocity(_vel)
