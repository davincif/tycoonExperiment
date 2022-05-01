extends Node2D

export var initial_size := Vector2(10, 10)


# Called when the node enters the scene tree for the first time.
func _ready():
	generateWorld()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass


# generate a new world, randomizing and filling the tilemap
func generateWorld():
	# for performance measurements
	var start_time=OS.get_ticks_msec()

	# getting random number ready >=)
	randomize()

	# generating map
	var map = get_node("TileMap")

	var size_x = self.initial_size.x
	var size_y = self.initial_size.y
	var tile = 0
	for x in range(size_x):
		for y in range(size_y):
			tile = randi() % 7
			map.set_cell(x, y, tile)

	# for performance measurements
	var final_time = OS.get_ticks_msec()
	var performance = final_time - start_time
	print('map created in: ', performance/1000.0, 's')
