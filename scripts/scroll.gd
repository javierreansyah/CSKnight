extends Area2D

@onready var scroll = $Scroll
@onready var scrollQ = $ScrollQ
@onready var question_label = $ScrollQ/QuestionLabel
@onready var option_labels = [$ScrollQ/Option1, $ScrollQ/Option2, $ScrollQ/Option3, $ScrollQ/Option4]
@onready var countdown_timer = $ScrollQ/CountdownTimer # Ensure you have added a Timer node named "CountdownTimer" under ScrollQ
@onready var countdown_label = $ScrollQ/CountdownLabel # Ensure you have added a Label node named "CountdownLabel" under ScrollQ

var countdown_time = 5 # Total countdown time in seconds

var questions = [
	"What is the capital of France?",
	"Who wrote 'Hamlet'?",
	"What is the chemical symbol for water?"
]

# Options for each question
var question_options = [
	["Paris", "London", "Berlin", "Rome"],
	["Shakespeare", "Dickens", "Twain", "Hemingway"],
	["H2O", "NaCl", "CO2", "HCl"]
]

func _ready():
	scrollQ.hide()
	countdown_timer.one_shot = true
	countdown_timer.connect("timeout", Callable(self, "_on_CountdownTimer_timeout"))

func not_in_area():
	scroll.hide()
	scroll.play("close-scroll")
	
func in_area():
	scroll.show()
	scroll.play("close-scroll")

func open_scroll():
	scrollQ.show()
	scrollQ.play("open-scroll")
	get_tree().create_timer(2.0)
	start_countdown()
	randomize()
	var random_index = randi() % questions.size()
	var random_question = questions[random_index]
	question_label.text = random_question
	question_label.show()

	var options = question_options[random_index]
	for i in range(option_labels.size()):
		option_labels[i].text = str(i + 1) + ". " + options[i]
		option_labels[i].show()
	
func close_scroll():
	question_label.hide()
	for option_label in option_labels:
		option_label.hide()
	scrollQ.play("close-scroll")
	countdown_timer.stop()
	countdown_label.hide()

#func _input(event):
	#if scrollQ.visible:
		#if event is InputEventKey and event.pressed:
			#match event.scancode:
				#KEY_1:
					#handle_option_selected(1)
				#KEY_2:
					#handle_option_selected(2)
				#KEY_3:
					#handle_option_selected(3)
				#KEY_4:
					#handle_option_selected(4)

func handle_option_selected(option):
	print("Option " + str(option) + " selected")
	# Handle the selected option here (e.g., check if the answer is correct)
	# For example:
	# if question_options[random_index][option - 1] == correct_answer:
	#     print("Correct answer!")
	# else:
	#     print("Wrong answer!")
	close_scroll()

func start_countdown():
	countdown_time = 5 # Reset countdown time
	countdown_label.text = str(countdown_time)
	countdown_label.show()
	countdown_timer.wait_time = 1.0 # Set the timer to tick every second
	countdown_timer.start()

func _on_CountdownTimer_timeout():
	countdown_time -= 1
	countdown_label.text = str(countdown_time)
	if countdown_time <= 0:
		countdown_timer.stop()
		countdown_finished()
	else:
		countdown_timer.start()

func countdown_finished():
	countdown_label.text = "Time's up!"
	close_scroll()
