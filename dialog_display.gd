extends CutsceneComponent
class_name DialogDisplay

@export var actor_name: String
@export var dialog_text: String

@onready var actor_name_node: Control = $Control/PanelContainer/MarginContainer/VBoxContainer/ActorName
@onready var separator_node: Control = $Control/PanelContainer/MarginContainer/VBoxContainer/HSeparator
@onready var dialog_text_node: Control = $Control/PanelContainer/MarginContainer/VBoxContainer/DialogText

var _is_playing: bool = false
var _current_char: int = 0
var _reveal_timer: float = 0.0
const REVEAL_SPEED: float = 0.05

func _ready() -> void:
	$Control.hide()

	if actor_name == "":
		actor_name_node.hide()
		separator_node.hide()

	if dialog_text == "":
		printerr("dialog_text not set, please set the dialog_text for %s" % get_path())
		print_stack()
		return

func _process(delta: float) -> void:
	if not _is_playing:
		return
		
	if _current_char < dialog_text.length():
		_reveal_timer += delta
		if _reveal_timer >= REVEAL_SPEED:
			_reveal_timer = 0
			_current_char += 1
			dialog_text_node.visible_characters = _current_char
			
		if Input.is_action_just_pressed("ui_accept"):
			_current_char = dialog_text.length()
			dialog_text_node.visible_characters = -1
	elif Input.is_action_just_pressed("ui_accept"):
		_is_playing = false
		$Control.hide()

func play() -> void:
	$Control.show()
	actor_name_node.text = actor_name
	dialog_text_node.text = dialog_text
	dialog_text_node.visible_characters = 0
	
	_is_playing = true
	_current_char = 0
	_reveal_timer = 0.0
	
	# Wait until dialog is complete
	while _is_playing:
		await get_tree().process_frame
