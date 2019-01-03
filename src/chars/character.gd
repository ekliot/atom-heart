"""
filename: character.gd

common methods and attributes of kinematic characters
"""

class_name Character
extends KinematicBody2D

signal update_look_dir(old_dir, new_dir)
signal update_position(old_pos, new_pos)

signal restore_health(amt, new_hp)
signal take_damage(amt, from, type)

onready var FSM := $StateMachine


"""
=== PROPERTIES
"""

"""
--- Physics constants
"""

var MAX_VEL := 400.0
var MIN_VEL := 20.0
var ACCEL := Vector2(80.0, PHYS.GRAVITY) setget ,get_acceleration # accel is modified if airborne
var AIR_ACCEL_MOD := 0.25


"""
--- Instance properties
"""

var velocity := Vector2()
var look_dir := Vector2() setget ,get_look_dir


"""
=== PRIVATES
"""

func _ready():
  FSM.connect('state_change', self, '_on_state_change')
  FSM.start('idle')

  if DBG.DEBUG:
    add_child(DBG.VEL_POINT.instance())

func _on_state_change(state_from:String, state_to:String):
  LOGGER.debug(FSM, "changed state from %s to %s" % [state_from, state_to])


"""
=== CORE
"""

func move(vec) -> void:
  var _pos := get_position()
  var coll := move_and_collide(vec)
  if _pos != get_position():
    emit_signal('update_position', _pos, get_position())
  if coll:
    pass # TODO collision signal

func apply_velocity(vel:=velocity, up:=PHYS.UP) -> void:
  """
  move the character by its current (default), or arbitrary, velocity
  """
  var _pos := get_position()
  velocity = move_and_slide(vel, up)
  if _pos != get_position():
    emit_signal('update_position', _pos, get_position())

func push(accel:float, dir:Vector2, up:=PHYS.UP) -> void:
  """
  apply an impulse to the character's current velocity
  """
  var _pos := get_position()
  var impulse := velocity + accel * dir
  velocity = move_and_slide(impulse, up)
  if _pos != get_position():
    emit_signal('update_position', _pos, get_position())

func animate(anim_name:String) -> void:
  # TODO
  return

func take_damage(amt:int, from:Node, type=null) -> void:
  # TODO check vs damage type and source
  emit_signal('take_damage', from, amt, type)
  update_health(amt)

func update_health(amt:float) -> void:
  # NOTE player and enemy health is different
  # DEV logic to be implemented by each implementer
  emit_signal('update_health', amt)


"""
=== HELPERS
"""

func is_airborne() -> bool:
  return not is_on_floor() and not is_on_wall()

"""
--- Physics Set/Getters
"""

func get_velocity_flat() -> Vector2:
  return velocity.abs().floor()

func get_acceleration() -> Vector2:
  var accel := ACCEL
  if is_airborne():
    accel.x *= AIR_ACCEL_MOD
  return accel

func get_friction() -> float:
  """
  gets the friction applied to the KB at this moment in time
  """
  var friction := 0.0

  if is_on_floor():
    for slide_idx in get_slide_count():
      var collider := get_slide_collision(slide_idx).collider
      # some colliders don't have friction properties
      if collider.get('friction'):
        friction += collider.friction
      elif collider.get('collision_friction'):
        friction += collider.collision_friction
  elif is_on_wall():
    # get wall friction
    pass
  else:
    friction = PHYS.FRICTION_AIR

  return max(min(friction, 1.0), 0.0)


"""
--- Control Set/Getters
"""

func get_h_dir() -> int:
  """
  Returns the player movement as a horizontal direction value
  To be overridden in extending classesy
    *  1 => right
    *  0 => still
    * -1 => left
  """
  return 0

func get_look_dir() -> Vector2:
  return look_dir
