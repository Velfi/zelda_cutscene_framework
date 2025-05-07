extends Node3D

var camera_at_start: Camera3D
## When set, the player controller will be disabled when the cutscene starts and enabled when it ends
@export var player_controller: Node = null

func _ready() -> void:
	camera_at_start = get_viewport().get_camera_3d()

## Plays the cutscene by playing each child node in turn.
##
## Once all child nodes have finished, the camera will be switched back to the
## original camera and the player controller will be enabled (if it was disabled.)
func play() -> void:
	if player_controller != null:
		player_controller.disable_control()
	var children = get_children()

	for child in children:
		if not child is CutsceneComponent:
			printerr("Child %s is not a CutsceneComponent" % child.name)
			continue

		if child.has_method("play"):
			await child.play()
		else:
			printerr("Child %s does not have a play method" % child.name)
	
	camera_at_start.make_current()
	if player_controller != null:
		player_controller.enable_control()
