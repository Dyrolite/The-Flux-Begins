class_name coin
extends Node2D

@onready var right_area2d = $RightColorRect/Area2D
@onready var left_area2d = $LeftColorRect/Area2D

var allow_transition_right = true
var allow_transition_left = true

func _on_right_area_2d_body_entered(body: Node2D) -> void:
	if body.velocity.x > 0:
		body.position.x = left_area2d.global_position.x
		allow_transition_left = false

func _on_right_area_2d_body_exited(body: Node2D) -> void:
	allow_transition_right = true

func _on_left_area_2d_body_entered(body: Node2D) -> void:
	if body.velocity.x < 0:
		body.position.x = right_area2d.global_position.x
		allow_transition_right = false

func _on_left_area_2d_body_exited(body: Node2D) -> void:
	allow_transition_left = true
