"""
filename: arm.gd
"""

class_name Arm
extends Node

"""
TODO signals
on_fire
on_strike
charge_inc
point
"""

"""
=== PROPERTIES
"""

"""
states are:
  - idle
  - charging
  - firing
  - striking
"""
onready var FSM = $StateMachine

"""
--- Visual constants
"""
export (String, 'left', 'right') var ARM_SIDE
export (SpriteFrames) var SPRITE_FRAMES = null
# where the shoulder is located, relative to self
export (Vector2) var ANCHOR_POS := Vector2()
# where the hand is located, relative to self
export (Vector2) var FIRING_POS := Vector2()

"""
--- Mechanical constants
"""
var MIN_FORCE := 1.0
var MAX_FORCE := 5.0
var CONE_ARC := 30.0 # [0.0, 60.0] degrees
var CONE_WIDTH := 0.5 # [0.0, 1.0]
# modifies how long the blast cone is
# this gets multiplied by the calculated force
var CONE_LENGTH := 1.0

# this represents how many seconds a charge can be held before it must be released
var MAX_CHARGE := 1.0 # [0.0, 1.0]
# how quickly in relation to dt charge increases
var CHARGE_RATE := 1.0 # [0.01, 10.0]

# the input action associated with this arm
onready var ACTION:String = 'attack_%s' % ARM_SIDE

var point_dir := Vector2(1.0, 0.0) setget, get_point_dir


"""
=== INIT
"""

func _ready() -> void:
  if SPRITE_FRAMES:
    $Sprite.set_frames(SPRITE_FRAMES)
    # TODO set sprite position
  else:
    LOGGER.warning(self, "sprite frames not provided")

  FSM.connect('state_change', self, '_on_state_change')
  FSM.start('idle')

func _on_state_change(state_from:String, state_to:String) -> void:
  LOGGER.debug(FSM, "changed state from %s to %s" % [state_from, state_to])


"""
=== CORE
"""

func proportional_force(proportion:float) -> float:
  """
  get the proportional force b/w min and max
  e.g. proportion of 0.5 is halfway b/w min/max
  TODO make non-linear? e.g. logarithmic
  """
  var force = (MAX_FORCE - MIN_FORCE) * proportion
  return MIN_FORCE + force

func point_at_mouse() -> void:
  # only Canvas nodes can get global mouse mosition
  var mouse_pos:Vector2 = $Sprite.get_global_mouse_position()
  point_at(mouse_pos)

func point_at(pos:Vector2) -> void:
  if SPRITE_FRAMES:
    point_dir = pos - get_global_anchor_pos()
    $Sprite.set_angle(point_dir.angle())
  else:
    point_dir = pos - get_parent().get_node("Body").global_position
  point_dir = point_dir.normalized()

"""
=== HELPERS
"""

func get_sprite() -> Node2D:
  return $Sprite as Node2D

func get_sprite_global_pos() -> Vector2:
  if SPRITE_FRAMES:
    return $Sprite.global_position
  else:
    return get_parent().get_node("Body").global_position

func get_global_anchor_pos() -> Vector2:
  return get_sprite_global_pos() + ANCHOR_POS

func get_global_firing_pos() -> Vector2:
  return get_sprite_global_pos() + FIRING_POS

func get_point_dir() -> Vector2:
  return point_dir
