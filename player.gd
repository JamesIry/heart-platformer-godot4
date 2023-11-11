extends CharacterBody2D

@export var movement_data: PlayerMovementData


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer


func _physics_process(delta: float):
	apply_gravity(delta)
	handle_jump()

	var input_axis = Input.get_axis("ui_left", "ui_right")
	
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	
	update_animations(input_axis)
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta * movement_data.gravity_scale
		
func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = movement_data.jump_velocity
	
	if not is_on_floor():
		if velocity.y < movement_data.jump_velocity/2 and Input.is_action_just_released("ui_up"):
			velocity.y = movement_data.jump_velocity/2

func handle_acceleration(input_axis: float, delta: float):
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration * delta)

func apply_friction(input_axis: float, delta: float):
	if input_axis == 0.0:
		var friction = movement_data.air_resistance
		if is_on_floor():
			friction = movement_data.friction
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func update_animations(input_axis: float):
	if input_axis:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
		animated_sprite_2d.play("jump")