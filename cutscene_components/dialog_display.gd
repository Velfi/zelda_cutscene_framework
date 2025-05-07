extends CutsceneComponent
class_name DialogDisplay

@export var dialogue_resource: Resource
@export var start_title: String = "start"

@onready var actor_name_node: Control = $Control/PanelContainer/MarginContainer/VBoxContainer/ActorName
@onready var separator_node: Control = $Control/PanelContainer/MarginContainer/VBoxContainer/HSeparator
@onready var dialog_text_node: Control = $Control/PanelContainer/MarginContainer/VBoxContainer/DialogText
@onready var responses_node: Control = $Control/PanelContainer/MarginContainer/VBoxContainer/Responses
var reveal_timer: Timer

var _is_playing: bool = false
var _is_waiting_for_input: bool = false
var _current_char: int = 0
const REVEAL_SPEED: float = 0.05

func _ready() -> void:
	$Control.hide()
	for child in responses_node.get_children():
		child.queue_free()
	responses_node.hide()

	if not dialogue_resource:
		printerr("dialogue_resource not set, please set the dialogue_resource for %s" % get_path())
		print_stack()
		return
		
	# Create timer if it doesn't exist
	if not has_node("RevealTimer"):
		reveal_timer = Timer.new()
		reveal_timer.name = "RevealTimer"
		add_child(reveal_timer)
	else:
		reveal_timer = $RevealTimer
		
	reveal_timer.wait_time = REVEAL_SPEED
	reveal_timer.timeout.connect(_on_reveal_timer_timeout)

func _process(_delta: float) -> void:
	if not _is_playing:
		return
		
	if _current_char < dialog_text_node.text.length():
		if Input.is_action_just_pressed("ui_accept"):
			_current_char = dialog_text_node.text.length()
			dialog_text_node.visible_characters = -1
			reveal_timer.stop()
			_is_waiting_for_input = true
	elif Input.is_action_just_pressed("ui_accept") and _is_waiting_for_input:
		_is_playing = false
		_is_waiting_for_input = false
		reveal_timer.stop()

func _on_reveal_timer_timeout() -> void:
	if _current_char < dialog_text_node.text.length():
		_current_char += 1
		dialog_text_node.visible_characters = _current_char
	else:
		reveal_timer.stop()
		_is_waiting_for_input = true

func _show_dialogue_line(dialogue_line: DialogueLine) -> void:
	actor_name_node.text = dialogue_line.character
	dialog_text_node.text = dialogue_line.text
	dialog_text_node.visible_characters = 0
	
	print("[Dialog] %s: %s" % [dialogue_line.character, dialogue_line.text])
	
	_is_playing = true
	_is_waiting_for_input = false
	_current_char = 0
	reveal_timer.start()
	
	# Wait until dialog is complete and user presses accept
	while _is_playing:
		await get_tree().process_frame

func _show_responses(responses: Array) -> String:
	responses_node.show()
	var selected = {"next_id": ""}
	
	# Create all response buttons first
	for response in responses:
		var button = Button.new()
		button.text = response.text
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		responses_node.add_child(button)
		
		# Connect the button press signal
		button.pressed.connect(func():
			selected.next_id = response.next_id
			responses_node.hide()
			for child in responses_node.get_children():
				child.queue_free()
		)
	
	# Wait for any response to be selected
	while responses_node.visible:
		await get_tree().process_frame
		
	return selected.next_id

func play() -> void:
	$Control.show()
	
	var dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue_resource, start_title)
	while dialogue_line != null:
		await _show_dialogue_line(dialogue_line)
		
		if dialogue_line.responses.size() > 0:
			var next_id = await _show_responses(dialogue_line.responses)
			dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue_resource, next_id)
		else:
			dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue_resource, dialogue_line.next_id)
			
	$Control.hide()
