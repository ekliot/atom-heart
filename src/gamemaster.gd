extends Node

signal player_set(player)

var PLAYER = null setget set_player, get_player
var LEVEL = null setget set_level, get_level

func set_player(player):
  if not PLAYER:
    PLAYER = player
    emit_signal('player_set', PLAYER)

func get_player():
  return PLAYER

func clear_level():
  LEVEL = null

func set_level(level):
  if not LEVEL:
    # TODO scene switching
    pass
  LEVEL = level

func get_level():
  return LEVEL
