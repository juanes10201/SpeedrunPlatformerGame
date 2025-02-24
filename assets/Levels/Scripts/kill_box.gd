extends Area2D

@export var Visible : bool = true
@onready var Sprite = $AnimatedSprite2D

@onready var Player = $"../Player"
@export var Type = Global.KillBoxTypes.Red

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!Visible): self.hide()
	
	var shader = load("res://assets/Levels/Shader/kill_box.gdshader")
	
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	Sprite.material = shader_material
	
	Sprite.material.set_shader_parameter("tile_size", scale)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#If current killbox
	if(Player && Player.EnabledKillBox == Type):
		Sprite.play("default")
		$CollisionShape2D.hide()
		$CollisionShape2D.disabled = false
	else:
		Sprite.play("disabled")
		$CollisionShape2D.disabled = true

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") || body.is_in_group("Enemie")):
		body.On_Death()
		
