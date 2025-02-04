extends RichTextLabel

@onready var Time_Left = $"../../Time_Left"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Time_Left): text = str(floor(Time_Left.time_left))
	if(Time_Left && Time_Left.time_left <= 0): get_tree().reload_current_scene()  
	
