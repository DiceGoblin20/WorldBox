extends Camera2D

@export var speed = 1000
@export var zoomSpeed = 0.1
@export var speedAtZoomAmount = 1#6.5

@export var rightClamp: int = 3900
@export var leftClamp: int = 200
@export var bottomClamp: int = 3900
@export var topClamp: int = 200


func _process(delta):
	var velocity = Vector2()
	var zoomAmount = Vector2()
	
	if Input.is_action_pressed("MoveRight"):
		if position.x < rightClamp:
			velocity.x += 1
	
	if Input.is_action_pressed("MoveLeft"):
		if position.x > leftClamp:
			velocity.x -= 1
	
	if Input.is_action_pressed("MoveDown"):
		if position.y < bottomClamp:
			velocity.y += 1
	
	if Input.is_action_pressed("MoveUp"):
		if position.y > topClamp:
			velocity.y -= 1
	
	position += velocity * delta * (speed * (zoom.x * speedAtZoomAmount))
	
	
	if Input.is_action_pressed("ZoomIn"):
		zoomAmount.x += zoomSpeed
		zoomAmount.y += zoomSpeed
	
	if Input.is_action_pressed("ZoomOut"):
		if zoom.y > 0.155:
			zoomAmount.x -= zoomSpeed
			zoomAmount.y -= zoomSpeed
	
	zoom += zoomAmount * delta * zoomSpeed


func _on_world_generator_position_camera(width, height):
	position.x = (width * 16) / 2
	position.y = (height * 16) / 2
