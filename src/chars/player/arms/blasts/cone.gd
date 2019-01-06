"""
filename: cone.gd
"""

class_name BlastCone
extends Area2D

const Circle = preload("res://src/assets/Circle.tscn")

var blast_col_mask = pow(2, PHYSICS.COL_BLAST)

signal cone_built

var built = false

var origin = Vector2()
var dir = Vector2()
var dist = 0.0
var arc = 0.0
var width = 0.0

var resolution = 0

# TODO this ought to be textures/shaders
var colors = PoolColorArray([Color(1.0, 0.0, 0.0)])

# the shape of the blast cone
var cone_path: ConePath

# flag for when collision checking is finished
var parsed := false

# the average length of the cone's rays
# used to determine proportional propulsive power of the blast
var avg_len = 0.0

"""
=== NODE OVERRIDES
"""

func _init() -> void:
  # connect('body_shape_entered', self, '_save_collision_data')
  pass

func _ready():
  LOGGER.debug(self, "READY") # print-debugging order of operations

func _draw():
  if not built:
    _build_shape()
  draw_polygon(cone_path.path, colors)

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
  # TODO deal damage to anything in the PHYS.COL_NPC_DMG coll-layer

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

func _build_shape() -> void:
  cone_path = ConePath.new(self)

  var shape := ConcavePolygonShape2D.new()
  if cone_path.size() % 2: # ConcavePolygonShape2D needs
    cone_path.push_back(origin)
  shape.segments = cone_path.path
  # var shape := ConvexPolygonShape2D.new()
  # shape.set_point_cloud(cone_path.path)
  $Shape.shape = shape

  built = true
  emit_signal('cone_built')


class ConePath:
  var src
  var angle: float
  var path: PoolVector2Array
  # where to hold the points for the initial cone shape
  var arc_pts: PoolVector2Array

  var avg_len := 0.0

  func _init(_src):
    src = _src
    angle = src.dir.angle()
    _init_arc()
    _build()
    _sort()

  func _init_arc():
    """
    build the "default" blast cone shape
    """
    arc_pts = PoolVector2Array([])

    # half of this blast's arc
    var half_arc := deg2rad(src.arc / 2.0)
    # first, build the left portion of the cone
    arc_pts.append_array(
      MATHS.blast_points_parametric_left(angle - half_arc, src.width, src.dist, src.resolution)
    )
    # next, build the central portion of the cone
    arc_pts.append_array(
      MATHS.points_of_arc(angle, src.arc, src.dist, src.resolution)
    )
    # last, build the right portion of the cone
    arc_pts.append_array(
      MATHS.blast_points_parametric_right(angle + half_arc, src.width, src.dist, src.resolution)
    )

  func _build():
    var next:Vector2

    # for each desired point, cast a ray and use the collided point instead
    # NOTE
    #   point is always in relative coords
    #   pt is always in global coords
    for idx in range(len(arc_pts)):
      var point:Vector2 = arc_pts[idx]

      if not point:
        continue

      # TODO raycast b/w points?
      next = arc_pts[(idx + 1) % len(arc_pts)]
      if next:
        _ray_cast(src.origin + point, next - point, true)

      _ray_cast(src.origin, point)

    avg_len /= size()
    LOGGER.debug(src, "for %d points, average length proportion was %s" % [size(), avg_len])

  func _ray_cast(from:Vector2, to:Vector2, test_ray:=false, test_inside:=true) -> void:
    var pt:Vector2

    var ray := BlastRay.new(funcref(src, 'init_blast_ray'), from, to)
    src.add_child(ray)

    var orig_len := to.length()
    var isect_len:float

    for pt in MATHS.reduce_vecs(ray.isects):
      if not pt:
        pt = src.origin + to
      else:
        # TODO optimize w/ dynamic programming
        if test_inside and not MATHS.point_inside_poly((pt - from), arc_pts):
          continue
        elif test_ray and not _test_point(pt):
          continue

      # unlike humour, we want to avoid repetition (such as intersections between the three arc sections)
      if not pt in path:
        push_back(pt)

        isect_len = (pt - from).length()

        if isect_len != orig_len:
          avg_len += isect_len / orig_len
        else:
          avg_len += 1.0

    ray.queue_free()

  func _test_point(pt:Vector2) -> bool:
    var ray = RayCast2D.new()
    src.init_blast_ray(ray, src.origin, pt)
    src.add_child(ray)
    return ray.is_colliding()

  func _sort():
    var sorted := Array(path)

    sorted.sort_custom(MATHS.CompareVec.new(src.origin), 'compare_angle')
    sorted.push_front(src.origin)

    var new_size := len(sorted)
    path.resize(new_size)
    for idx in range(new_size):
      path.set(idx, sorted[idx])

  func push_back(v:Vector2):
    path.push_back(v)

  func size():
    return len(path)

