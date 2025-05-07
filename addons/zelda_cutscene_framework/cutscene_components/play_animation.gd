extends CutsceneComponent
class_name PlayAnimation

@export var animation_player: AnimationPlayer
@export var animation_name: String
@export var wait_until_finished: bool = false


func _ready() -> void:
    if animation_player == null:
        printerr("Animation player not found")
        print_stack()


func play() -> void:
    animation_player.play(animation_name)
    if wait_until_finished:
        ## wait for timer to finish
        await get_tree().create_timer(animation_player.get_animation(animation_name).length).timeout
