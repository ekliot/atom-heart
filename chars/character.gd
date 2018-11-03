"""
filename: character.gd

common methods and attributes of kinematic characters
"""

extends KinematicBody2D

signal update_look_dir(old_dir, new_dir)
signal update_position(old_pos, new_pos)

signal recover_health(amt, new_hp, max_hp)
signal take_damage(from, amt, type)

onready var FSM = $StateMachine


"""
=== PROPERTIES
"""

"""
--- Physics constants
"""

var MAX_VEL = Vector2(200.0, -1.0)
var MIN_VEL = Vector2(40.0, -1.0)
var ACCEL   = Vector2(40.0, PHYSICS.GRAVITY) setget ,get_acceleration
var AIR_ACCEL_MOD = 0.4 setget ,get_air_accel_mod
var JUMP_HEIGHT = 200.0 setget ,get_jump_height

"""
--- Gameplay constants
"""

var MAX_HEALTH = 10

"""
--- Instance properties
"""

var velocity = Vector2() setget ,get_velocity
var look_dir = Vector2() setget ,get_look_dir
var current_health = MAX_HEALTH


"""
=== PRIVATES
"""

func _ready():
  FSM.start('idle')
  FSM.connect('state_change', self, '_on_state_change')

func _on_state_change(state_from, state_to):
  LOGGER.debug(self, "changed state from %s to %s" % [state_from, state_to])


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

func push_me(accel, dir, up=PHYSICS.UP):
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

func take_damage(from, amt, type=null):
  current_health -= amt
  # TODO check vs damage type and source
  emit_signal( 'take_damage', from, amt, type )


"""
=== HELPERS
"""

func is_airborne():
  return not is_on_floor() and not is_on_wall()

"""
--- Physics Set/Getters
"""

func get_velocity():
  return velocity

func get_max_velocity():
  return MAX_VEL

func get_velocity_flat():
  return velocity.abs().floor()

func get_acceleration():
  var accel = ACCEL
  if is_airborne():
    accel.x *= AIR_ACCEL_MOD
  return accel

func get_air_accel_mod():
  return AIR_ACCEL_MOD

func get_friction():
  """
  gets the friction applied to the KB at this moment in time
  """
  var friction = 0

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

func get_jump_height():
  return JUMP_HEIGHT

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
