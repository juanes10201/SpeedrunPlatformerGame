extends Area2D

@export var level_to_change : String = "level2"
@export var current_level : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if(body.is_in_group("Player") && !body.Dead):
		#region Save level
		SaveGame.savelevelrecord(current_level ,$"../Time_Left".wait_time - $"../Time_Left".time_left)
		#endregion
		#region Change level
		var _scene_string : String = "res://assets/Levels/world1/level" + str(current_level+1) + ".tscn"
		print(_scene_string)
		get_tree().change_scene_to_file(_scene_string)
		#endregion
