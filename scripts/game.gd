extends Node2D

@onready var death_label = $CanvasLayer/DeathLabel
@onready var player = $Player

func _ready():
	player.connect("player_died", Callable(self, "_on_player_died"))
	death_label.visible = false  # Ensure the label is initially hidden

func _on_player_died():
	death_label.text = "You Died"  # Display the death message
	death_label.visible = true  # Make sure the label is visible

