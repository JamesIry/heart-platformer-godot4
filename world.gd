extends Node2D

@export var next_level: PackedScene

var level_start_time = 0.0

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel

func _ready():
	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	start_in.visible = true
	await LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false
	level_start_time = Time.get_ticks_msec()

func _process(delta):
	var time_on_level = Time.get_ticks_msec() - level_start_time
	level_time_label.text = str(time_on_level / 1000.0)

func go_to_next_level():
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	
func retry():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	var current_level = load(scene_file_path)
	get_tree().change_scene_to_packed(current_level)

func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true

func _on_level_completed_next_level():
	go_to_next_level()
	
func _on_level_completed_retry():
	retry()

