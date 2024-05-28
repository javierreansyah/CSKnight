extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var all_interactions = []
@onready var interaction_label = $InteractionComponent/InteractionLabel

func _ready():
	update_interaction()

func _physics_process(delta):
	#Interaction
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	if all_interactions:
		interaction_label.text = all_interactions[0].interact_label
	else:
		interaction_label.text = ""

func execute_interaction():
	if all_interactions:
		var current_interaction = all_interactions[0]
		match current_interaction.interact_type:
			"print" : print(current_interaction.interact_value)
