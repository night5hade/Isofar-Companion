extends Camera2D

# Zoom limits and speed
const MIN_ZOOM = 0.5  # Maximum zoom in
const MAX_ZOOM = 4.0  # Maximum zoom out
var zoom_speed = 0.05  # How quickly to zoom

# Panning variables
var is_panning = false
var last_mouse_position = Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				# Start panning
				is_panning = true
				last_mouse_position = get_viewport().get_mouse_position()
			else:
				# Stop panning
				is_panning = false

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Zoom in
			zoom = Vector2(zoom.x - zoom_speed, zoom.y - zoom_speed)
			_clamp_zoom()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Zoom out
			zoom = Vector2(zoom.x + zoom_speed, zoom.y + zoom_speed)
			_clamp_zoom()

	elif event is InputEventMouseMotion and is_panning:
		# Calculate the mouse movement offset
		var current_mouse_position = get_viewport().get_mouse_position()
		var mouse_delta = current_mouse_position - last_mouse_position
		# Adjust camera position
		global_position -= mouse_delta * zoom
		last_mouse_position = current_mouse_position

# Ensure zoom stays within defined limits
func _clamp_zoom():
	zoom.x = clamp(zoom.x, MIN_ZOOM, MAX_ZOOM)
	zoom.y = clamp(zoom.y, MIN_ZOOM, MAX_ZOOM)
