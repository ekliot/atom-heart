"""
filename: enemy.gd
"""

extends "res://src/chars/character.gd"


"""
--- Gameplay constants
"""

export (int) var MAX_HEALTH = 10

"""
--- Instance properties
"""

onready var brain = $Brain
onready var current_health = float(MAX_HEALTH)

func _ready():
  FSM.connect('state_change', brain, '_on_state_change')
  ._ready()

func update_health(amt):
  current_health += amt
  .update_health(amt)
