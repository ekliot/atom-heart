"""
filename: player_state.gd
"""

extends "res://src/util/states/state.gd"

var player: Player = null

func set_host(_player:Player) -> void:
  if _player:
    player = _player


"""
=== CORE METHODS
"""

func update_velocity(vel:=player.velocity, accel:=player.ACCEL, h_dir:=player.get_h_dir()) -> Vector2:
  return PHYS.update_velocity(vel, accel * Vector2(h_dir, 1))

func jump(vel:Vector2, jump_force:float) -> Vector2:
  return PHYS.jump(vel, jump_force)
