extends Area2D

var current_scatter_index = 0

@export var speed = 120
@export var movement_target : Resource
@export var tile_map: TileMap

@onready var navigation_agent_2d = $NavigationAgent2D

func _ready():
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)

	call_deferred("setup")

func _process(delta):
	move_mahasiswa(navigation_agent_2d.get_next_path_position(), delta)

func move_mahasiswa(next_position: Vector2, delta: float):
	var current_mahasiswa_position = global_position
	
	var new_velocity = (next_position - current_mahasiswa_position).normalized() * speed * delta
	position += new_velocity

func setup():
	print(tile_map.get_navigation_map(0))
	navigation_agent_2d.set_navigation_map(tile_map.get_navigation_map(0))
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), tile_map.get_navigation_map(0))
	scatter()

func scatter():
	navigation_agent_2d.target_position = movement_target.scatter_target[current_scatter_index].position

func on_position_reached():
	if current_scatter_index < 3:
		current_scatter_index += 1
	else:
		current_scatter_index = 0
		
	navigation_agent_2d.target_position = movement_target.scatter_target[current_scatter_index].position
	
