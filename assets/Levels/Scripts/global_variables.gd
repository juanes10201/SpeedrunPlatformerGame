extends Node
class_name Global

enum KillBoxTypes{
	Red,
	Blue
}
enum BUTTON_ACTIONS{
	none,
	resume_game,
	restart_level,
	config_menu,
	move_to_scene
}
enum OBJECT_ACTIONS{
	none,
	switch_killbox_type
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
