extends CharacterBody2D

signal player_died

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var all_interactions = []
@onready var interaction_label = $InteractionComponent/InteractionLabel
@onready var scroll = $Scroll

@onready var walking = $walking
@onready var walking_timer = $WalkingTimer
@onready var jump = $Jump
@onready var die_sfx = $Die

var is_dead = false

func _ready():
	update_interaction()
	add_to_group("player")
	scroll.connect("wrong_answer_selected", Callable(self, "die"))

func _physics_process(delta):
	if is_dead:
		return

	if Input.is_action_just_pressed("interact"):
		execute_interaction()

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump.play()

	var direction = Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
			walking.stop()
			walking_timer.stop()  # Stop the timer when idle
		else:
			animated_sprite.play("walk")
			if walking_timer.is_stopped():
				walking.play()
				walking_timer.start()  # Start the timer when walking
	else:
		animated_sprite.play("jump")
		walking.stop()
		walking_timer.stop()  # Stop the timer when jumping

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Interaction
func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interaction()

func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interaction()

func update_interaction():
	if all_interactions and !all_interactions[0].has_interacted:
		interaction_label.text = "[E] untuk berinteraksi"
	else:
		interaction_label.text = ""

func execute_interaction():
	if all_interactions and not all_interactions[0].has_interacted:
		var current_interaction = all_interactions[0]
		all_interactions[0].has_interacted = true
		scroll.open_scroll()
		update_interaction()

func die():
	is_dead = true
	animated_sprite.play("dead")
	velocity = Vector2.ZERO
	emit_signal("player_died")
	die_sfx.play()

func _on_walking_timer_timeout():
	walking.play()
	print("play")
