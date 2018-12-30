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

onready var current_health = float(MAX_HEALTH)

func update_health(amt):
  current_health += amt
  .update_health(amt)
