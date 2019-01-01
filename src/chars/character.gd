"""
filename: character.gd

common methods and attributes of kinematic characters
"""

extends KinematicBody2D

signal update_look_dir(old_dir, new_dir)
signal update_position(old_pos, new_pos)

signal restore_health(amt, new_hp)
signal take_damage(amt, from, type)

onready var FSM = $StateMachine


"""
=== PROPERTIES
"""

"""
--- Physics constants
"""

var MAX_VEL = 400.0
var MIN_VEL = 20.0
var ACCEL   = Vector2(80.0, PHYSICS.GRAVITY) setget ,get_acceleration
var AIR_ACCEL_MOD = 0.4


"""
--- Instance properties
"""

var velocity = Vector2()
var look_dir = Vector2() setget ,get_look_dir


"""
=== PRIVATES
"""

func _ready():
  FSM.connect('state_change', self, '_on_state_change')
  FSM.start('idle')

  if DBG.DEBUG:
    add_child(DBG.VEL_POINT.instance())

func _on_state_change(state_from, state_to):
  LOGGER.debug(FSM, "changed state from %s to %s" % [state_from, state_to])


"""
=== CORE
"""

func apply_velocity(vel=velocity, up=PHYSICS.UP):
  """
  move the character by its current (default), or arbitrary, velocity
  """
  var _pos = get_position()
  velocity = move_and_slide(vel, up)
  if _pos != get_position():
    emit_signal('update_position', _pos, get_position())

func move(dist, dir):
  var _pos = get_position()
  var coll = move_and_collide(dist * dir)
  if _pos != get_position():
    emit_signal('update_position', _pos, get_position())
  if coll:
    pass # TODO collision signal

func push(accel, dir, up=PHYSICS.UP):
  """
  apply an impulse to the character's current velocity
  """
  var _pos = get_position()
  var impulse = velocity + accel * dir
  velocity = move_and_slide(impulse, up)
  if _pos != get_position():
    emit_signal('update_position', _pos, get_position())

func animate(anim_name):
  # TODO
  return

func take_damage(amt, from, type=null):
  # TODO check vs damage type and source
  emit_signal('take_damage', from, amt, type)
  update_health(amt)

func update_health(amt):
  # NOTE player and enemy health is different
  # DEV logic to be implemented by each implementer
  emit_signal('update_health', amt)


"""
=== HELPERS
"""

func is_airborne():
  return not is_on_floor() and not is_on_wall()

"""
--- Physics Set/Getters
"""

func get_velocity_flat():
  return velocity.abs().floor()

func get_acceleration():
  var accel = ACCEL
  if is_airborne():
    accel.x *= AIR_ACCEL_MOD
  return accel

func get_friction():
  """
  gets the friction applied to the KB at this moment in time
  """
  var friction = 0.0

  if is_on_floor():
    for slide_idx in get_slide_count():
      var collider = get_slide_collision(slide_idx).collider
      # some colliders don't have friction properties
      if collider.get('friction'):
        friction += collider.friction
  elif is_on_wall():
    # get wall friction
    pass
  else:
    friction = PHYSICS.FRICTION_AIR

  return max(min(friction, 1.0), 0.0)

func get_move_data():
  return {
    'cur_vel': get_velocity(),
    'max_vel': get_max_velocity(),
    'accel': get_accelerarion(),
    'friction': get_friction()
  }


"""
--- Control Set/Getters
"""

func get_h_dir():
  """
  Returns the player movement as a horizontal direction value
  To be overridden in extending classesy
    *  1 => right
    *  0 => still
    * -1 => left
  """
  return 0

func get_look_dir():
  return look_dir
