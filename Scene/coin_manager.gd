extends Node

var total_pellets_count
var pellets_eaten = 0

@onready var ui: CanvasLayer = $"../UI" as UI

func _ready():
	var pellets = self.get_children() as Array[Coin]
	print("Jumlah koin yang ditemukan oleh manager: ", pellets.size())
	total_pellets_count = pellets.size()
	
	for pellet in pellets:
		pellet.koin_diambil.connect(on_pellet_eaten)

func on_pellet_eaten():
	pellets_eaten += 1
	print("Koin dimakan: ", pellets_eaten, " / ", total_pellets_count)
	if pellets_eaten == total_pellets_count:
		ui.game_won()
