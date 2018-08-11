extends Area2D

const speed = 30
const ang_speed = 360 / PI * 2

var radius = 200
var rot = 0

var ship_rotation_speed = PI
var ship_x_speed = 0.5
var ship_y_speed = 30

var vel = Vector2(0, 0)

onready var earth = get_parent()

func _enter_tree():
	Global.Player = self

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_left"):
		vel.x -= ship_x_speed * delta
	if Input.is_action_pressed("ui_right"):
		vel.x += ship_x_speed * delta
	if Input.is_action_pressed("ui_up"):
		vel.y += ship_y_speed * delta
	if Input.is_action_pressed("ui_down"):
		vel.y -= ship_y_speed * delta
	
	var last_rot = rot
	
	radius += vel.y * delta
	rot += vel.x * delta
	
	global_rotation -= last_rot - rot
	
	var rotvec = Vector2(cos(rot), sin(rot))
	var p = rotvec * radius
	position = p
	$Camera.global_rotation = rot + PI/2
	
	var left_mouse_down = Input.is_mouse_button_pressed(BUTTON_LEFT)
	var right_mouse_down = Input.is_mouse_button_pressed(BUTTON_RIGHT)
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	var result = space_state.intersect_point(get_global_mouse_position())
	if result.size() > 0:
		var x = result[0] #only one so we dont get 5 thing moving to us at the same time
		if x.collider.get_meta("type") == "junk" || x.collider.get_meta("type") == "part":
			if left_mouse_down:
				x.collider.velocity += (position - x.collider.position)*0.01
			if right_mouse_down:
				x.collider.velocity -= (position - x.collider.position)*0.01

func pickup(what):
	for x in get_tree().get_nodes_in_group("junk"):
		if x.move_out():
			print("yes")
			what.queue_free()
		else:
			print("no")
