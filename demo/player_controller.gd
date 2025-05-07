extends Node
class_name PlayerController

signal movement_input(Vector2)
signal jump_input


@export var is_disabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if not parent is CharacterBody3D:
		printerr("Player controller must be a child of a CharacterBody3D")
		print_stack()


func disable_control() -> void:
	is_disabled = true


func enable_control() -> void:
	is_disabled = false


func _process(_delta: float) -> void:
	if is_disabled:
		return

	# Handle movement input in _process for smoother response
	var new_movement_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if new_movement_input != Vector2.ZERO:
		movement_input.emit(new_movement_input.normalized())


func _input(event: InputEvent) -> void:
	if is_disabled:
		return

	# Only handle jump input in _input since it's a one-time action
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		jump_input.emit()
