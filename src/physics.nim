##[ filename: physics.gd
A collection of physics constants and helper methods
]##

import godot, node

const FrictionAir*: float = 0.3
const Gravity*: float = 25.0
const Up*: Vector2 = vec2(0, -1)

gdobj Physics of Node:
  proc apply_friction_to_flt(flt, friction: float, to = 0.0): float =
    ## apply a friction coefficient to a float until a target value

    # result = lerp(flt, friction, to)
    result = (1 - friction) * flt + friction * to
      # NIMIFY GDScript.lerp for floats not available in godot-nim?
      # equation from https://en.wikipedia.org/wiki/Linear_interpolation#Programming_language_support

  proc apply_friction_to_vec(vec: Vector2, friction:float, to: Vector2 = vec2()): Vector2 =
    ## apply a friction vector to a vector until a target value

    result = vec2(
      apply_friction_to_flt(vec.x, friction, to.x),
      apply_friction_to_flt(vec.y, friction, to.y)
    )

  proc cap_velocity(vel, cap: Vector2): Vector2 =
    ## clamp a velocity vector between upper and lower bounds
    ## cap axes must be >=0, or else that axis will not be clamped
    ## TODO built in friction?

    #[
    if friction:
      if abs(vel.x) > abs(cap.x):
        var x_dir = sign(vel.x)
        vel.x = apply_friction_to_flt(vel.x, friction, x_dir * cap.x)

        if abs(vel.y) > abs(cap.y):
          var y_dir = sign(vel.y)
          vel.y = apply_friction_to_flt(vel.y, friction, y_dir * cap.y)
        else:
    ]#

    let mod_cap = vec2(
      if cap.x < 0: vel.x else: cap.x,
      if cap.y < 0: vel.y else: cap.y
    )

    result = vec2(
      min(max(vel.x, -mod_cap.x), mod_cap.x),
      min(max(vel.y, -mod_cap.y), mod_cap.y)
    )
