extends Area2D

export var type = "part"
var velocity = Vector2(0, 0)

func _ready():
	set_meta("type", type)
	pass

func _physics_process(delta):
	position += velocity * delta
	$CanvasLayer/Buttons.visible = position.distance_to(Global.Player.position) < 20
	$CanvasLayer.offset = get_global_transform_with_canvas().origin


func _on_InvButton_clicked():
	Global.Player.pickup(self)
	pass # replace with function body
