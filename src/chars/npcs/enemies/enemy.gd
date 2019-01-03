"""
filename: enemy.gd
"""

class_name Enemy
extends "../../character.gd"


"""
--- Gameplay constants
"""

export (int) var MAX_HEALTH := 10

"""
--- Instance properties
"""

onready var brain:Brain = $Brain
onready var current_health := float(MAX_HEALTH)

func _ready() -> void:
  FSM.connect('state_change', brain, '_on_state_change')
  ._ready()

func update_health(amt:float) -> void:
  current_health += amt
  .update_health(amt)
