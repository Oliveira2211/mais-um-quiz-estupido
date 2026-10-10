extends Control

@onready var display_group: Control = %Display
@onready var display_text: RichTextLabel = %Text
@onready var display_title: Label = %Title
@onready var selection_group: Control = %Selection


#--- Private functions
func _switch_visibility():
	selection_group.visible = not selection_group.visible
	display_group.visible = not display_group.visible


#--- Control signals
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/quiz.tscn")

func _on_about_pressed() -> void:
	_switch_visibility()
	display_title.text = "Sobre"
	display_text.text = "Game Jam: Clecio Gamedev JAM Especial de Aniversário\nTema: Mais 1\n\nEssa Jam me pegou de surpresa e como estou solo e ultimamente só tenho trabalho em UI e back-end de aplicativos, resolvi fazer um quiz simples só para participar e reaprender os recursos da Godot."

func _on_credits_pressed() -> void:
	_switch_visibility()
	display_title.text = "Créditos"
	display_text.text = "Criador por\nAlisson H. de Oliveira\nGitHub: Oliveira2211\n\n\n*Assets de terceiros estão listados no repositório do GitHub e na descrição da página da Itch.io"

func _on_back_pressed() -> void:
	_switch_visibility()
