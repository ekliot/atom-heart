"""
filename: cone.gd
"""

extends Area2D

const Circle = preload("res://src/assets/Circle.tscn")

signal updated

var current = false

var origin = Vector2() setget set_origin
var dir = Vector2()
var dist = 0.0
var arc = 0.0
var width = 0.0

var resolution = 0

# TODO this ought to be textures/shaders
var colors = PoolColorArray([Color(1.0, 0.0, 0.0)])

var cone_path = PoolVector2Array()

var parsed = false
var collisions = []

"""
=== NODE OVERRIDES
"""

func _init():
  connect('body_shape_entered', self, '_save_collision_data')

func _ready():
  LOGGER.debug(self, "READY")

func _draw():
  if not current:
    _build_shape()
  draw_polygon(cone_path, colors)

func _save_collision_data(body_id, body, body_shape, area_shape):
  var _owner = self.shape_find_owner(area_shape)
  var _tform = self.transform

  var owner = body.shape_find_owner(body_shape)
  var shape = body.shape_owner_get_shape(owner, body_shape)
  var tform = body.transform

  var coll_data = [_tform, shape, tform]
  self.collisions.push_back(coll_data)
  LOGGER.debug(self, "Saved collision with %s" % body.name)

func _physics_process(dt):
  if parsed:
    return

  parsed = true
  disconnect('body_shape_entered', self, '_save_collision_data')

  # return

  # LOGGER.debug(self, get_overlapping_bodies())
  # LOGGER.debug(self, collisions)

  var _shape = $Shape.shape
  for data in collisions:
    var _tform = data[0]
    var shape = data[1]
    var tform = data[2]

    # print(Physics2DServer.shape_get_type(shape.get_rid()))
    # print(Physics2DServer.shape_get_data(shape.get_rid()))
    # var ext = Physics2DServer.shape_get_data(shape.get_rid())
    # print(tform.xform(ext))
    # print(Physics2DServer.shape_get_type(_shape.get_rid()))
    # print(Physics2DServer.shape_get_data(_shape.get_rid()))

    var contacts = _shape.collide_and_get_contacts(_tform, shape, tform)
    printt(shape, contacts)
    if contacts:
      for _pt in contacts:
        if _pt:
          # _draw_contact(_pt)
          var dest = _pt - origin
          if dest != Vector2():
            var r = BlastRay.new(origin, dest, collision_mask)
            add_child(r)
            var pt = r.get_collision_point()
            LOGGER.debug(self, "%s -> %s" % [_pt, pt])
            _draw_contact(pt)
          else:
            printt(origin, _pt)

func _draw_contact(pt):
  var c = Circle.instance()
  c.global_position = pt
  c.scale = Vector2(4, 4)
  add_child(c)

"""
=== PUBLIC CORE
"""

func enable():
  $Shape.disabled = false
  LOGGER.debug(self, "ENABLE")

func disable():
  $Shape.disabled = true

func setup(_orig, _dir, _dist, _arc, _width, _res=10):
  set_origin(_orig) # cone origin, a Vector2
  set_direction(_dir) # cone direction, a Vector2
  set_distance(_dist) # how long the cone is, a float
  set_arc(_arc) # provided in degrees, a float
  set_width(_width) # how wide the cone is, a float
  set_resolution(_res)

  _build_shape()

"""
=== SHAPE BUILDING
"""

func _build_shape():
  _build_points()

  # cone_area.set_polygon(cone_path)

  var shape = ConvexPolygonShape2D.new()
  shape.set_point_cloud(cone_path)
  $Shape.shape = shape

  current = true

func _build_points():
  cone_path = PoolVector2Array()
  cone_path.push_back(self.origin)

  var angle = self.dir.angle()
  var arc_pts = PoolVector2Array()
  var half_arc = deg2rad(self.arc / 2.0)
  arc_pts.append_array(
    MATHS.blast_points_parametric_left(angle - half_arc, self.width, self.dist, self.resolution)
  )
  arc_pts.append_array(
    MATHS.points_of_arc(angle, self.arc, self.dist, self.resolution)
  )
  arc_pts.append_array(
    MATHS.blast_points_parametric_right(angle + half_arc, self.width, self.dist, self.resolution)
  )

  var pt
  var casted = PoolVector2Array()

  for point in arc_pts:
    var ray = BlastRay.new(self.origin, point, collision_mask)
    add_child(ray)
    var isect = ray.get_collision_point()
    # LOGGER.debug(self, "%s ~> %s/%s" % [self.origin, self.origin + point, isect])
    if isect != Vector2():
      pt = isect
      _draw_contact(isect)
    else:
      pt = self.origin + point
    if not pt in cone_path:
      cone_path.push_back(pt)
    ray.queue_free()

"""
=== HELPERS
"""

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

func set_width(_width):
  if width != _width:
    width = _width
    _update()

func set_resolution(_res):
  if self.resolution != _res:
    self.resolution = _res
    _update()


class BlastRay:
  extends RayCast2D

  func _init(origin, dest, mask):
    enabled = true
    global_position = origin
    cast_to = dest
    collision_mask = mask

  func _ready():
    # LOGGER.debug(self, "%s => %s" % [global_position, cast_to])
    force_raycast_update()
