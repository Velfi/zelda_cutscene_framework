extends CutsceneComponent
class_name KillNodes

@export var target_nodes: Array[Node]

func _ready() -> void:
	if target_nodes.is_empty():
		printerr("target_node(s) not set, please set at least one target_node for %s" % get_path())
		print_stack()
		return

func play() -> void:
	for node in target_nodes:
		node.queue_free()
