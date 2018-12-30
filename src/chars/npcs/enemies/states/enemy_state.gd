"""
filename: enemy_state.gd
"""

extends "res://src/util/states/state.gd"

onready var brain = host.brain

"""
=== CORE METHODS
"""

func update_velocity(vel=host.get_velocity(), accel=host.ACCEL, h_dir=host.get_h_dir()):
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
