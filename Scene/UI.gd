extends CanvasLayer
class_name  UI

@onready var center_container: CenterContainer = $MarginContainer/CenterContainer

func _ready() -> void:
	center_container.hide()

func game_won():
	center_container.show()
