"""
filename: attack.gd
"""

extends "enemy_state.gd"


"""
=== STATE OVERRIDES
"""

var target: Node2D = null

func _on_enter(state_data:={}, last_state:=''):
  target = state_data.get('target', null)

  # play movement animation
  # host.animate(ID + move_dir_as_str())

  return ._on_enter(state_data, last_state)

func _on_leave() -> String:
  target = null
  return ._on_leave()

func _on_physics_process(dt:float) -> String:
  var next := brain.attack(target)
  if next:
    return next

  move_step()

  return ._on_physics_process(dt)

func _on_animation_finished(ani_name:String) -> String:
  return ._on_animation_finished(ani_name)
