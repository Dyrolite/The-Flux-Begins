extends CharacterBody2D

class_name Player

@export var speed = 300
var movement_direction = Vector2.ZERO



func _physics_process(delta):
	get_input()
	
	velocity = movement_direction * speed
	move_and_slide()


func get_input():
	if Input.is_action_pressed("Left"):
		movement_direction = Vector2.LEFT
		rotation_degrees = 0
	elif Input.is_action_pressed("Right"):
		movement_direction = Vector2.RIGHT
		rotation_degrees = 180
	elif Input.is_action_pressed("Down"):
		movement_direction = Vector2.DOWN
		rotation_degrees = 270
	elif Input.is_action_pressed("Up"):
		movement_direction = Vector2.UP
		rotation_degrees = 90
