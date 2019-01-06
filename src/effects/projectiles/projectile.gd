"""
filename: projectile.gd

A template for a generic projectile. Extending classes must implement collision logic
"""

extends Node

signal hit

func move_me(dir, dist):
  self.position += dir * dist
