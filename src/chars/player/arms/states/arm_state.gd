"""
filename: arm_state.gd
"""

extends 'res://src/util/states/state.gd'

var arm = null

func set_host(host):
  if not arm:
    arm = host
    arm.get_node("Sprite").connect('animation_finished', self, '_on_animation_finished', [arm])
