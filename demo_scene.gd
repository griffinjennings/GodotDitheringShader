extends Spatial

var is_paused = false
var pausetime = 0.0

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if is_paused == false:
			is_paused = true
			pausetime = $anim.current_animation_position
			$anim.stop()
		else:
			is_paused = false
			$anim.seek(pausetime)
			$anim.play()
	elif Input.is_action_just_pressed("hide_images"):
		$test_img.visible = !$test_img.visible
