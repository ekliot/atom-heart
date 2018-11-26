"""
filename: idle.gd
"""

extends './arm_state.gd'

# func _on_enter(state_data={}, last_state=null):
#   return ._on_enter(state_data, last_state)
#
# func _on_leave():
#   return ._on_leave()
#
# func _on_process(delta):
#   return ._on_process(delta)

func _on_physics_process(delta):
  if Input.is_action_just_pressed(arm.ACTION):
    return 'charging'
  return ._on_physics_process(delta)

# func _on_input(ev):
#   return ._on_input(ev)
#
# func _on_unhandled_input(ev):
#   return ._on_unhandled_input(ev)
#
# func _on_animation_finished(ani_name):
#   return ._on_animation_finished(ani_name)
