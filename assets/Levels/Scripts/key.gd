extends Area2D

@onready var Player = $"../Player"
@export var AditionalAction : Global.OBJECT_ACTIONS = Global.OBJECT_ACTIONS.none

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if(Player):
		Player.HaveKey = true
		Player._play_sound(Player.AudioSwitch, false)
		if(AditionalAction == Global.OBJECT_ACTIONS.switch_killbox_type):
			if(Player.EnabledKillBox == Global.KillBoxTypes.Red):
				Player.EnabledKillBox = Global.KillBoxTypes.Blue
			else:
				Player.EnabledKillBox = Global.KillBoxTypes.Red
		elif(AditionalAction == Global.OBJECT_ACTIONS.MoveLava):
			Player.MoveLava = true
		else:
			Player._play_sound(Player.AudioKey, false)
		self.queue_free()
