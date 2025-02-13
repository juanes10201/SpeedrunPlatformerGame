extends Area2D

@export var Visible : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!Visible): self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") || body.is_in_group("Enemie")):
		body.On_Death()
