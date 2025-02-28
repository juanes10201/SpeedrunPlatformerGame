extends Sprite2D

@onready var Player = $"../../Player"
@onready var PosGoto = Player.position
@onready var DeathTimer = $DeathTimer
var tween = null
var CanDie : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", PosGoto, 1.0)
	CanDie = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(CanDie):
		position.y += 30*delta
		if(DeathTimer.is_stopped()):
			Destroy()
	if(!tween.is_running() && DeathTimer.is_stopped()):
		DeathTimer.start()
		CanDie = true
		print("a")

func Destroy() -> void:
	#region Create destroy particles
	var DestroyParticles = preload("res://assets/Levels/Particles/destroy_bullet.tscn")
	var InstanceParticles = DestroyParticles.instantiate()
	get_tree().current_scene.add_child(InstanceParticles)
	InstanceParticles.position = self.position
	#endregion
	queue_free()

func _on_player_jump_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Player.DoJump()
		Destroy()


func _on_player_death_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Player.On_Death()
		Destroy()
