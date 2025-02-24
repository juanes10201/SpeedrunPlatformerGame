extends Button

@export var BUTTON_ACTION = Global.BUTTON_ACTIONS.none
@export var ADITIONAL_ARGUMENT : String = ""

@export var HoverDif = 30
@export var PressedDif = -20

@onready var original_size = self.size
@onready var ControlNode = $"../../pause_menu"
@onready var SelectedSprite = $SelectedSprite
@onready var Player = $"../../../../Player"

var PressedAnim : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#region Button anims
	if(!PressedAnim):
		var Mouse_pos = get_global_mouse_position()
		if(Mouse_pos.x >= self.position.x && Mouse_pos.x <= self.position.x + self.size.x && Mouse_pos.y >= self.position.y && Mouse_pos.y <= self.position.y + self.size.y+20):
			#region On pressed
			if(Input.is_action_pressed("ui_click")): 
				self.size.x = lerpf(self.size.x, original_size.x+PressedDif, 5*delta)
				self.size.y = lerpf(self.size.y, original_size.y+PressedDif, 5*delta)
			#endregion
			#region Hover
			else:
				self.size.x = lerpf(self.size.x, original_size.x+HoverDif, 5*delta)
				self.size.y = lerpf(self.size.y, original_size.y+HoverDif, 5*delta)
			#endregion
		#region Return to normal state
		elif(self.size != original_size):
			self.size.x = lerpf(self.size.x, original_size.x, 10*delta)
			self.size.y = lerpf(self.size.y, original_size.y, 10*delta)
		#endregion
	#endregion


func _on_pressed() -> void:
	if(BUTTON_ACTION == Global.BUTTON_ACTIONS.resume_game && Player):
		Player._pause_game()
	elif(BUTTON_ACTION == Global.BUTTON_ACTIONS.restart_level):
		Player.TransitionOut.show()
		Player.TransitionOut.fade_out()
		await(get_tree().create_timer(Player.TimeDeath).timeout)
		if get_tree(): get_tree().reload_current_scene()
	elif(BUTTON_ACTION == Global.BUTTON_ACTIONS.config_menu):
		print("TO-DO: Lazy developer didn't implement config menu...")
	elif(BUTTON_ACTION == Global.BUTTON_ACTIONS.move_to_scene):
		var _scene_string : String = "res://assets/Levels/world1/" + ADITIONAL_ARGUMENT + ".tscn"
		get_tree().change_scene_to_file(_scene_string)
		
