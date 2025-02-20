extends AnimatedSprite2D
@onready var NextTimer = $"../Timer"
@export var level_to_change = "level1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play()
	#Set fullscreen when on browser
	if(OS.get_name() == "Web"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(NextTimer.is_stopped()):
		var _scene_string : String = "res://assets/Levels/world1/" + level_to_change + ".tscn"
		get_tree().change_scene_to_file(_scene_string)
