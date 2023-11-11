extends CharacterBody2D


const SPEED: float = 100.0
const ACCELERATION: float = 800.0
const FRICTION: float = 1000.0
const JUMP_VELOCITY: float = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D


func _physics_process(delta: float):
	apply_gravity(delta)
	handle_jump(delta)

	var input_axis = Input.get_axis("ui_left", "ui_right")
	
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	
	update_animations(input_axis)

	move_and_slide()

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jump(delta: float):
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	else:
		if velocity.y < JUMP_VELOCITY/2 and Input.is_action_just_released("ui_up"):
			velocity.y = JUMP_VELOCITY/2

func handle_acceleration(input_axis: float, delta: float):
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * SPEED, ACCELERATION * delta)

func apply_friction(input_axis: float, delta: float):
	if input_axis == 0.0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func update_animations(input_axis):
	if input_axis:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	
