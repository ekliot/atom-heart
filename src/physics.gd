"""
filename: physics.gd

a collection of physics constants and helper methods
"""

extends Node

const FRICTION_AIR = 0.3
const GRAVITY = 25.0
const UP = Vector2(0, -1)

enum COLL {COL_PL_MOV, COL_PL_DMG, COL_NPC_MOV, COL_NPC_DMG, COL_BLAST}
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

static func apply_friction_flt(flt:float, friction:float, to:=0.0) -> float:
  return lerp(flt, to, friction)

static func apply_friction_vec(vec:Vector2, friction:float, to=VEC_MASK_0, mask:=VEC_MASK_1) -> Vector2:
  return Vector2(
    apply_friction_flt(vec.x, friction, to.x) if mask.x else vec.x,
    apply_friction_flt(vec.y, friction, to.y) if mask.y else vec.y
  )

static func update_velocity(vel:Vector2, accel:Vector2) -> Vector2:
  """
  given a velocity vector, acceleration vector
  return a velocity vector with acceleration and movement applied
  """
  return vel + accel

static func jump(vel:Vector2, jump_force:=GRAVITY*4) -> Vector2:
  """
  return a velocity vector with player jump velocity applied
  """
  vel.y -= jump_force
  return vel

static func cap_velocity(vel:Vector2, cap:float, cap_mask:=VEC_MASK_1) -> Vector2:
  """
  cap_mask tells us whether to cap specific axes
  """
  if vel.length_squared() > pow(cap, 2):
    var n := (vel * cap_mask).normalized().abs()
    var v_cap := n * cap
    if v_cap.x and vel.x:
      vel.x = min(max(vel.x, -v_cap.x), v_cap.x)
    if v_cap.y and vel.y:
      vel.y = min(max(vel.y, -v_cap.y), v_cap.y)

  return vel
