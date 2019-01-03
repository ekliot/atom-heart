"""
filename: enemy_state.gd
"""

extends "res://src/util/states/state.gd"

var brain:Brain = null

func set_host(host:Character) -> void:
  if not brain and host:
    brain = host.brain


"""
=== CORE METHODS
"""

func update_velocity(vel:=host.velocity,
                     accel:=host.ACCEL,
                     h_dir:=host.get_h_dir()) -> Vector2:
  return PHYS.update_velocity(vel, accel * Vector2(1, h_dir))

func jump(vel:Vector2, jump_force:float) -> Vector2:
  return PHYS.jump(vel, jump_force)
