extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var center_tile = Vector2i(Game4Constants.MAP_WIDTH / 2, Game4Constants.MAP_HEIGHT / 2)
	var center = $Collectables.map_to_local(center_tile)
	$Rose.position = center
	$Camera.position = center


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_apple_spawn_timeout() -> void:
	while true:
		var rand_cell = Vector2(rng.randi_range(0, Game4Constants.MAP_WIDTH), rng.randi_range(0, Game4Constants.MAP_HEIGHT))
		if $Collectables.get_cell_source_id(rand_cell) == -1:
			$Collectables.set_cell(rand_cell, 1, Vector2i.ZERO, 0)
			#print($Collectables.get_cell_alternative_tile(rand_cell))
			break
	
	for x in Game2Constants.MAP_WIDTH:
		for y in Game2Constants.MAP_HEIGHT:
			var pos = Vector2i(x, y)
			var data = $Collectables.get_cell_tile_data(pos)
			
			if data:
				print("i has data!")
				if $Preserved.get_cell_source_id(pos) == -1 && rng.randf_range(0, 1.0) > 0.9:
					$Collectables.set_cell(pos, 0, data.get_custom_data("Breaks Into"))
				
			$Collectables.set_cell(pos, 1, Vector2i.ZERO, 1)
