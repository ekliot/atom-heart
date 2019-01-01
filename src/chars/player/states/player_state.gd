"""
filename: player_state.gd
"""

extends "res://src/util/states/state.gd"

var player = null

func set_host(host):
  if not player:
    player = host


"""
=== CORE METHODS
"""

func update_velocity(vel=player.velocity, accel=player.ACCEL, h_dir=player.get_h_dir()):
  return PHYSICS.update_velocity(vel, accel * Vector2(h_dir, 1))

func jump(vel, jump_force):
  return PHYSICS.jump(vel, jump_force)
