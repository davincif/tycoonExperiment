extends Camera2D


const State := {
	IDLE = 0,
	ZOOMING_IN = 1,
	ZOOMING_OUT = 2,
	DRAGGING = 3,
}


export var zoom_step: float = 0.1
export var max_zoom: float = 3
export var min_zoom: float = 0.5
export var zoom_duration_sec: float = 0.5


var cur_state = self.State.IDLE

# related to zoom
var zoom_interpolation_time_passed: float = 0
var zoom_interpolation_start: float = self.zoom.x


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match self.cur_state:
		State.IDLE:
			if Input.is_action_just_released("game_zoom_in"):
				state_change(self.State.ZOOMING_IN)
				self.cur_state = self.State.ZOOMING_IN
			elif Input.is_action_just_released("game_zoom_out"):
				state_change(self.State.ZOOMING_OUT)
				self.cur_state = self.State.ZOOMING_OUT

# Called during the physics processing.The frame rate is synced to the physics
func _physics_process(delta):
	match self.cur_state:
		State.ZOOMING_IN:
			var ended = zoomCamera(true, delta)
			if ended:
				self.cur_state = State.IDLE

		State.ZOOMING_OUT:
			var ended = zoomCamera(false, delta)
			if ended:
				self.cur_state = State.IDLE


# do some needed work before the change between States
# @param change_for the State for which the current state is change
func state_change(change_for):
	if change_for == State.ZOOMING_IN or change_for == State.ZOOMING_OUT:
		self.zoom_interpolation_time_passed = 0
		self.zoom_interpolation_start = self.zoom.x

# zooming camera according to the boundaries and step configurations
# @param zoom_in if the camera is zooming in (true), or out (false)
# @returns false if the zooming hasn't still enteded and true when it's done
func zoomCamera(zoom_in: bool, delta: float):
	# checking boundaries
	var step =  -self.zoom_step if zoom_in else self.zoom_step
	var endOfZoom = self.zoom_interpolation_start + step

	if(endOfZoom > self.max_zoom):
		endOfZoom = self.max_zoom
		return true

	if(endOfZoom < self.min_zoom):
		endOfZoom = self.min_zoom
		return true

	# calcing new zoom
	var final_interpolation_value = self.zoom_interpolation_start + step
	var new_zoom = lerp(
		self.zoom_interpolation_start,
		final_interpolation_value,
		self.zoom_interpolation_time_passed
	)

	# finally updating the camera zoom
	self.zoom.x = new_zoom
	self.zoom.y = new_zoom

	# checking final of interpolation
	self.zoom_interpolation_time_passed += delta
	if self.zoom_interpolation_time_passed >= self.zoom_step or new_zoom >= endOfZoom:
		return true

	# informing about the interpolation state
	return false
