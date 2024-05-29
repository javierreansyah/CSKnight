extends Area2D

@onready var scrollQ = $ScrollQ
@onready var question_label = $ScrollQ/QuestionLabel
@onready var option_labels = [$ScrollQ/Option1, $ScrollQ/Option2, $ScrollQ/Option3, $ScrollQ/Option4]
@onready var countdown_timer = $ScrollQ/CountdownTimer 
@onready var countdown_label = $ScrollQ/CountdownLabel
 
signal point
signal timeout
signal wrong_answer_selected

var countdown_time = 5
var random_index

var questions = [
	"What is the capital of France?",
	"Who wrote 'Hamlet'?",
	"What is the chemical symbol for water?"
]

var question_options = [
	["Paris", "London", "Berlin", "Rome"],
	["Shakespeare", "Dickens", "Twain", "Hemingway"],
	["H2O", "NaCl", "CO2", "HCl"]
]

var boolean_options = [
	[true, false, false, false],
	[true, false, false, false],
	[true, false, false, false]
]

func _ready():
	scrollQ.hide()
	countdown_timer.one_shot = true
	countdown_timer.connect("timeout", Callable(self, "_on_CountdownTimer_timeout"))

func open_scroll():
	scrollQ.show()
	scrollQ.play("open-scroll")
	start_countdown()
	randomize()
	random_index = randi() % questions.size()
	var random_question = questions[random_index]
	question_label.text = random_question
	question_label.show()

	var options = question_options[random_index]
	for i in range(option_labels.size()):
		option_labels[i].text = "[" + str(i + 1) + "] " + options[i]
		option_labels[i].show()
	
func close_scroll():
	question_label.hide()
	for option_label in option_labels:
		option_label.hide()
	scrollQ.play("close-scroll")
	scrollQ.hide()
	countdown_timer.stop()
	countdown_label.hide()	

func _input(event):
	if scrollQ.visible:
		if event is InputEventKey and event.pressed:
			match event.as_text():
				"1":
					handle_option_selected(1)
				"2":
					handle_option_selected(2)
				"3":
					handle_option_selected(3)
				"4":
					handle_option_selected(4)

func handle_option_selected(option):
	if boolean_options[random_index][option - 1]:
		emit_signal("point")
	else:
		emit_signal("wrong_answer_selected")
	close_scroll()

func start_countdown():
	countdown_time = 5
	countdown_label.text = str(countdown_time)
	countdown_label.show()
	countdown_timer.wait_time = 1.0
	countdown_timer.start()

func _on_CountdownTimer_timeout():
	countdown_time -= 1
	countdown_label.text = str(countdown_time)
	if countdown_time <= 0:
		countdown_timer.stop()
		countdown_finished()
		emit_signal("wrong_answer_selected")
	else:
		countdown_timer.start()

func countdown_finished():
	countdown_label.text = "Time's up!"
	close_scroll()
