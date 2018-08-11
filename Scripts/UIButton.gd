tool
extends Control

export var text = "Button"

signal clicked

func _ready():
	set_material(get_material().duplicate(true))

func _process(delta):
	$Text.text = text
	var font = $Text.get_font("font")
	var size = font.get_string_size($Text.text)
	size.y += 3
	size.x += 3
	$Button.rect_size = size
	pass


func _on_Button_mouse_entered():
	get_material().set_shader_param("inverted", true)
	$Audio.play()
	print("play")
	pass # replace with function body


func _on_Button_mouse_exited():
	get_material().set_shader_param("inverted", false)
	pass # replace with function body


func _on_Button_button_down():
	emit_signal("clicked")
	pass # replace with function body
