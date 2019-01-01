"""
filename: player_state.gd
"""

extends "res://src/util/states/state.gd"

var player = null

func set_host(host):
  if not player and host:
    player = host


"""
=== CORE METHODS
"""

func update_velocity(vel=player.get_velocity(), accel=player.ACCEL, h_dir=player.get_h_dir()):
  """
  given a velocity vector, acceleration vector, and horizontal movement direction,
  return a velocity vector with acceleration and movement applied
  """
  accel.x *= h_dir
  vel += accel
  return vel

func jump(vel, jump_force):
  """
  return a velocity vector with player jump velocity applied
  """
  vel.y -= jump_force
  return vel
