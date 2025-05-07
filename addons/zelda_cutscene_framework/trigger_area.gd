extends Area3D

signal triggered

## A list of nodes that can trigger the area
@export var trigger_nodes: Array[Node3D] = []

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if trigger_nodes.has(body):
		emit_signal("triggered")
