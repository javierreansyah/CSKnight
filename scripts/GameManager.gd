extends Node

@onready var death_label = $"../CanvasLayer/DeathLabel"
@onready var player = $"../Player"
@onready var win_label = $"../CanvasLayer/WinLabel"
@onready var score_label = $"../CanvasLayer/ScoreLabel"
@onready var scroll = $"../Player/Scroll"
@onready var timer = $Timer

func _ready():
	player.connect("player_died", Callable(self, "_on_player_died"))
	death_label.visible = false
	win_label.visible = false
	score_label.text = "Score:" + str(score) + "/3"
	scroll.connect("point", Callable(self, "add_point"))

func _on_player_died():
	death_label.text = "You Died!"
	death_label.visible = true
	timer.start()
	
func _on_timer_timeout():
	get_tree().reload_current_scene()

#Scoring
var score = 0

func add_point():
	score += 1
	print(score)
	score_label.text = "Score:" + str(score) + "/3"
	if score >= 3:
		on_player_win()
	

func on_player_win():
	win_label.text = "You Win!"
	win_label.visible = true




