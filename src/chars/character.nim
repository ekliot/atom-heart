##[ filename: character.gd
Common methods and attributes of kinematic characters
]##

import
  godot, physics
import util.states.state_machine

gdobj Character of KinematicBody2D:

  ##[
  === PROPERTIES
  ]##

  # NIMIFY does this work in absence of onready?
  let FSM = get_node("StateMachine")

  ##[
  --- Physics constants
  ]##

  let MaxVel: vector2 = vector2(400.0, -1.0)
  let MinVel: vector2 = vector2(20.0, -1.0)
  let Accel:  vector2 = vector2(80.0, Physics.Gravity)
  let AirAccelMod: float = 0.4

  ##[
  --- Gameplay constants
  ]##

  let MaxHealth: int = 10

  ##[
  --- Instance properties
  ]##

  var velocity: vector2 = vector2()
  var look_dir: vector2 = vector2()
  var current_health = MaxHealth


  ##[
  === PRIVATES
  ]##

  method ready*() =
    add_user_signal("update_look_dir", "old_dir", "new_dir")
    add_user_signal("update_position", "old_pos", "new_pos")

    add_user_signal("recover_health", "amt", "new_hp", "max_hp")
    add_user_signal("take_damage", "from", "amt", "type")

    FSM.connect("state_change", self, "_on_state_change")
    FSM.start("idle")

  method on_state_change*(state_from, state_to: State) =
    # NIMIFY strformat?
    Logger.debug(FSM, "changed state from %s to %s" % [state_from, state_to])


  ##[
  === CORE
  ]##

  proc apply_velocity(vel = velocity, up = Physics.Up) =
    ## move the character by its current (default), or arbitrary, velocity

    let pos: vector2 = get_position()
    velocity = move_and_slide(vel, up)

    let cur_pos: vector2 = get_position()
    if pos != cur_pos:
      emit_signal("update_position", pos, cur_pos)

  proc push_me(accel: float, dir: vector2, up = Physics.Up) =
    ## apply an impulse to the character's current velocity

    let pos: vector2 = get_position()
    let impulse = velocity + accel * dir
    velocity = move_and_slide(impulse, up)

    let cur_pos: vector2 = get_position()
    if pos != cur_pos:
      emit_signal("update_position", pos, cur_pos)

  proc animate(anim_name: string) =
    ## TODO
    discard

  proc take_damage(source: variant, amt: int, dmg_type: variant = nil) =
    ## NIMIFY source, dmg_type typing
    current_health -= amt
    # TODO check vs damage type and source
    emit_signal("take_damage", source, amt, dmg_type)


  ##[
  === HELPERS
  ]##

  proc is_airborne(): bool =
    result = not is_on_floor() and not is_on_wall()

  ##[
  --- Physics Set/Getters
  ]##

  proc get_velocity(): vector2 =
    result = velocity

  proc get_max_velocity(): float =
    result = MaxVel

  proc get_velocity_flat(): vector2 =
    result = velocity.abs().floor()

  proc get_acceleration(): vector2 =
    var accel: vector2 = Accel
    if is_airborne():
      # NIMIFY is *= a valid op?
      accel.x *= AirAccelMod
    result = accel

  proc get_air_accel_mod(): float =
    result = AIR_ACCEL_MOD

  proc get_friction(): float =
    ## gets the friction applied to the KB at this moment in time

    var friction = 0

    if is_on_floor():
      for slide_idx in get_slide_count():
        # NIMIFY collider type?
        var collider = get_slide_collision(slide_idx).collider
        # some colliders don't have friction properties
        if collider.get("friction"):
          friction += collider.friction
    elif is_on_wall():
      # TODO get wall friction
      discard
    else:
      friction = Physics.FrictionAir

    result = max(min(friction, 1.0), 0.0)


  ##[
  --- Control Set/Getters
  ]##

  proc get_h_dir(): int =
    ## Returns the player movement as a horizontal direction value
    ## To be overridden in extending classes
    ##   *  1 => right
    ##   *  0 => still
    ##   * -1 => left
    result = 0

  proc get_look_dir(): vector2 =
    result = look_dir
