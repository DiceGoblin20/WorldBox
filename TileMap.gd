extends TileMap

#var moisture = FastNoiseLite.new()
#var temperature = FastNoiseLite.new()
#var altitude = FastNoiseLite.new()
#var width = 500
#var height = 500


func _ready():
	pass
	#moisture.seed = randi()
	#temperature.seed = randi()
	#altitude.seed = randi()
	

func _process(delta):
	pass
	#GenerateChunk(position)


#func GenerateChunk(position):
#	var tilePosition = local_to_map(position)
#	for x in range(width):
#		for y in range(height):
#			var moist = moisture.get_noise_2d(tilePosition.x - width/2 + x, tilePosition.y - height/2 + y) * 10
#			var temp = temperature.get_noise_2d(tilePosition.x - width/2 + x, tilePosition.y - height/2 + y) * 10
#			var alt = altitude.get_noise_2d(tilePosition.x + x - width/2, tilePosition.y - height/2 + y) * 10
#			if alt < 2:
#				set_cell(0, Vector2i(tilePosition.x - width/2 + x, tilePosition.y - height/2 + y), 0, Vector2(3, round((temp + 10) /5)))
#			else:
#				set_cell(0, Vector2i(tilePosition.x - width/2 + x, tilePosition.y - height/2 + y), 0, Vector2(round((moist + 10) /5), round((temp + 10) /5)))
