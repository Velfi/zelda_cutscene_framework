extends CutsceneComponent

@export var wait_time: float = 3.0

func play() -> void:
	print("Waiting for %s seconds" % wait_time)
	await get_tree().create_timer(wait_time).timeout
	print("Finished waiting")
