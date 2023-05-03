extends Node2D

signal positionCamera(width: int, height: int)

@export var width = 640
@export var height = 260
@export var genSeed = -1
@export var nightSpeed = 1
@export var rivers: int = 7

@export var tper = 400
@export var toct = 25

@export var mper = 400
@export var moct = 25

@export var aper = 400
@export var aoct = 25

@onready var tilemap = $TileMap
@onready var rng = RandomNumberGenerator.new()

var temperature = {}
var moisture = {}
var altitude = {}
var biome = {}
var noise = FastNoiseLite.new()
var maxLatitude = height/2

var latitude: int


func _process(delta):
	$NightA.position.x -= nightSpeed * delta #Remove delta for speedy nights
	$NightB.position.x -= nightSpeed * delta

	if $NightA.position.x <= -1040:
		$NightA.position.x = 7280

	if $NightB.position.x <= -1040:
		$NightB.position.x = 7280
	

#func GenerateMap(per, oct):
func GenerateMap(per, oct):
	var seed = randi()
	if genSeed > 0:
		noise.seed = genSeed
		rng.seed = genSeed
		$Seed.text = str(genSeed)
	else:
		noise.seed = seed
		rng.seed = seed
		$Seed.text = str(seed)
	#noise.seed = 1234
	noise.domain_warp_fractal_lacunarity = per#general size of gaps between noise
	noise.fractal_octaves = oct #higher octaves = higher detail
	var gridName = {}
	for x in range(width):
		for y in range(height):
			var rand = 2 * (abs(noise.get_noise_2d(x, y)))
			gridName[Vector2(x, y)] = rand
	#$Seed.text = str(seed)
	#$SeedBackground.size.x = $Seed.size.x
	return gridName
	
	
func _ready():
	temperature = GenerateMap(tper, toct)
	moisture = GenerateMap(mper, moct)
	altitude = GenerateMap(aper, aoct)

	SetTile(width, height)
	emit_signal("positionCamera", width, height)
	#$Camera.position.x = 576
	#$Camera.position.y = 300
	

func Between(val, start, end): #Nick seal of approval
	if start <= val and val < end:
		return true


func SetTile(width, height):
	var articOcean = 17
	for x in range(width):
		#var articOcean = rng.randi_range(16, 18)
		#if articOcean == 16:
			#articOcean += 1
		#elif articOcean == 18:
			#articOcean -= 1
		#elif articOcean == 17:
			#articOcean = rng.randi_range(16, 18)
		
		for y in range(height):
			var position = Vector2(x, y)
			var alt = altitude[position]
			var temp = temperature[position]
			var moist = moisture[position] 
			var tile = Vector2i(moist, temp)
			
			if position.y <= maxLatitude:
				latitude = position.y
			else: 
				latitude = maxLatitude - (position.y - maxLatitude)
			#Higher latitude is closer to the equator
			
			var snowCircle = rng.randi_range(15,25)
			var tropics = rng.randi_range(65,75)
			
			
			
			#Ocean
			if alt < 0.55:
				if latitude <= articOcean:
					tile = Vector2i(3, 0)
					tilemap.set_cell(0, position, 0, tile)
				else:
					tile = Vector2i(3, 2)
					tilemap.set_cell(0, position, 0, tile)
			#Beach
			elif Between(alt, 0.55, 0.6):
				if latitude > snowCircle:
					tile = Vector2i(1, 3)
					tilemap.set_cell(0, position, 0, tile)
				elif latitude <= snowCircle:
					tile = Vector2i(4, 0)
					tilemap.set_cell(0, position, 0, tile)
			
			#Other Biomes
			elif Between(alt, 0.6, 0.93):
				if latitude >= tropics + 15:
					#Jungle
					if Between(moist, 0.3, 0.85):
						tile = Vector2i(4, 2)
						tilemap.set_cell(0, position, 0, tile)
					#Swamp
					if Between(moist, 0, 0.3):
						tile = Vector2i(4, 3)
						tilemap.set_cell(0, position, 0, tile)
					
					
				if Between(latitude, tropics - 20, tropics + 15):
					#Desert
					if Between(moist, 0.25, 1):
						tile = Vector2i(1, 3)
						tilemap.set_cell(0, position, 0, tile)
				
					#Extreme Desert
					if moist < 0.25:
						tile = Vector2i(0, 3)
						tilemap.set_cell(0, position, 0, tile)
						
						
				if latitude >= snowCircle and latitude < tropics:# - 20:
					#Plains
					if Between(moist, 0, 0.4):# and temp <= 0.6:
						tile = Vector2i(2, 2)
						tilemap.set_cell(0, position, 0, tile)
					
					#Forest
					if Between(moist, 0.4, 0.85):
						tile = Vector2i(2, 3)
						tilemap.set_cell(0, position, 0, tile)
					
				if latitude < snowCircle:
					#Snow
					tile = Vector2i(4, 0)
					tilemap.set_cell(0, position, 0, tile)
					
				
			elif Between(alt, 0.93, 1.1):
				tile = Vector2i(2, 0)
				tilemap.set_cell(0, position, 0, tile)
			
			elif Between(alt, 1.1, 1.4):
				tile = Vector2i(0, 0)
				tilemap.set_cell(0, position, 0, tile)
				
			else:
				tile = Vector2i(1, 2)
				tilemap.set_cell(0, position, 0, tile)
			


func StartRiver(tile: TerrainTile, position):
	var terrainTile = tile
	#var terrainTile = TerrainTile.new()
	terrainTile.tile = Vector2i(3, 3)
	terrainTile.position = position
	
	tile.position = position
	#while tile.alt >= 0.55:
		#terrainTile = tile.position.y - 1
		#var north = terrainTile
	
		#terrainTile = tile.position.y + 1
		#var south = terrainTile
	
		#terrainTile = tile.position.x + 1
		#var east = terrainTile
	
		#terrainTile = tile.position.x - 1
		#var west = terrainTile
	while tile.alt >= 0.55:
		terrainTile.position.y = tile.position.y - 1
		var north = terrainTile
	
		terrainTile = tile.position.y + 1
		var south = terrainTile
	
		terrainTile = tile.position.x + 1
		var east = terrainTile
	
		terrainTile = tile.position.x - 1
		var west = terrainTile
		
		if north.altitude <= south.altitude and north.altitude <= east.altitude and north.altitude <= west.altitude and north.altitude >= 0.55:
			tile = north
			tilemap.set_cell(0, tile.position, 0, terrainTile.tile)
	
		elif south.altitude < north.altitude and south.altitude <= east.altitude and south.altitude <= west.altitude and south.altitude >= 0.55:
			tile = south
			tilemap.set_cell(0, tile.position, 0, terrainTile.tile)
	
		elif east.altitude < north.altitude and east.altitude < south.altitude and east.altitude <= west.altitude and east.altitude >= 0.55:
			tile = east
			tilemap.set_cell(0, tile.position, 0, terrainTile.tile)
	
		elif west.altitude < north.altitude and west.altitude < east.altitude and west.altitude < east.altitude and west.altitude >= 0.55:
			tile = west
			tilemap.set_cell(0, tile.position, 0, terrainTile.tile)
	
		tilemap.set_cell(0, terrainTile.position, 0, terrainTile.tile)
	
	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		temperature = GenerateMap(tper, toct)
		moisture = GenerateMap(mper, moct)
		altitude = GenerateMap(aper, aoct)
		SetTile(width, height)
