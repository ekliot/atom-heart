"""
filename: arm_state.gd
"""

extends 'res://util/states/state.gd'

var arm = null

func set_host(host):
  if not arm:
    arm = host
