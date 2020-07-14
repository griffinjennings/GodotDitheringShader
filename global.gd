extends Node


var player
var spheremap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	elif Input.is_action_just_pressed("mouse_release"):
		if player.is_physics_processing() == true:
			player.set_physics_process(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			player.set_physics_process(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
