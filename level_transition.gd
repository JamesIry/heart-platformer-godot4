extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_from_black():
	play("fade_from_black")
	
func fade_to_black():
	play("fade_to_black")
	
func play(animation: String):
	animation_player.play(animation)
	await animation_player.animation_finished
