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

const _ARM_SPRITE_ = preload("res://chars/player/arms/arm_sprite.gd")

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
export (Vector2) var ANCHOR_POS = Vector2(0.0, 0.0)

"""
--- Mechanical constants
"""
export (float) var MIN_FORCE = 200.0
export (float) var MAX_FORCE = 2000.0

onready var ACTION = 'attack_%s' % ARM_SIDE

func _ready():
  if SPRITE_FRAMES:
    var sprite = _ARM_SPRITE_.new()
    sprite.set_frames(SPRITE_FRAMES)
    # TODO set sprite position
    sprite.name = "Sprite"
    add_child(sprite)
  else:
    LOGGER.warning(self, "sprite frames not provided")

  FSM.connect('state_change', self, '_on_state_change')
  FSM.start('idle')

func _on_state_change(state_from, state_to):
  LOGGER.debug(FSM, "changed state from %s to %s" % [state_from, state_to])


func point_at_mouse():
  if SPRITE_FRAMES:
    # only Canvas nodes can get global mouse mosition
    var mouse_pos = get_sprite().get_global_mouse_position()
    point_at(mouse_pos)

func point_at(pos):
  if SPRITE_FRAMES:
    # TODO convert ANCHOR_POS to global coords
    var dir = (pos - get_global_anchor_pos())
    $Sprite.set_angle(dir)

func get_sprite():
  if SPRITE_FRAMES:
    return $Sprite

func get_global_root_pos():
  return self.global_position + ANCHOR_POS
