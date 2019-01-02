"""
filename: cone.gd
"""

extends Area2D

const Circle = preload("res://src/assets/Circle.tscn")

signal cone_built

var built = false

var origin = Vector2()
var dir = Vector2()
var dist = 0.0
var arc = 0.0
var width = 0.0

# how many points to use for each arc
var resolution = 0

# TODO this ought to be textures/shaders
var colors = PoolColorArray([Color(1.0, 0.0, 0.0)])

# the shape of the blast cone
var cone_path = PoolVector2Array()

# flag for when collision checking is finished
var parsed = false
# the transform at time of collision detection
var coll_tform = null
# a collection of tuples, each with:
#   - collided shape
#   - that shape's transform
var collisions = []

# the average proportional length of the cone's rays, between 0.0 and 1.0
# used to determine proportional propulsive power of the blast
var avg_len = 0.0

"""
=== NODE OVERRIDES
"""

func _init():
  connect('body_shape_entered', self, '_save_collision_data')

func _ready():
  LOGGER.debug(self, "READY") # print-debugging order of operations

func _draw():
  if not built:
    _build_shape()
  draw_polygon(cone_path, colors)

func _physics_process(dt):
  """
  only for the first physics frame, execute logic on each collided object
  ideally, instead of arbitrary ray-casting in _build_shape(), we find collided objs
    here and use an optimal number of rays (e.g. one for each corner of collided objs)
  for now, we'll just execute damage logic and etc.
  """
  if parsed:
    return

  parsed = true
  disconnect('body_shape_entered', self, '_save_collision_data')

  """
  # LOGGER.debug(self, get_overlapping_bodies())
  # LOGGER.debug(self, collisions)

  var _shape = $Shape.shape
  for data in self.collisions:
    var shape = data[0]
    var tform = data[1]

    # XXX just some debugging on how physics shapes work
    # LOGGER.debug(self, Physics2DServer.shape_get_type(shape.get_rid()))
    # LOGGER.debug(self, Physics2DServer.shape_get_data(shape.get_rid()))
    # var ext = Physics2DServer.shape_get_data(shape.get_rid())
    # LOGGER.debug(self, tform.xform(ext))
    # LOGGER.debug(self, Physics2DServer.shape_get_type(_shape.get_rid()))
    # LOGGER.debug(self, Physics2DServer.shape_get_data(_shape.get_rid()))

    # DEV this does not work as expected, returns only a single point for RectangleShape2D (other shapes too?)
    var contacts = _shape.collide_and_get_contacts(self.coll_tform, shape, tform)
    # LOGGER.debug(self, "%s // %s" % [shape, contacts])
    if contacts:
      for _pt in contacts:
        if _pt:
          # _draw_contact(_pt)
          var dest = _pt - origin
          if dest != Vector2():
            var r = BlastRay.new(origin, dest, PHYS.COL_BLAST)
            add_child(r)
            var pt = r.get_collision_point()
            LOGGER.debug(self, "%s -> %s" % [_pt, pt])
            _draw_contact(pt)
          else:
            printt(origin, _pt)
  """

  # TODO deal damage to anything in the PHYS.COL_NPC_DMG coll-layer

"""
=== PRIVATES
"""

func _save_collision_data(body_id, body, body_shape, area_shape):
  var owner = body.shape_find_owner(body_shape)
  var shape = body.shape_owner_get_shape(owner, body_shape)
  var tform = body.transform

  var coll_data = [shape, tform]
  self.collisions.push_back(coll_data)
  LOGGER.debug(self, "Saved collision with %s" % body.name)

func _draw_contact(pt):
  """
  XXX this is just for debugging collision points
  """
  if DBG.DEBUG:
    var c = Circle.instance()
    c.global_position = pt
    c.scale = Vector2(4, 4) # HACK
    add_child(c)

"""
=== PUBLIC CORE
"""

func enable():
  $Shape.disabled = false
  LOGGER.debug(self, "ENABLE")

func disable():
  $Shape.disabled = true
  LOGGER.debug(self, "DISABLE")

func setup(_orig, _dir, _dist, _arc, _width, _res=10):
  origin = _orig # cone origin, a Vector2
  dir = _dir     # cone direction, a Vector2
  dist = _dist   # how long the cone is, a float
  arc = _arc     # provided in degrees, a float
  width = _width # how wide the cone is, a float
  resolution = _res

  _build_shape()

"""
=== SHAPE BUILDING
"""

func _build_shape():
  _build_points()

  var shape = ConvexPolygonShape2D.new()
  shape.set_point_cloud(cone_path)
  $Shape.shape = shape
  self.coll_tform = self.transform

  built = true
  emit_signal('cone_built')

func _build_points():
  cone_path = PoolVector2Array()
  cone_path.push_back(self.origin)

  # the angle of the blast
  var angle = self.dir.angle()
  # where to hold the points for the initial cone shape
  var arc_pts = PoolVector2Array()
  # half of this blast's arc
  var half_arc = deg2rad(self.arc / 2.0)
  # first, build the left portion of the cone
  arc_pts.append_array(
    MATHS.blast_points_parametric_left(angle - half_arc, self.width, self.dist, self.resolution)
  )
  # next, build the central portion of the cone
  arc_pts.append_array(
    MATHS.points_of_arc(angle, self.arc, self.dist, self.resolution)
  )
  # last, build the right portion of the cone
  arc_pts.append_array(
    MATHS.blast_points_parametric_right(angle + half_arc, self.width, self.dist, self.resolution)
  )

  var pt
  var orig_len
  var isect_len
  avg_len = 0.0

  # for each desired point, cast a ray and use the collided point instead
  # NOTE
  #   point is always in relative coords
  #   pt is always in global coords
  for point in arc_pts:
    var ray = BlastRay.new(self.origin, point, PHYS.COL_MASKS.BLAST)
    add_child(ray)
    var isect = ray.get_collision_point()
    # LOGGER.debug(self, "%s ~> %s/%s" % [self.origin, self.origin + point, isect])

    orig_len = point.length()

    # isect is (0, 0) if the ray did not collide with anything
    if isect == Vector2():
      pt = self.origin + point
    else:
      pt = isect
      _draw_contact(isect)

    isect_len = (pt - self.origin).length()

    # unlike humour, we want to avoid repetition (such as intersections between the three arc sections)
    if not pt in cone_path:
      cone_path.push_back(pt)
      if isect_len != orig_len:
        avg_len += isect_len / orig_len
      else:
        avg_len += 1.0

    ray.queue_free()

  avg_len /= cone_path.size()
  LOGGER.debug(self, "for %d/%d points, average length proportion was %s" % [cone_path.size(), arc_pts.size(), avg_len])


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
