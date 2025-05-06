extends CutsceneComponent
class_name HideNodes

@export var target_nodes: Array[Node]

func _ready() -> void:
	if target_nodes.is_empty():
		printerr("target_nodes not set, please set at least one target_node for %s" % get_path())
		print_stack()
		return

func play() -> void:
	for node in target_nodes:
		node.hide()
