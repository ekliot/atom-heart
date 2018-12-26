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
  self.power = force / 3 # HACK
  self.dir = launch_dir
  # DEV NOTE I _think_ this position should be local to the parent,
  # rather than a global position, but if Blast is always a child of
  # Level I think both shoud be equal?
  self.origin = arm.get_global_firing_pos() # - get_parent().global_position

  $Cone.setup(origin, dir, power, arm.BLAST_ARC, arm.BLAST_WIDTH)
  # yield($Cone, 'cone_built')

  # the proportional propulsive power of the blast
  var proportion = 2.0 - $Cone.avg_len

  # TODO connect collision logic from cone to self

  return proportion

func _physics_process(dt):
  elapsed += dt
  if elapsed >= duration:
    self.queue_free()
