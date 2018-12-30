"""
filename: brain.gd
"""

extends "../brain.gd"

func idle():
  if can_see(GM.PLAYER):
    emit_signal('fire_at', GM.PLAYER)
