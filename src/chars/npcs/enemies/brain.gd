"""
filename: brain.gd

Controller class for enemy AI. To be overriden by individual enemies
"""

class_name Brain
extends Node

onready var body := get_parent()
onready var FSM := body.FSM
# onready var STATES = FSM

var interruptor := ''

func _ready() -> void:
  # body.FSM.connect('state_change', self, '_on_state_change')
  # connect to states?
  pass

func _process(dt:float) -> void:
  if interruptor:
    FSM.enter(interruptor)
    interruptor = ''

func _on_state_change(state_from:String, state_to:String) -> void:
  """
  to be overridden by other brains
  connected to body.FSM in enemy.gd
  """
  pass

"""
=== PERCEPTION
"""

func look_at(dir:Vector2) -> void:
  look_dir = dir

func line_of_sight() -> Array:
  """
  return a list of seeable objects in line of sight
  """
  return []

func can_see(obj:Node2D) -> bool:
  """
  returns whether the object is seen
  """
  return obj in line_of_sight()


"""
=== STATE DIRECTIVES
"""

func idle() -> String:
  return ''

func airborne() -> String:
  return ''

func move(to:Vector2) -> String:
  return ''

func chase(target:Node2D) -> String:
  return ''

func attack(target:Node2D) -> String:
  return ''
