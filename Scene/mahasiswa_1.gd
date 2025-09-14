extends Area2D
class_name Mahasiswa

enum MahasiswaState {
	SCATTER,
	CHASE,
	LARI,
	TERKALAHKAN,
	MULAI_DI_BASE
}

var current_scatter_index = 0
var current_at_home_index = 0
var moving = true
var current_state: MahasiswaState

@export var speed_terkalahkan = 240
@export var speed = 120
@export var movement_target : Resource
@export var tile_map: mazeTilemap
@export var chasing_target: Node2D
@export var point_manager: PointManager
@export var is_starting_at_home = false
@export var starting_position = Node2D

@onready var at_home_timer: Timer = $AtHomeTimer
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var scatter_timer = $scatterTimer
@onready var update_scatter_timer = $UpdateScatterTimer
@onready var lari_timer: Timer = $LariTimer
@onready var point_label: Label = $pointLabel
@onready var kejar_animatted: AnimatedSprite2D = $KejarAnimatted
@onready var bungkam_animated: AnimatedSprite2D = $BungkamAnimated

var scatter_target_nodes: Array[Node2D]
var at_home_target_nodes: Array[Node2D]

func _ready():
	at_home_timer.timeout.connect(scatter)
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 20.0
	navigation_agent_2d.navigation_finished.connect(on_position_reached) # ganti pakai ini
	call_deferred("populate_target_nodes")
	update_animation()

func update_animation():
	# Fungsi ini mengontrol sprite mana yang aktif
	if current_state == MahasiswaState.LARI || current_state == MahasiswaState.TERKALAHKAN:
		kejar_animatted.hide()
		bungkam_animated.show()
		bungkam_animated.play("default") # Asumsi nama animasinya "default"
	elif current_state == MahasiswaState.TERKALAHKAN:
		kejar_animatted.hide()
		bungkam_animated.hide()
		# Anda mungkin punya sprite mata di sini, atur visibilitasnya
	else: # Ini berlaku untuk CHASE, SCATTER, dll.
		kejar_animatted.show()
		bungkam_animated.hide()
		kejar_animatted.play("default") # Asumsi nama animasinya "default"

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
			
	for path in movement_target.at_home_target_paths:
		var node = get_node_or_null(path)
		if node:
			at_home_target_nodes.append(node)
		else:
			print("PERINGATAN: Gagal menemukan node untuk at_home path: ", path)
	
	setup_navigation()

func setup_navigation():
	var nav_map = tile_map.get_navigation_map()
	if nav_map.is_valid():
		navigation_agent_2d.set_navigation_map(nav_map)
		print("Peta navigasi berhasil di-set.")
	else:
		print("ERROR: Peta navigasi tidak valid!")
	if is_starting_at_home:
		start_at_home()
	else:
		scatter()

func start_at_home():
	current_state = MahasiswaState.MULAI_DI_BASE
	at_home_timer.start()
	navigation_agent_2d.target_position = at_home_target_nodes[current_at_home_index].position

func _process(delta):
	if navigation_agent_2d.is_navigation_finished():
		return  # jangan jalan kalau sudah sampai
	var next_waypoint = navigation_agent_2d.get_next_path_position()
	move_mahasiswa(next_waypoint, delta)


func move_mahasiswa(next_position: Vector2, delta: float):
	var distance_to_next = global_position.distance_to(next_position)
	var current_speed = speed_terkalahkan if current_state == MahasiswaState.TERKALAHKAN else speed
	if distance_to_next < 0.1:
		return

	var direction = global_position.direction_to(next_position)
	var travel_distance = current_speed * delta
	
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
	elif current_state == MahasiswaState.LARI:
		print("--- Sampai di titik acak, mencari titik acak baru... (Timer masih berjalan)")
		var empty_cell_position = tile_map.get_random_empty_cell_position()
		navigation_agent_2d.target_position = empty_cell_position
	elif current_state == MahasiswaState.TERKALAHKAN:
		start_chasing_tikus_after_terkalahkan()
	elif current_state == MahasiswaState.MULAI_DI_BASE:
		move_to_next_home_position()

func move_to_next_home_position():
	current_at_home_index = 1 if current_at_home_index == 0 else 0
	navigation_agent_2d.target_position = at_home_target_nodes[current_at_home_index].position

func chase_position_reached():
	print("kill pacman")

func scatter_position_reached():
	print("Selesai di target (indeks ", current_scatter_index, ")")
	current_scatter_index = (current_scatter_index + 1) % scatter_target_nodes.size()
	scatter()

func start_chasing_tikus():
	if chasing_target == null:
		print("no chasing target")
	current_state = MahasiswaState.CHASE
	update_animation()
	update_scatter_timer.start()
	navigation_agent_2d.target_position = chasing_target.position

func _on_scatter_timer_timeout() -> void:
	start_chasing_tikus()

func _on_update_scatter_timer_timeout() -> void:
	navigation_agent_2d.target_position = chasing_target.position

func lari_dari_tikus():
	lari_timer.start()
	current_state = MahasiswaState.LARI
	update_animation()
	if is_starting_at_home:
		at_home_timer.stop()
	update_scatter_timer.stop()
	scatter_timer.stop()
	print(">>> MEMULAI STATE LARI! Timer di-reset ke ", lari_timer.wait_time, " detik.")
	
	var empty_cell_position = tile_map.get_random_empty_cell_position()
	navigation_agent_2d.target_position = empty_cell_position


func _on_lari_timer_timeout() -> void:
	print("lari selesai")
	start_chasing_tikus()
	

func get_eaten():
	current_state = MahasiswaState.TERKALAHKAN
	update_animation()
	point_label.show()
	point_label.text = "%d" % point_manager.point_mengalahkan_mahasiswa 
	await point_manager.pause_saat_kalahkan_mahasiswa()
	point_label.hide()
	lari_timer.stop()
	navigation_agent_2d.target_position = at_home_target_nodes[0].position

func start_chasing_tikus_after_terkalahkan():
	start_chasing_tikus()


func _on_body_entered(body: Node2D) -> void:
	# Pertama, pastikan yang masuk adalah player. Jika bukan, abaikan.
	if not body.is_in_group("Player"):
		return
		
	var player = body as Player

	# Logika utama berdasarkan state saat ini
	# Gunakan "match" untuk struktur yang lebih bersih dan anti-tabrakan logika
	match current_state:
		MahasiswaState.LARI:
			# Jika sedang lari, MAKA HANYA lakukan logika "get_eaten".
			get_eaten()
		
		MahasiswaState.CHASE, MahasiswaState.SCATTER:
			# Jika sedang mengejar/patroli, MAKA HANYA lakukan logika "player.die()".
			set_collision_mask_value(1, false)
			update_scatter_timer.stop()
			player.die()
			scatter_timer.wait_time = 600
			scatter()

		# Untuk state lain (TERKALAHKAN, dll.), jangan lakukan apa-apa saat tabrakan.
		_:
			pass


func _on_at_home_timer_timeout() -> void:
	pass # Replace with function body.
	
func reset():
	# Kembalikan ke posisi awal
	get_tree().paused = true
	await  get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	if starting_position:
		global_position = starting_position.global_position
	
	# Hentikan semua timer untuk memastikan tidak ada state aneh
	scatter_timer.stop()
	update_scatter_timer.stop()
	lari_timer.stop()
	at_home_timer.stop()
	set_collision_mask_value(1, true)
	# Reset state dan panggil setup navigasi awal
	# Ini akan memulai patroli (scatter) atau memulai di base
	setup_navigation()
	
	# Pastikan animasi juga kembali ke normal
	update_animation()
	
