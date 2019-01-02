"""
filename: idle.gd
"""

extends "enemy_state.gd"


"""
=== OVERRIDES
"""

func _on_enter(state_data, last_state):
  # play idle animation
  # fsm.host.animate(ID + move_dir_as_str())
  return ._on_enter(state_data, last_state)

func _on_physics_process(delta):
  var next = host.brain.idle()
  if next:
    return next

  # if we're in motion, apply friction
  if host.get_velocity_flat().x >= host.MIN_VEL.x:
    var _vel = host.velocity

    _vel = update_velocity(_vel, Vector2(0.0, PHYS.GRAVITY))
    _vel = PHYS.apply_friction_vec(_vel, host.get_friction())

    host.apply_velocity(_vel)
  else:
    # short circuit the last fractions of lerping velocity
    host.velocity = Vector2()

  return ._on_physics_process(delta)
