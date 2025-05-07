extends CharacterBody3D
class_name Player

const SPEED = 4.0
const JUMP_VELOCITY = 4.5

var input_dir: Vector2 = Vector2.ZERO
var jump_input: bool = false


func _ready() -> void:
	var player_controller = get_node("PlayerController")
	if player_controller == null:
		printerr("Player controller not found")
		print_stack()
		return

	player_controller.connect("movement_input", _on_movement_input)
	player_controller.connect("jump_input", _on_jump_input)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if jump_input and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	clear_input()


## Called by the player controller when movement input is detected.
func _on_movement_input(direction: Vector2) -> void:
	input_dir = direction


func _on_jump_input() -> void:
	jump_input = true


func clear_input() -> void:
	input_dir = Vector2.ZERO
	jump_input = false
