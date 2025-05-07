extends CutsceneComponent
class_name SwitchCamera

@export var target_camera: Camera3D

func _ready() -> void:
	if target_camera == null:
		printerr("Camera not found, please add a Camera3D node to %s" % get_path())
		print_stack()
		return

func play() -> void:
	print("Switching camera to %s" % target_camera.get_path())
	target_camera.make_current()
