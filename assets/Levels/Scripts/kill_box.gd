extends Area2D

@export var Visible : bool = true
@onready var Sprite = $AnimatedSprite2D

@onready var Player = $"../Player"
@export var Type = Global.KillBoxTypes.Red
@export var CanChange = true

var TweenMove = null

enum Actions{
	none,
	raise_up_on_key
}
@export var AditionalAction = Actions.none

@export var lavaMovDif : float = 10
var posygoto : float = position.y - lavaMovDif
@onready var LavaTimer = $LavaTimer

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
	if(Player && Player.EnabledKillBox == Type && CanChange):
		Sprite.play("default")
		$CollisionShape2D.hide()
		$CollisionShape2D.disabled = false
	elif(CanChange):
		#if(AditionalAction.raise_up_on_key):
		Sprite.play("disabled")
		$CollisionShape2D.disabled = true
	if(AditionalAction == Actions.raise_up_on_key && Player.MoveLava):
		position.y = lerpf(position.y, posygoto, 2 * delta)
		position.y -= lavaMovDif/10
		if(LavaTimer.is_stopped()):
			posygoto = position.y - lavaMovDif
			LavaTimer.start()
		
func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") || body.is_in_group("Enemie")):
		body.On_Death()
		