class BlastRay:
  extends RayCast2D

  var coll_pt: Vector2
  var length := 0.0
  var isects := PoolVector2Array()


  func _init(init_func:FuncRef, origin:Vector2, dest:Vector2) -> void:
    init_func.call_func(self, origin, dest)
    length = dest.length()

  func _ready() -> void:
    _coll_check(cast_to)

    if not coll_pt:
      return

    var coll_ob := get_collider()

    if coll_ob is TileMap:
      _check_tilemap_col(coll_ob as TileMap)

  func _check_tilemap_col(tmap:TileMap) -> void:
    var tset:TileSet = tmap.tile_set
    # extend the cast by just a little bit to make sure it falls inside the collided tile
    var cellv := tmap.world_to_map(get_collision_point() + cast_to * MATHS.EPS_FLT * 100)

    if cellv in tmap.get_used_cells():
      var tile_id: int = tmap.get_cellv(cellv)
      var auto_coord: Vector2 = tmap.get_cell_autotile_coord(cellv.x, cellv.y)
      var world_coord: Vector2 = tmap.map_to_world(cellv)

      for shape_data in tset.tile_get_shapes(tile_id):
        # TODO optimize w/ dynamic programming
        if shape_data['autotile_coord'] == auto_coord:
          # index the corners by their distance from the collision point
          var corners := {}
          for pt in shape_data['shape'].points:
            corners[(coll_pt - pt).length_squared()] = pt

          var dists := corners.keys()
          var n := len(dists)
          dists.sort()
          var pt:Vector2
          for i in range(n):
            if i == 2:
              break
            pt = corners.get(dists[n - i - 1], Vector2())
            _check_corner(tmap as Node2D, world_coord + pt)

          break

    else:
      LOGGER.error(self, "cell not found in TileMap for cellv %s @ %s" % [cellv, get_collision_point()])

  func _check_corner(coll_obj:Node2D, pt:Vector2) -> void:
    var corner := pt - global_position

    _coll_check(corner)

    corner = corner.normalized() * length

    _coll_check(corner.rotated(MATHS.EPS_FLT))
    _coll_check(corner.rotated(-MATHS.EPS_FLT))

  func _coll_check(cast:Vector2) -> void:
    cast_to = cast
    force_raycast_update()
    coll_pt = get_collision_point()
    # if: collided and not dupe and meaningful length
    if coll_pt and not coll_pt in isects and \
      (coll_pt - global_position).length_squared() > MATHS.EPS_FLT:
      isects.push_back(coll_pt)
    else:
      isects.push_back(global_position + cast_to)


static func init_blast_ray(ray:RayCast2D, origin:Vector2, dest:Vector2) -> void:
  ray.global_position = origin
  ray.cast_to = dest
  ray.collision_mask = PHYS.COL_MASKS.BLAST
  ray.enabled = true

func _draw_contact(pt:Vector2) -> void:
  """
  XXX this is just for debugging collision points
  """
  if DBG.DEBUG:
    var c := Circle.instance()
    c.global_position = pt
    c.scale = Vector2(3, 3) # HACK
    add_child(c)
