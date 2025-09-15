extends CanvasLayer
class_name  UI

@onready var center_container: CenterContainer = $MarginContainer/CenterContainer
@onready var gamescore: Label = %gamescore
@onready var game_label: Label = %GameLabel
@onready var lifelabel: Label = %lifelabel

func _ready() -> void:
	center_container.hide()

func set_lifes(life):
	lifelabel.text = "%d up" % life
	if life == 0:
		game_lost()
		

func set_score(score):
	gamescore.text = "GAME SCORE: %d" % score

func game_lost():
	game_label.text = "Game lost"
	center_container.show()

func game_won():
	game_label.text = "Game Won"
	center_container.show()


func _on_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		
	# Perintah ini akan me-reload seluruh scene yang sedang berjalan
	get_tree().reload_current_scene()
