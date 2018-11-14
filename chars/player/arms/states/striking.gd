"""
filename: striking.gd
"""

extends './arm_state.gd'

const STRIKE_FORCE = 200.0

func _on_enter(state_data={}, last_state=null):
  # begin animation
  arm.get_sprite().animate('strike')
  var strike_dir = Vector2(sign(arm.point_dir.x), 0.0)
  arm.get_parent().push_me(STRIKE_FORCE, strike_dir)
  return ._on_enter(state_data, last_state)

func _on_leave():
  return ._on_leave()

func _update(delta):
  return ._update(delta)

func _physics_update(delta):
  # return ._physics_update(delta)
  return 'idle'

func _on_animation_finished(sprite):
  return 'idle'
