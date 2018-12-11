"""
filename: physics.gd

a collection of physics constants and helper methods
"""

extends Node

const FRICTION_AIR = 0.3
const GRAVITY = 25.0
const UP = Vector2(0, -1)

"""
COLLISION LAYERS:
  1. Player movement
  2. Player damage
  3. NPC movement
  4. NPC damage
  5. Blast blocking
"""


func apply_friction_flt(flt, friction, to=0.0):
  return lerp(flt, to, friction)

func apply_friction_vec(vec, friction, to=Vector2()):
  return Vector2(apply_friction_flt(vec.x, friction, to.x),
                 apply_friction_flt(vec.y, friction, to.y))

func cap_velocity(vel, cap): #, friction=null):
  if cap.x < 0:
    cap.x = vel.x
  if cap.y < 0:
    cap.y = vel.y

  # if friction:
  #   if abs(vel.x) > abs(cap.x):
  #     var x_dir = sign(vel.x)
  #     vel.x = apply_friction_flt(vel.x, friction, x_dir * cap.x)
  #
  #   if abs(vel.y) > abs(cap.y):
  #     var y_dir = sign(vel.y)
  #     vel.y = apply_friction_flt(vel.y, friction, y_dir * cap.y)
  # else:
  vel.x = min(max(vel.x, -cap.x), cap.x)
  vel.y = min(max(vel.y, -cap.y), cap.y)

  return vel
