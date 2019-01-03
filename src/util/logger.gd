extends Node

enum LEVELS {DEBUG, INFO, WARN, ERROR}
const LVL_STR := ["DEBUG", "INFO", "WARN", "ERROR"]
const LVL_PAD := 5

const FMT_PREFIX := "%*s"
const FMT_LEVEL := "[%s]"
const FMT_MSG := "%24s <%8s> %8s // %s"

# TODO set this somewhere/somehow
# TODO interpret these somewhere/somehow
# var BLOCKED_PATHS = []
# var BLOCKED_TYPES = []
# var BLOCKED_GROUPS = []

var last_src: String = ''
var logging_lvl := 1

func debug(src, msg):
  _log(src, LEVELS.DEBUG, msg)

func info(src, msg):
  _log(src, LEVELS.INFO, msg)

func warn(src, msg):
  warning(src, msg)

func warning(src, msg):
  _log(src, LEVELS.WARN, msg)

func error(src, msg):
  _log(src, LEVELS.ERROR, msg)

func _log(src, lvl, msg):
  if lvl < logging_lvl:
    return
  src = "%s/%s" % [src.get_parent().name, src.name]
  # TODO check for blocking
  print(_format_msg(src, lvl, msg))
  last_src = src

func _format_msg(src, lvl, msg):
  var pad = src.length() if src == last_src else 0
  var who = src if src != last_src else ''

  var prefix = FMT_PREFIX % [pad, who]
  var level = FMT_LEVEL % LVL_STR[lvl]
  var output = FMT_MSG % [prefix, OS.get_ticks_msec(), level, msg]

  return output
