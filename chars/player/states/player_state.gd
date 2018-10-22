"""
filename: player_state.gd
"""

extends "res://util/states/state.gd"

var player = null

func _ready():
  FSM.connect('ready', self, '_set_player')

func _set_player():
  if not player:
    player = FSM.HOST

"""
=== CORE METHODS
"""

func update_velocity(vel=player.get_velocity(), accel=player.ACCEL, h_dir=player.get_h_dir()):
  accel.x *= h_dir
  vel += accel
  return vel

func jump(vel):
  vel.y -= player.JUMP_HEIGHT
  return vel
