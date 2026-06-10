extends Node2D

@export var min_zoom: float = 1.0
@export var def_zoom: float = 2.0
@export var max_zoom: float = 8.0

@onready var _camera: Camera2D = $Camera2D


func _ready() -> void:
	_camera.zoom = Vector2(def_zoom, def_zoom)


func _process(_delta: float) -> void:
	var center_offset: Vector2 = get_viewport_rect().size / 2
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var offset: Vector2 = (mouse_pos - center_offset)
	_camera.offset = -offset / _camera.zoom.x
	_camera.position = offset*1.125


func _input(event: InputEvent) -> void:
	#zoom in on mouse wheel up, zoom out on mouse wheel down
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_out()
	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_F11:  # '+' key
			DisplayServer.window_set_mode(
				(
					DisplayServer.WINDOW_MODE_WINDOWED
					if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
					else DisplayServer.WINDOW_MODE_FULLSCREEN
				)
			)
			# OS.window_fullscreen = not OS.window_fullscreen


func zoom_in() -> void:
	_camera.zoom = _camera.zoom * 2.0
	_camera.zoom = Vector2(
		clamp(_camera.zoom.x, min_zoom, max_zoom), clamp(_camera.zoom.y, min_zoom, max_zoom)
	)


func zoom_out() -> void:
	_camera.zoom = _camera.zoom * 0.5
	_camera.zoom = Vector2(
		clamp(_camera.zoom.x, min_zoom, max_zoom), clamp(_camera.zoom.y, min_zoom, max_zoom)
	)
