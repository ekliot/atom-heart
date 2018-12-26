"""
filename: arm.gd
"""

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
export (Vector2) var ANCHOR_POS = Vector2()
# where the hand is located, relative to self
export (Vector2) var FIRING_POS = Vector2()

"""
--- Mechanical constants
"""
export (float) var MIN_FORCE = 1.0
export (float) var MAX_FORCE = 5.0
export (float, 0.0, 60.0) var CONE_ARC = 30.0 # degrees
export (float, 0.0, 1.0) var CONE_WIDTH = 0.5
# modifies how long the blast cone is
# this gets multiplied by the calculated force
export (float) var CONE_LENGTH = 1.0

# the input action associated with this arm
onready var ACTION = 'attack_%s' % ARM_SIDE

var point_dir = Vector2(1.0, 0.0) setget, get_point_dir


"""
=== INIT
"""

func _ready():
  if SPRITE_FRAMES:
    $Sprite.set_frames(SPRITE_FRAMES)
    # TODO set sprite position
  else:
    LOGGER.warning(self, "sprite frames not provided")

  FSM.connect('state_change', self, '_on_state_change')
  FSM.start('idle')

func _on_state_change(state_from, state_to):
  LOGGER.debug(FSM, "changed state from %s to %s" % [state_from, state_to])


"""
=== CORE
"""

func proportional_force(proportion):
  # TODO make non-linear?
  var force = (MAX_FORCE - MIN_FORCE) * proportion
  return MIN_FORCE + force

func point_at_mouse():
  # only Canvas nodes can get global mouse mosition
  var mouse_pos = $Sprite.get_global_mouse_position()
  point_at(mouse_pos)

func point_at(pos):
  if SPRITE_FRAMES:
    point_dir = pos - get_global_anchor_pos()
    $Sprite.set_angle(point_dir.angle())
  else:
    point_dir = pos - get_parent().get_node("Body").global_position
  point_dir = point_dir.normalized()

"""
=== HELPERS
"""

func get_sprite():
  return $Sprite

func get_sprite_global_pos():
  if SPRITE_FRAMES:
    return $Sprite.global_position
  else:
    return get_parent().get_node("Body").global_position

func get_global_anchor_pos():
  return get_sprite_global_pos() + ANCHOR_POS

func get_global_firing_pos():
  return get_sprite_global_pos() + FIRING_POS

func get_point_dir():
  return point_dir
