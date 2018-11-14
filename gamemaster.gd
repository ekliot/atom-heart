extends Node

signal player_set(player)

var PLAYER = null setget set_player, get_player

func set_player(player):
  if not PLAYER:
    PLAYER = player
    emit_signal('player_set', PLAYER)

func get_player(player):
  return PLAYER
