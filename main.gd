extends Node2D

onready var shader = $ViewportContainer.get_material()
var is_enabled = true

func _ready():
	if shader.get_shader_param("enabled") == true:
		is_enabled = true
	else:
		is_enabled = false

func _input(event):
	if Input.is_action_just_pressed("boolswitch"):
		if is_enabled == true:
			shader.set_shader_param("enabled", false)
			is_enabled = false
		else:
			shader.set_shader_param("enabled", true)
			is_enabled = true
	elif Input.is_action_just_pressed("hide_text"):
		$help.visible = !$help.visible
