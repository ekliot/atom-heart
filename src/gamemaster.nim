##[
filename: gamemaster.nim

Autoloaded singleton access across the game for meta-game controls
]##

import
  godot, node
import chars.player.player

gdobj GameMaster of Node:
  var PLAYER*:Player = nil

  method init*() =
    add_user_signal("player_set", "player")

  proc set_player*(p: Player) {.gdExport.} =
    if is_nil PLAYER:
      PLAYER = p
      emit_signal("player_set", PLAYER)
