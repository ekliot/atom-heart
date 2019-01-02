"""
filename: physics.gd

a collection of physics constants and helper methods
"""

extends Node

const FRICTION_AIR = 0.3
const GRAVITY = 25.0
const UP = Vector2(0, -1)

enum COL_MASKS {
  PL_MOV = 1,
  PL_DMG = 2,
  NPC_MOV = 4,
  NPC_DMG = 8,
  BLAST = 16
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

const CAP_MASK_X = Vector2(1, 0)
const CAP_MASK_Y = Vector2(0, 1)

func cap_velocity(vel, cap, cap_mask=Vector2(1, 1)):
  """
  cap_mask tells us whether to cap specific axes
  """
  if vel.length_squared() > pow(cap, 2):
    var n = (vel * cap_mask).normalized().abs()
    var v_cap = n * cap
    if v_cap.x and vel.x:
      vel.x = min(max(vel.x, -v_cap.x), v_cap.x)
    if v_cap.y and vel.y:
      vel.y = min(max(vel.y, -v_cap.y), v_cap.y)

  return vel
