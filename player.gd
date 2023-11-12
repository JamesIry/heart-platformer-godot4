extends CharacterBody2D

@export var movement_data: PlayerMovementData


var air_jump = false
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer


func _physics_process(delta: float):
	apply_gravity(delta)
	handle_wall_jump()
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
	just_wall_jumped = false
	

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta * movement_data.gravity_scale

func handle_wall_jump():
	if is_on_wall_only():
		var wall_normal = get_wall_normal()
		if Input.is_action_just_pressed("ui_up") and (wall_normal == Vector2.LEFT or wall_normal == Vector2.RIGHT):
			just_wall_jumped = true
			velocity.x = wall_normal.x * movement_data.speed
			velocity.y = movement_data.jump_velocity

func handle_jump():
		if is_on_floor():
			air_jump = true
		
		if is_on_floor() or coyote_jump_timer.time_left > 0:
			if Input.is_action_just_pressed("ui_up"):
				velocity.y = movement_data.jump_velocity
		
		if not is_on_floor():
			if velocity.y < movement_data.jump_velocity/2 and Input.is_action_just_released("ui_up"):
				velocity.y = movement_data.jump_velocity/2
			
			if Input.is_action_just_pressed("ui_up") and air_jump and not just_wall_jumped:
				velocity.y = movement_data.jump_velocity * 0.8
				air_jump = false


			

func handle_acceleration(input_axis: float, delta: float):
	var acceleration = movement_data.acceleration
	if not is_on_floor():
		acceleration = movement_data.air_acceleration
		
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, acceleration * delta)

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
