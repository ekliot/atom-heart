"""
filename: brain.gd

Controller class for enemy AI. To be overriden by individual enemies
"""

extends Node

onready var BODY = get_parent()
onready var FSM = BODY.FSM
onready var STATES = FSM

var interruptor = null

func _ready():
  # body.FSM.connect('state_change', self, '_on_state_change')
  # connect to states?
  pass

func _on_state_change(state_from, state_to):
  """
  to be overridden by other brains
  connected to body.FSM in enemy.gd
  """
  pass

"""
=== PERCEPTION
"""

func look_at(dir):
  look_dir = dir

func line_of_sight():
  """
  return a list of seeable objects in line of sight
  """
  return []

func can_see(obj):
  """
  returns whether the object is seen
  """
  return obj in line_of_sight()


"""
=== STATE DIRECTIVES
"""

func idle():
  if interruptor:
    return interruptor
  return null

func airborne():
  if interruptor:
    return interruptor
  return null

func move(to):
  if interruptor:
    return interruptor
  return null

func chase(target):
  if interruptor:
    return interruptor
  return null

func attack(target):
  if interruptor:
    return interruptor
  return null
