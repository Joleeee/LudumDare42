extends BackBufferCopy

func _process(delta):
	global_position = Global.Player.global_position
	global_rotation = Global.Player.global_rotation + PI/2
#	var p = get_parent().move_child(get_parent().get_node("BackBufferCopy"), get_parent().get_child_count()) #make it get drawn last

func _ready():
	pass
