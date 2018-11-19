"""
filename: firing.gd
"""

extends './arm_state.gd'

var force = 0.0

func _on_enter(state_data={}, last_state=null):
  force = state_data['force']

  arm.get_sprite().animate('fire')

  var launch_dir = -arm.point_dir
  LOGGER.debug(self, "launching in %s with force %s" % [launch_dir, force])
  arm.get_parent().push_me(force, launch_dir)

  return ._on_enter(state_data, last_state)

func _on_leave():
  return ._on_leave()

func _update(delta):
  return ._update(delta)

func _physics_update(delta):
  # return ._physics_update(delta)
  return 'idle'

func _on_animation_finished(sprite):
  return 'idle'
