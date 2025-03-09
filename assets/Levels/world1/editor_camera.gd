extends Camera2D

@export var EditorMoveSpeed : float = 200
@export var EditorDragSpeed : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_pressed("ui_up")):
		position.y -= EditorMoveSpeed * delta
	elif(Input.is_action_pressed("ui_down")):
		position.y += EditorMoveSpeed * delta
	if(Input.is_action_pressed("ui_right")):
		position.x += EditorMoveSpeed * delta
	if(Input.is_action_pressed("ui_left")):
		position.x -= EditorMoveSpeed * delta
