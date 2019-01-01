"""
filename: enemy_state.gd
"""

extends "res://src/util/states/state.gd"

var brain = null

func set_host(host):
  if not brain and host:
    brain = host.brain


"""
=== CORE METHODS
"""

func update_velocity(vel=host.get_velocity(), accel=host.ACCEL, h_dir=host.get_h_dir()):
  return PHYSICS.update_velocity(vel, accel * Vector2(1, h_dir))

func jump(vel, jump_force):
  return PHYSICS.jump(vel, jump_force)
