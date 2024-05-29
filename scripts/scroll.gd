extends Area2D

@onready var scrollQ = $ScrollQ
@onready var question_label = $ScrollQ/QuestionLabel
@onready var option_labels = [$ScrollQ/Option1, $ScrollQ/Option2, $ScrollQ/Option3, $ScrollQ/Option4]
@onready var countdown_timer = $ScrollQ/CountdownTimer 
@onready var countdown_label = $ScrollQ/CountdownLabel
 
@onready var open_scroll_sfx = $ScrollQ/OpenScroll
@onready var correct = $ScrollQ/Correct


signal point
signal timeout
signal wrong_answer_selected

var countdown_time = 5
var random_index

var questions = [
	"Apa ibu kota Indonesia?",
	"Siapa presiden pertama Indonesia?",
	"Berapa hasil dari 2 + 2?",
	"Apa warna langit pada hari yang cerah?",
	"Binatang apa yang suka makan wortel?",
	"Berapakah jumlah kaki pada seekor kucing?",
	"Buah apa yang berwarna merah dan manis?",
	"Siapa yang menemukan lampu pijar?",
	"Apa nama planet tempat kita tinggal?",
	"Apa yang kita minum setiap hari untuk hidup?",
	"Apa warna buah pisang yang sudah matang?",
	"Apa hasil dari 10 - 4?",
	"Apa yang digunakan untuk menulis di papan tulis?",
	"Berapa hari dalam satu minggu?",
	"Siapa yang menciptakan pesawat terbang?",
	"Buah apa yang identik dengan warna oranye?",
	"Berapa sisi yang dimiliki oleh sebuah segitiga?",
	"Hewan apa yang menghasilkan susu?",
	"Apa nama hewan yang dapat terbang?",
	"Apel, jeruk, dan mangga termasuk dalam jenis makanan apa?"
]

var question_options = [
	["Jakarta", "Bandung", "Surabaya", "Medan"],
	["Soekarno", "Soeharto", "Habibie", "Gus Dur"],
	["3", "4", "5", "6"],
	["Biru", "Merah", "Hijau", "Kuning"],
	["Kelinci", "Gajah", "Sapi", "Kuda"],
	["2", "3", "4", "5"],
	["Apel", "Pisang", "Anggur", "Semangka"],
	["Edison", "Einstein", "Newton", "Tesla"],
	["Bumi", "Mars", "Jupiter", "Venus"],
	["Air", "Susu", "Jus", "Soda"],
	["Hijau", "Kuning", "Merah", "Biru"],
	["5", "6", "7", "8"],
	["Pensil", "Spidol", "Kapur", "Pulpen"],
	["5", "6", "7", "8"],
	["Wright bersaudara", "Edison", "Bell", "Tesla"],
	["Apel", "Jeruk", "Anggur", "Semangka"],
	["2", "3", "4", "5"],
	["Sapi", "Ayam", "Bebek", "Kucing"],
	["Burung", "Kucing", "Ikan", "Kuda"],
	["Buah-buahan", "Sayur-sayuran", "Biji-bijian", "Daging"]
]

var boolean_options = [
	[true, false, false, false],
	[true, false, false, false],
	[false, true, false, false],
	[true, false, false, false],
	[true, false, false, false],
	[false, false, true, false],
	[true, false, false, false],
	[true, false, false, false],
	[true, false, false, false],
	[true, false, false, false],
	[false, true, false, false],
	[false, true, false, false],
	[false, true, true, false],
	[false, false, true, false],
	[true, false, false, false],
	[false, true, false, false],
	[false, true, false, false],
	[true, false, false, false],
	[true, false, false, false],
	[true, false, false, false]
]


func _ready():
	scrollQ.hide()
	countdown_timer.one_shot = true
	countdown_timer.connect("timeout", Callable(self, "_on_CountdownTimer_timeout"))

func open_scroll():
	if questions.size() == 0:
		print("No more questions available.")
		return
	open_scroll_sfx.play()
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
		correct.play()
		emit_signal("point")
	else:
		emit_signal("wrong_answer_selected")
	remove_current_question()
	close_scroll()

func start_countdown():
	countdown_time = 20
	countdown_label.text = str(countdown_time)
	countdown_label.show()
	countdown_timer.wait_time = 1.0
	countdown_timer.start()

func _on_CountdownTimer_timeout():
	countdown_time -= 1
	countdown_label.text = str(countdown_time) + "s"
	if countdown_time <= 0:
		countdown_timer.stop()
		countdown_finished()
		emit_signal("wrong_answer_selected")
		remove_current_question()
	else:
		countdown_timer.start()

func countdown_finished():
	countdown_label.text = "Time's up!"
	close_scroll()

func remove_current_question():
	if questions.size() > 0:
		questions.remove_at(random_index)
		question_options.remove_at(random_index)
		boolean_options.remove_at(random_index)
