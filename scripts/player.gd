extends CharacterBody2D

signal player_died

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var all_interactions = []
@onready var interaction_label = $InteractionComponent/InteractionLabel
@onready var scroll = $Scroll



signal scroll_book

var is_dead = false

func _ready():
	update_interaction()
	add_to_group("player")

func _physics_process(delta):
	if is_dead:
		return  # Stop further processing if the player is dead

	# Interaction
	if Input.is_action_just_pressed("interact"):
		execute_interaction()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")

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
	if all_interactions && !all_interactions[0].has_interacted:
		scroll.in_area()
		interaction_label.text = "[E] to interact"
	else:
		scroll.not_in_area()
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
