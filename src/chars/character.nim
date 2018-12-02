##[ filename: character.gd
Common methods and attributes of kinematic characters
]##

import strutils
import
  godot, kinematic_body_2d, kinematic_collision_2d
import physics
import util.states/[state_machine, state]
import util.logger

gdobj Character of KinematicBody2D:

  ##[
  === PROPERTIES
  ]##

  # NIMIFY does this work in absence of onready?
  var FSM: StateMachine = get_node("StateMachine")

  ##[
  --- Physics constants
  ]##

  var MAX_VEL: Vector2 = vec2(400.0, -1.0)
  var MIN_VEL: Vector2 = vec2(20.0, -1.0)
  var ACCEL:  Vector2 = vec2(80.0, Physics.Gravity)
  var AIR_ACCEL_MOD: float = 0.4

  ##[
  --- Gameplay constants
  ]##

  var MAX_HEALTH: int = 10

  ##[
  --- Instance properties
  ]##

  var velocity: Vector2 = vec2()
  var look_dir: Vector2 = vec2()
  var current_health: int = MAX_HEALTH


  ##[
  === PRIVATES
  ]##

  method ready*() =
    add_user_signal(
      "update_look_dir",
      new_array(new_variant "old_dir", new_variant "new_dir")
    )
    add_user_signal(
      "update_position",
      new_array(new_variant "old_pos", new_variant "new_pos")
    )

    add_user_signal(
      "recover_health",
      new_array(new_variant "amt", new_variant "new_hp", new_variant "max_hp")
    )
    add_user_signal(
      "take_damage",
      new_array(new_variant "from", new_variant "amt", new_variant "type")
    )

    discard FSM.connect("state_change", self, "_on_state_change")
    FSM.start("idle")

  method on_state_change*(state_from, state_to: State): void =
    logger.debug(FSM, "changed state from $s to $s" % [$state_from, $state_to])


  ##[
  === CORE
  ]##

  proc apply_velocity*(vel = self.velocity, up = physics.UP): void {.gdExport.}  =
    ## move the character by its current (default), or arbitrary, velocity

    let pos = self.position
    self.velocity = move_and_slide(vel, up)
    let cur_pos = self.position

    if pos != cur_pos:
      emit_signal("update_position", to_variant pos, to_variant cur_pos)

  proc push_me*(accel: float, dir: Vector2, up = physics.UP): void {.gdExport.} =
    ## apply an impulse to the character's current velocity

    let pos = self.position
    let impulse = self.velocity + accel * dir
    self.velocity = move_and_slide(impulse, up)
    let cur_pos = self.position

    if pos != cur_pos:
      emit_signal("update_position", to_variant pos, to_variant cur_pos)

  proc animate*(anim_name: string): void {.gdExport.} =
    ## TODO
    discard

  proc take_damage*(source: Variant, amt: int, dmg_type: Variant = nil): void {.gdExport.} =
    current_health -= amt
    # TODO check vs damage type and source
    emit_signal("take_damage", source, to_variant amt, dmg_type)


  ##[
  === HELPERS
  ]##

  proc is_airborne*(): bool {.gdExport.} =
    not is_on_floor() and not is_on_wall()

  ##[
  --- Physics Set/Getters
  ]##

  proc get_max_velocity*(): Vector2 {.gdExport.} =
    MAX_VEL

  proc get_velocity_flat*(): Vector2 {.gdExport.} =
    velocity.abs().floor()

  proc get_acceleration*(): Vector2 {.gdExport.} =
    result = ACCEL
    if is_airborne():
      # NIMIFY is *= a valid op?
      result.x *= AIR_ACCEL_MOD

  proc get_air_accel_mod*(): float {.gdExport.} =
    AIR_ACCEL_MOD

  proc get_friction*(): float {.gdExport.} =
    ## gets the friction applied to the KB at this moment in time

    result = 0.0

    if is_on_floor():
      var flt: float
      for slide_idx in 0..<get_slide_count():
        let collider = get_slide_collision(slide_idx).collider
        # some colliders don't have friction properties
        let f: Variant = collider.get_impl("friction")
        if not is_nil f:
          from_variant[float](flt, f)
          result += flt
    elif is_on_wall():
      # TODO get wall friction
      discard
    else:
      result = physics.FRICTION_AIR

    result = max(min(result, 1.0), 0.0)


  ##[
  --- Control Set/Getters
  ]##

  proc get_h_dir*(): int {.gdExport.} =
    ## Returns the player movement as a horizontal direction value
    ## To be overridden in extending classes
    ##   *  1 => right
    ##   *  0 => still
    ##   * -1 => left
    0

  proc get_look_dir*(): Vector2 {.gdExport.} =
    look_dir
