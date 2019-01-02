"""
filename: idle.gd
"""

extends "player_state.gd"


"""
=== OVERRIDES
"""

func _on_enter(state_data, last_state):
  # play idle animation
  # fsm.host.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

func _on_physics_process(delta):
  if Input.is_action_just_pressed("move_jump"):
    return 'jumping'

  if not player.is_on_floor():
    return 'airborne'

  # if the player controls are set to move... don't just stand there, MOVE!
  if player.get_h_dir():
    return 'move'

  # if we're in motion, apply friction
  if player.get_velocity_flat().x >= player.MIN_VEL:
    var _vel = player.velocity

    _vel = update_velocity(_vel, Vector2(0.0, PHYS.GRAVITY))
    _vel = PHYS.apply_friction_vec(_vel, player.get_friction())

    player.apply_velocity(_vel)
  else:
    # short circuit the last fractions of lerping velocity
    player.velocity = Vector2()

  return ._on_physics_process(delta)
