"""
filename: physics.gd

a collection of physics constants and helper methods
"""

extends Node

const FRICTION_AIR = 0.3
const GRAVITY = 25.0
const UP = Vector2(0, -1)

enum COLLISON_LAYERS {
  COL_PL_MOV,
  COL_PL_DMG,
  COL_NPC_MOV,
  COL_NPC_DMG,
  COL_BLAST
}

"""
=== COLLISION LAYERS

  enum: 0 1 2 3 4
  bits: x x x x x xxxxxxxxxxxxxxxxxxxxxxxxxxx
        ^ ^ ^ ^ ^ ^^^^^^^^^^^^^^^^^^^^^^^^^^^
        | | | | |--- Blast blocking
        | | | |--- NPC damage
        | | |--- NPC movement
        | |--- Player damage
        |--- Player movement

"""

func apply_friction_flt(flt, friction, to=0.0):
  return lerp(flt, to, friction)

func apply_friction_vec(vec, friction, to=Vector2()):
  return Vector2(apply_friction_flt(vec.x, friction, to.x),
                 apply_friction_flt(vec.y, friction, to.y))

func update_velocity(vel, accel):
  """
  given a velocity vector, acceleration vector
  return a velocity vector with acceleration and movement applied
  """
  return vel + accel

func jump(vel, jump_force=GRAVITY*4):
  """
  return a velocity vector with player jump velocity applied
  """
  vel.y -= jump_force
  return vel

func cap_velocity(vel, cap): #, friction=null):

  # if friction:
  #   if abs(vel.x) > abs(cap.x):
  #     var x_dir = sign(vel.x)
  #     vel.x = apply_friction_flt(vel.x, friction, x_dir * cap.x)
  #
  #   if abs(vel.y) > abs(cap.y):
  #     var y_dir = sign(vel.y)
  #     vel.y = apply_friction_flt(vel.y, friction, y_dir * cap.y)
  # else:

  if vel.length_squared() > pow(cap, 2):
    var n = vel.normalized().abs()
    var v_cap = n * cap
    vel.x = min(max(vel.x, -v_cap.x), v_cap.x)
    vel.y = min(max(vel.y, -v_cap.y), v_cap.y)

  return vel
