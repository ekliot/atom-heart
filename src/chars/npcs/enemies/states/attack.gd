"""
filename: attack.gd
"""

extends "enemy_state.gd"


"""
=== STATE OVERRIDES
"""

var target = null

func _on_enter(state_data={}, last_state=null):
  if state_data.has('target'):
    target = state_data['target']

  # play movement animation
  # host.animate(ID + move_dir_as_str())

  return ._on_enter(state_data, last_state)

func _on_leave():
  target = null
  return ._on_leave()

func _on_physics_process(delta):
  var next = brain.attack(target)
  if next:
    return next

  move_step()

  return ._on_physics_process(delta)

func _on_animation_finished(ani_name):
  return ._on_animation_finished(ani_name)
