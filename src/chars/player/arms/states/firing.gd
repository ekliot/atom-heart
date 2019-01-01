"""
filename: firing.gd
"""

extends "arm_state.gd"

const Blast = preload("res://src/effects/blasts/Blast.tscn")

var charge = 0.0

func _on_enter(state_data={}, last_state=null):
  charge = state_data['charge']

  arm.get_sprite().animate('fire')

  _blast_off()

  return ._on_enter(state_data, last_state)

func _blast_off():
  var blast = Blast.instance()
  GM.LEVEL.add_child(blast)

  # multiply force by the proportional size of the cone
  var force = blast.build_cone(arm, charge, arm.point_dir)

  # negative because, if the arm is pointing down, we want to launch up
  var launch_dir = -arm.point_dir
  LOGGER.debug(self, "launching in direction %s with force %s" % [launch_dir, force])
  arm.get_parent().push(force, launch_dir)

func _on_leave():
  return ._on_leave()

func _on_process(delta):
  return ._on_process(delta)

func _on_physics_process(delta):
  # return ._on_physics_process(delta)
  return 'idle'

func _on_animation_finished(sprite):
  return 'idle'
