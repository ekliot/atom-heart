"""
filename: brain.gd

Controller class for enemy AI. To be overriden by individual enemies
"""

extends Node

onready var body = get_parent()
onready var states = body.FSM.get_children()

func _on_state_change(state_from, state_to):
  pass

func look_at(dir):
  look_dir = dir

func go_to(pos):
  pass

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

func idle():
  """
  directive on what to do while idling
  """
  pass
