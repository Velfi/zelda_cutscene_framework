extends Node3D

## The cutscene node to play once triggered.
@export var cutscene_node: Node3D
## If true, the cutscene will be triggered once and this node will be deleted.
@export var oneshot: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if cutscene_node == null:
		printerr("Cutscene node is not found")
		print_stack()
		return
	if not cutscene_node.has_method("play"):
		printerr("Cutscene node has no `play method")
		print_stack()


func _on_trigger() -> void:
	cutscene_node.play()
	if oneshot:
		queue_free()


func _on_trigger_body_entered(_body: Node3D) -> void:
	_on_trigger()
