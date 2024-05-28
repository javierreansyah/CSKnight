extends Node2D

var speed = 60
var direction = 1
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var killzone = $KillZone  # Correct path

func _ready():
	killzone.connect("player_entered_killzone", Callable(self, "_on_player_entered_killzone"))

func _process(delta):
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	position.x += direction * speed * delta

func _on_player_entered_killzone():
	animated_sprite.play("attack")
	speed = 0
