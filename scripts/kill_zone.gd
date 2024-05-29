extends Area2D

@onready var timer = $Timer
signal player_entered_killzone

func _on_body_entered(body):
	if body.is_in_group("player"): 
		body.die()
		emit_signal("player_entered_killzone")
