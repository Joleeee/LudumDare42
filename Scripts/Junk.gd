extends Area2D

export var leaks = false
onready var oil = preload("res://Scenes/Oil.tscn")
onready var part = preload("res://Scenes/Part.tscn")

var velocity = Vector2(0, 0)

func _ready():
	set_meta("type", "junk")
	if leaks:
		for x in randi() % 2:
			add_child(oil)

func _physics_process(delta):
	velocity += (Global.Earth.position - position).normalized() * delta
	position += velocity * delta
	$CanvasLayer.offset = get_global_transform_with_canvas().origin
	$CanvasLayer/Buttons.visible = position.distance_to(Global.Player.position) < 20

func move_out():
	var dir = (position - Global.Earth.position).normalized()
#	position += dir * 50;
	var new = velocity + dir * 50
	if !$Tween.is_active:
		$Tween.interpolate_property(self, "velocity", velocity, new, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0)
		$Tween.interpolate_property(self, "velocity", new, velocity, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 1)
		$Tween.start()
		return true
	else:
		return false

func _on_Mine_clicked():
	queue_free()
	var p = part.instance()
	p.position = position
	get_parent().add_child(p)
	pass # replace with function body
