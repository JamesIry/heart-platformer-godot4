extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_from_black():
	play_and_await("fade_from_black")
	
func fade_to_black():
	play_and_await("fade_to_black")
	
func play_and_await(animation: String):
	animation_player.play(animation)
	await animation_player.animation_finished
