"""
filename: blast.gd
"""

extends Node

const BlastCone = preload("./cone.gd")

var arm = null
var power = 0.0
var dir = Vector2()

var origin = Vector2()
var cone = null

var elapsed = 0.0 # seconds
var duration = 1.0 # seconds

func _ready():
  $Cone.enable()

func build_cone(arm, force, launch_dir):
  self.arm = arm
  self.power = force / 3
  self.dir = launch_dir
  # DEV NOTE I _think_ this position should be local to the parent,
  # rather than a global position, but if Blast is always a child of
  # Level I think both shoud be equal?
  self.origin = arm.get_global_firing_pos() # - get_parent().global_position

  $Cone.setup(origin, dir, power, arm.BLAST_ARC)

  # TODO connect collision logic from cone to self

func _physics_process(dt):
  elapsed += dt
  if elapsed >= duration:
    self.queue_free()
