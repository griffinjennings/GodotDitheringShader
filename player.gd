extends KinematicBody

var gravity = -30
var vel = Vector3()
const MAX_SPEED = 7
const JUMP_SPEED = 7
const ACCEL = 20

var grav_dir = Vector3(0, 1, 0)

var dir = Vector3()

const DEACCEL = 20
const MAX_SLOPE_ANGLE = 40



var camera
var rot_assist
var raycast

var hold_raw = 0

const MAX_SPRINT_SPEED = 12
const SPRINT_ACCEL = 15
const MAX_CROUCH_SPEED = 3
var is_sprinting = false
var is_crouching = false

onready var footsteps = $footsteps

var footstep_time = 40
var footstep_time_sprint = 25
var footstep_check = 0

var is_noclip = false

export var emboss_factor = 0

var rot_x = 0.0
var rot_y = 0.0

export var cam_stretch = Vector3()

func _ready():
	footstep_check = footstep_time
	rot_assist = $rot_assist
	camera = $rot_assist/camera
	raycast = $rot_assist/camera/raycast
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	global.player = self
	camera.current = true

#func set_emboss(distance):
	#global.env.get_environment().adjustment_contrast = abs(distance*5) + 1.0
#	camera.get_node("overlay_mult").mesh.material.set_shader_param("emboss_distance", distance)
#	camera.get_node("overlay_div").mesh.material.set_shader_param("emboss_distance", distance)
	
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	
#	set_emboss(emboss_factor)
	
func process_input(delta):
	
	dir = Vector3()
	
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x-= 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
	
	if Input.is_action_pressed("movement_sprint"):
		is_sprinting = true
		footstep_time = footstep_time_sprint
		$rot_assist/camera/headbob.playback_speed = 1.2
	else:
		is_sprinting = false
		footstep_time = 40
		$rot_assist/camera/headbob.playback_speed = 0.8
	
	if Input.is_action_pressed("movement_crouch"):
		is_crouching = true
		rot_assist.translation.y = rot_assist.translation.y + (3 - rot_assist.translation.y) * 0.1
		$body_top.disabled = true
		$rot_assist/camera/headbob.playback_speed = 0.5
	else:
		is_crouching = false
		rot_assist.translation.y = rot_assist.translation.y + (5 - rot_assist.translation.y) * 0.1
		$body_top.disabled = false
		
	
func process_movement(delta):
	
	dir.y = 0
	dir = dir.normalized()
	
	if !is_noclip:
		vel.y += gravity * delta
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	if is_crouching:
		target *= MAX_CROUCH_SPEED
	else:
		if is_sprinting:
			target *= MAX_SPRINT_SPEED
		else:
			target *= MAX_SPEED 
		
	var accel
	if dir.dot(hvel) > 0:
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL
		
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	
	camera.translation = cam_stretch * (abs(vel.x) + abs(vel.z)) / 6
	
	vel = move_and_slide(vel, grav_dir, 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rot_x = event.relative.y * -0.3
		rot_y = event.relative.x * -0.3
		
		rot_assist.rotate_x(deg2rad(rot_x))
		rotate_y(deg2rad(rot_y))
		
		var camera_rot = rot_assist.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -80, 80)
		
		rot_assist.rotation_degrees = camera_rot
		


