extends Node2D

onready var junk = preload("res://Scenes/Junk.tscn")

func _enter_tree():
	Global.Game = self
	Global.Earth = get_child(0)

func _ready():
	var radius = 250
	for x in 50:
		var rot = randf()*PI*2
		var vec = Vector2(cos(rot), sin(rot)) * radius
		var j = junk.instance()
		add_child(j)
		j.position = vec
		print(vec)
