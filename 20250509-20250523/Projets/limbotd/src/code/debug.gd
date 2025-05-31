extends Node


const DEBUG_IN_EDITOR = true


var is_debug : bool = (OS.is_debug_build() and (not OS.has_feature("standalone") and DEBUG_IN_EDITOR)) or (
	OS.is_debug_build()
)





var _tower := {
	"status" : false,
	"show_range" : false
}

var _player := {
	"money" : 10000*0,
	"life" : 0
}

var _wave_manager := {
	"wave_offset" : 0,
	"ignore_initial_time" : false
}

var data := [_tower, _player, _wave_manager]
var data_names := ["tower", "player", "wavemanager"]
var cache := {}




func get_debug_value(val):
	if val is bool:
		return val and is_debug
	if val is int or val is float:
		if (val == INF or val == - INF) and not is_debug:
			return 0
		return val * int(is_debug)



#this approach avoids magic numbers
func _get(property):
	if property in cache.keys():
		return cache[property]
	
	var words : Array = property.split("_")
	for i in range(len(data)):
		if words[0] == data_names[i]:
			
			if len(words) == 1:
				return null
			
			var prop : String = ""
			for j in range(1, len(words)):
				prop += words[j]
				if j < len(words) - 1:
					prop += "_"
			
			if not prop in data[i].keys():
				return null
			
			var value = get_debug_value(data[i][prop])
			if not property in cache.keys():
				cache[property] = value
			
			return value
