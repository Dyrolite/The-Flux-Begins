extends Area2D

enum MahasiswaState {
	SCATTER,
	CHASE
}

var current_scatter_index = 0
var moving = true
var current_state: MahasiswaState

@export var speed = 120
@export var movement_target : MovementTarget
@export var tile_map: TileMapLayer
@export var chasing_target: Node2D

@onready var anim = $AnimatedSprite2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var scatter_timer = $"scatter timer"
@onready var update_scatter_timer = $updatescattertimer
var scatter_target_nodes: Array[Node2D]

func _ready():
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 20.0
	navigation_agent_2d.navigation_finished.connect(on_position_reached) # ganti pakai ini
	call_deferred("populate_target_nodes")

func animated():
	if moving == true:
		anim.play("mahasiswa")

func populate_target_nodes():
	if not movement_target:
		print("ERROR: Resource 'MovementTarget' belum di-assign di Inspector!")
		return

	for path in movement_target.scatter_target_paths:
		var node = get_node_or_null(path)
		if node:
			scatter_target_nodes.append(node)
		else:
			print("PERINGATAN: Gagal menemukan node untuk path: ", path)
			
	setup_navigation()

func setup_navigation():
	var nav_map = tile_map.get_navigation_map()
	if nav_map.is_valid():
		navigation_agent_2d.set_navigation_map(nav_map)
		print("Peta navigasi berhasil di-set.")
	else:
		print("ERROR: Peta navigasi tidak valid!")

	# Memulai gerakan ke target pertama (indeks 0)
	scatter()

func _process(delta):
	if navigation_agent_2d.is_navigation_finished():
		return  # jangan jalan kalau sudah sampai
	var next_waypoint = navigation_agent_2d.get_next_path_position()
	move_mahasiswa(next_waypoint, delta)


func move_mahasiswa(next_position: Vector2, delta: float):
	var distance_to_next = global_position.distance_to(next_position)
	if distance_to_next < 0.1:
		return

	var direction = global_position.direction_to(next_position)
	var travel_distance = speed * delta
	
	if travel_distance > distance_to_next:
		global_position = next_position
	else:
		global_position += direction * travel_distance

func scatter():
	scatter_timer.start()
	current_state = MahasiswaState.SCATTER 
	# Fungsi ini sekarang menjadi satu-satunya tempat untuk mengatur target
	if scatter_target_nodes.is_empty():
		return
	
	var target_node = scatter_target_nodes[current_scatter_index]
	navigation_agent_2d.target_position = target_node.position
	print("======= TARGET BARU DISET: ", target_node.name, " (indeks ", current_scatter_index, ") =======")
	
func on_position_reached():
	if current_state == MahasiswaState.SCATTER:
		scatter_position_reached()
	elif current_state == MahasiswaState.CHASE:
		chase_position_reached()
		
func chase_position_reached():
	print("kill pacman")

func scatter_position_reached():
	print("Selesai di target (indeks ", current_scatter_index, ")")
	current_scatter_index = (current_scatter_index + 1) % scatter_target_nodes.size()
	scatter()

func _on_scatter_timer_timeout() -> void:
	start_chasing_pacman()
	
func start_chasing_pacman():
	if chasing_target == null:
		print("no chasing target")
	current_state = MahasiswaState.CHASE
	update_scatter_timer.start()
	navigation_agent_2d.target_position = chasing_target.position



func _on_updatescattertimer_timeout() -> void:
	navigation_agent_2d.target_position = chasing_target.position
