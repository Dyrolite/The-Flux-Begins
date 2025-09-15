extends TileMapLayer

class_name mazeTilemap

var empty_cells = []

func _ready() -> void:
	var cells = get_used_cells()
	
	for cell in cells:
		var data = get_cell_tile_data(cell)
		if data.get_custom_data("isEmpty"):
			empty_cells.push_front(cell)
	
func get_random_empty_cell_position():
	return to_global(map_to_local(empty_cells.pick_random()))
