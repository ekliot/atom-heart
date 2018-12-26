"""
filename: player_inspector.gd
"""

extends PanelContainer

var P = null

const LABEL_FMT = "%s: %s"

"""
=== SETUP
"""

func _ready():
  if not GM.PLAYER:
    GM.connect('player_set', self, '_set_player')
  else:
    _set_player(GM.PLAYER)


func _set_player(player):
  P = player
  _init_labels()


func _init_labels():
  _set_labels(get_node('Inspectors/Left'), L, _L)
  _set_labels(get_node('Inspectors/Right'), R, _R)


"""
=== PROCESSING
"""

func _process(dt):
  var list_l = get_node('Inspectors/Left')
  var list_r = get_node('Inspectors/Right')

  for k in _L.keys():
    _L[k] = _get_arm_data(L, k)
    _on_process_label(list_l.get_node(k), k, _L[k])

  for k in _R.keys():
    _R[k] = _get_arm_data(R, k)
    _on_process_label(list_r.get_node(k), k, _R[k])


func _set_labels(list, arm, data):
  list.add_child(_make_label("Side", arm.ARM_SIDE))
  _set_data(arm, data)
  for k in data.keys():
    list.add_child(_make_label(k, data[k]))


func _set_data(arm, data):
  data['State'] = _get_arm_data(arm, 'State')
  data['Angle'] = _get_arm_data(arm, 'Angle')
  data['Charge'] = _get_arm_data(arm, 'Charge')


func _get_arm_data(arm, key):
  match(key):
    'State':
      return arm.FSM.get_active_id()
    'Angle':
      var dir = arm.point_dir.reflect(Vector2(1.0, 0.0))
      var angle = rad2deg(dir.angle())
      if angle < 0:
        angle = 360 - abs(angle)
      return angle
    'Charge':
      return arm.FSM.get_state('charging').current_charge


func _make_label(k, v):
  var label = Label.new()
  label.name = k
  _on_process_label(label, k, v)
  return label


func _on_process_label(label, k, v):
  if label:
    label.text = LABEL_FMT % [k, v]
