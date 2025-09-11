extends Area2D

@export var speed = 120
@export var movement_target : Resource

@onready var navigation_agent_2d = $NavigationAgent2D

func _ready() -> void:
