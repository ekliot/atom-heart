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
  if DBG.DEBUG:
    var blast_ang = rad2deg(launch_dir.angle())
    var vel = arm.get_parent().velocity
    var vel_ang = rad2deg(vel.angle())
    LOGGER.debug(self, "angle b/w host dir and blast dir is %s (%s - %s)" % [blast_ang - vel_ang, blast_ang, vel_ang])
    LOGGER.debug(self, "\tdot prod: %s" % launch_dir.dot(vel))
    LOGGER.debug(self, "\tangle_to: %s" % rad2deg(launch_dir.angle_to(vel)))
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
