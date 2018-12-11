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

var resolution = 0

# TODO this ought to be textures/shaders
var colors = PoolColorArray([Color(1.0, 0.0, 0.0)])

# var cone_area = CollisionPolygon2D.new()
var cone_path = PoolVector2Array()

var complete = false
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
  collisions.push_back(coll_data)
  LOGGER.debug(self, "Saved collision with %s" % body.name)

func _physics_process(dt):
  if complete:
    return

  complete = true
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
    # printt(shape, contacts)
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

func setup(_orig, _dir, _dist, _arc, _res=50):
  set_origin(_orig) # cone origin, a Vector2
  set_direction(_dir) # cone direction, a Vector2
  set_distance(_dist) # how long the cone is, a float
  set_arc(_arc) # provided in degrees, a float
  self.resolution = _res

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
  cone_path.push_back(origin)

  # calculate the starting angle in degrees:
  #   angle of cone direction + half the desired arc
  var ang_start = rad2deg(self.dir.angle()) + arc / 2.0

  """
  for r in range(resolution + 1):
    var angle = deg2rad(ang_start + r * arc / resolution - arc)
    var ray_dest = dist * Vector2(cos((angle - PI) / 2.0), sin(-angle) / 4.0)
    var ray = BlastRay.new(origin, ray_dest, collision_mask)
    add_child(ray)
    var isect = ray.get_collision_point()
    LOGGER.debug(self, "%s ~> %s/%s" % [origin, ray_dest, isect])
    if isect != Vector2():
      cone_path.push_back(isect)
      _draw_contact(isect)
    else:
      cone_path.push_back(origin + ray_dest)
    ray.queue_free()
  """

  # add a point for each of the R "slices"
  #   R := resolution
  for r in range(resolution + 1):
    # what is the angle (in radians) of this slice?
    #   Rth slice angle-length := r * arc / resolution
    #   starting angle + <Rth slice angle-length> - desired arc
    var angle = deg2rad(ang_start + r * arc / resolution - arc)
    print(rad2deg(angle))
    # what is the vector location of this slice?
    var ray_dest = dist * Vector2(cos(angle), sin(angle))
    var ray = BlastRay.new(origin, ray_dest, collision_mask)
    add_child(ray)
    var isect = ray.get_collision_point()
    LOGGER.debug(self, "%s ~> %s/%s" % [origin, ray_dest, isect])
    if isect != Vector2():
      cone_path.push_back(isect)
      _draw_contact(isect)
    else:
      cone_path.push_back(origin + ray_dest)
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


class BlastRay:
  extends RayCast2D

  func _init(origin, dest, mask):
    enabled = true
    global_position = origin
    cast_to = dest
    collision_mask = mask

  func _ready():
    LOGGER.debug(self, "%s => %s" % [global_position, cast_to])
    force_raycast_update()
