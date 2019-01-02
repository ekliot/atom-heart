"""
filename: striking.gd
"""

extends "arm_state.gd"

const STRIKE_FORCE = 200.0

func _on_enter(state_data={}, last_state=null):
  # begin animation
  arm.get_sprite().animate('strike')
  var strike_dir = Vector2(sign(arm.point_dir.x), 0.0)
  arm.get_parent().push(STRIKE_FORCE, strike_dir)
  return ._on_enter(state_data, last_state)

func _on_leave():
  return ._on_leave()

func _on_process(delta):
  return ._on_process(delta)

func _on_physics_process(delta):
  # return ._on_physics_process(delta)
  return FSM.START_STATE

func _on_animation_finished(sprite):
  return FSM.START_STATE
