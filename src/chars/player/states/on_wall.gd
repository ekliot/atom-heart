extends "player_state.gd"

func _on_enter(state_data:={}, last_state:='') -> String:
  return ._on_enter(state_data, last_state)

func _on_leave() -> String:
  return ._on_leave()

func _on_process(dt:float) -> String:
  return ._on_process(dt)

func _on_physics_process(dt:float) -> String:
  return ._on_physics_process(dt)

func _on_input(ev:InputEvent) -> String:
  return ._on_input(ev)

func _on_unhandled_input(ev:InputEvent) -> String:
  return ._on_unhandled_input(ev)

func _on_animation_finished(ani_name:String) -> String:
  return ._on_animation_finished(ani_name)

func set_host(host:Node):
  pass
