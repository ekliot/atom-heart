##[ filename: physics.gd
A collection of physics constants and helper methods
]##

import godot

gdobj Physics of Node:
  const FrictionAir = 0.3
  const Gravity = 25.0
  const Up = vector2(0, -1)

  proc apply_friction_flt(flt, friction: float, to = 0.0): float =
    result = lerp(flt, to, friction)


  proc apply_friction_vec(vec: vector2, friction:float, to: vector2 = vector2()): vector2 =
    result = vector2(
      apply_friction_flt(vec.x, friction, to.x),
      apply_friction_flt(vec.y, friction, to.y)
    )

  proc cap_velocity(vel, cap: vector2): vector2 =
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
