extends Control

const QUESTIONS: Dictionary = {
	1: {
		"title": "Quanto é 1+1?",
		"answer_id": 2,
		"options": ["0", "1", "2", "11"],
	},
	2: {
		"title": "Qual alternativa representa um operador incremental válido na linguagem de programação C?",
		"answer_id": 1,
		"options": ["i+;", "i++;", "i++1;", "+1"],
	},
	3: {
		"title": "A definição abaixo refere-se a qual palavra?\n\n“Interjeição usada pelo público para pedir que o artista repita uma música ou volte ao palco para mais uma performance.”",
		"answer_id": 2,
		"options": ["Bizu", "Biz", "Bis", "Biss"],
	},
	4: {
		"title": "A música Baby One More Time é de qual artista?",
		"answer_id": 1,
		"options": ["Avicii", "Britney Spears", "David Guetta", "Lady Gaga"],
	},
	5: {
		"title": "A definição abaixo refere-se a qual princípio da matéria Raciocínio Lógico?\n\n“Se em n caixas são postos n + 1 pombos, então pelo menos uma caixa terá mais de um pombo.”",
		"answer_id": 3,
		"options": ["Princípio das caixas", "Princípio dos pombos", "Princípio da casa de caixas", "Princípio da casa dos pombos"],
	},
	6: {
		"title": "Quantas perguntas faltam para acabar esse Quiz?",
		"answer_id": 1,
		"options": ["0", "1", "Não sei", "Mais de 8000"],
	},
	7: {
		"title": "Quer adicionar uma pergunta a esse Quiz?",
		"answer_id": null,
		"options": ["Sim", "Claro", "Com certeza", "Certamente que sim"],
	},
	8: {
		"title": "Esse Quiz foi divertido! Quer jogá-lo mais uma vez?",
		"answer_id": null,
		"options": ["Agora", "Imediatamente", "Prontamente", "Neste attosegundo"],
	},
}

#--- Nodes
@onready var actions: HBoxContainer = %Actions
@onready var actions_buttons: Array[Node] = actions.get_children()
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var correct_answer: AudioStreamPlayer = %CorrectAnswer
@onready var game_over_dialog: PanelContainer = %GameOverDialog
@onready var game_over_label: Label = %GameOverLabel
@onready var help_dialog: PanelContainer = %HelpDialog
@onready var incorrect_answer: AudioStreamPlayer = %IncorrectAnswer
@onready var jump: AudioStreamPlayer = %Jump
@onready var music: AudioStreamPlayer = %Music
@onready var options: GridContainer = %Options
@onready var options_buttons: Array[Node] = options.get_children()
@onready var question_counter: Label = %QuestionCounter
@onready var question_title: Label = %QuestionTitle
@onready var suspense: AudioStreamPlayer = %Suspense
@onready var timer: Timer = %Timer


#-- Styles
const STYLEBOX_ANSWER = preload("res://styles/quiz_option_button_hover.tres")
const STYLEBOX_CORRECT = preload("res://styles/quiz_option_button_correct.tres")
const STYLEBOX_INCORRECT = preload("res://styles/quiz_option_button_incorrect.tres")
const STYLEBOX_NORMAL = preload("res://styles/quiz_option_button.tres")


#--- Values
const ANSWER_DELAY: float = 1.0
const SUSPENSE_DELAY: float = 5.0
const OPTION_LETTERS: Array[String] = ["A", "B", "C", "D"]

var current_question: int
var question_total: int


#--- Godot functions
func _ready() -> void:
	_start_quiz()


#--- Private functions
func _answer(id: int):
	timer.stop()
	
	for o in options_buttons:
		o.disabled = true
	
	for a in actions_buttons:
		a.disabled = true
	
	options_buttons[id].add_theme_stylebox_override("disabled", STYLEBOX_ANSWER)
	music.stream_paused = true
	suspense.play()
	await get_tree().create_timer(SUSPENSE_DELAY).timeout
	suspense.stop()
	
	if not QUESTIONS[current_question]["answer_id"] or id == QUESTIONS[current_question]["answer_id"]:
		options_buttons[id].add_theme_stylebox_override("disabled", STYLEBOX_CORRECT)
		correct_answer.play()
		await get_tree().create_timer(ANSWER_DELAY).timeout
		music.stream_paused = false
		if current_question < question_total:
			current_question += 1
			_load_question()
		elif current_question == 7:
			question_total += 1
			current_question += 1
			_load_question()
		else:
			_start_quiz()
	else:
		options_buttons[QUESTIONS[current_question]["answer_id"]].add_theme_stylebox_override("disabled", STYLEBOX_CORRECT)
		options_buttons[id].add_theme_stylebox_override("disabled", STYLEBOX_INCORRECT)
		incorrect_answer.play()
		await get_tree().create_timer(ANSWER_DELAY).timeout
		game_over()

func _load_question():
	question_counter.text = ("%02d/%02d" % [current_question, question_total])
	question_title.text = QUESTIONS[current_question]["title"]
	
	var i: int = 0
	
	for o in options_buttons:
		o.text = OPTION_LETTERS[i] + ") " + QUESTIONS[current_question]["options"][i]
		o.add_theme_stylebox_override("disabled", STYLEBOX_NORMAL)
		o.disabled = false
		i += 1
	
	for a in actions_buttons:
		a.disabled = false
	
	timer.restart()

func _start_quiz():
	animation_player.play("RESET")
	help_dialog.visible = false
	current_question = 1
	question_total = len(QUESTIONS) - 1
	_load_question()
	music.play()


#--- Public functions
func game_over():
	timer.stop()
	music.stop()
	game_over_label.text = "Você acertou " + str(current_question - 1) + " de " + str(question_total) + " - " +str((current_question - 1) * 100 / question_total) + "%"
	animation_player.play("game_over")


#--- Control signals
func _on_a_pressed() -> void:
	_answer(0)

func _on_b_pressed() -> void:
	_answer(1)

func _on_c_pressed() -> void:
	_answer(2)

func _on_d_pressed() -> void:
	_answer(3)

func _on_help_pressed() -> void:
	help_dialog.visible = true

func _on_close_help_dialog_pressed() -> void:
	help_dialog.visible = false

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_restart_pressed() -> void:
	_start_quiz()

func _on_stop_pressed() -> void:
	game_over()

func _on_jump_pressed() -> void:
	animation_player.play("jump")
	jump.play()
