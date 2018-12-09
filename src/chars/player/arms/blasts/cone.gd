"""
filename: cone.gd
"""

extends Area2D

signal updated

var current = false

var origin = Vector2() setget set_origin
var dir = Vector2()
var dist = 0.0
var arc = 0.0

var resolution = 0

# TODO this ought to be textures/shaders
var colors = PoolColorArray([Color(1.0, 0.0, 0.0)])

var cone_area = CollisionPolygon2D.new()
var cone_path = PoolVector2Array()

func _init(_orig, _dir, _dist, _arc, _res=10):
  set_origin(_orig) # cone origin, a Vector2
  set_direction(_dir) # cone direction, a Vector2
  set_distance(_dist) # how long the cone is, a float
  set_arc(_arc) # provided in degrees, a float
  self.resolution = _res

  _build_shape()

func _draw():
  if not current:
    _build_shape()
  draw_polygon(cone_path, colors)

func _build_shape():
  cone_path = PoolVector2Array()
  cone_path.push_back(origin)

  # calculate the starting angle in degrees:
  #   angle of cone direction + half the desired arc
  var ang_start = rad2deg(self.dir.angle()) + arc / 2.0

  # add a point for each of the R "slices"
  #   R := resolution
  for r in range(resolution + 1):
    # what is the angle (in radians) of this slice?
    #   Rth slice angle-length := r * arc / resolution
    #   starting angle + <Rth slice angle-length> - desired arc
    var angle = deg2rad(ang_start + r * arc / resolution - arc)
    # what is the vector location of this slice?
    var from_center = origin + dist * Vector2(cos(angle), sin(angle))
    cone_path.push_back(from_center)

  cone_area.set_polygon(cone_path)
  current = true

func _update():
  if current:
    current = false
    emit_signal('updated')

func set_origin(_orig):
  if origin != _orig:
    origin = _orig
    _update()

func set_direction(_dir):
  if dir != _dir:
    dir = _dir
    _update()

func set_distance(_dist):
  if dist != _dist:
    dist = _dist
    _update()

func set_arc(_arc):
  if arc != _arc:
    arc = _arc
    _update()
