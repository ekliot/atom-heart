"""
filename: striking.gd
"""

extends './arm_state.gd'

func _on_enter(state_data={}, last_state=null):
  return ._on_enter(state_data, last_state)

func _on_leave():
  return ._on_leave()

func _update(delta):
  return ._update(delta)

func _physics_update(delta):
  return ._physics_update(delta)

func _parse_input(ev):
  return ._parse_input(ev)

func _parse_unhandled_input(ev):
  return ._parse_unhandled_input(ev)

func _on_animation_finished(ani_name):
  return ._on_animation_finished(ani_name)

func set_host(host):
  pass
