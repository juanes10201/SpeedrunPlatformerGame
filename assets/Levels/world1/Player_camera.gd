extends Camera2D

var ShakeRangeStrenght : float = 30.0
var ShakeFade : float = 5.0
var ShakeStrenght : float = 0.0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TickShake(delta)

#region Camera Shake
func Shake(_shakerangestrenght, _shakefade) -> void:
	ShakeRangeStrenght = _shakerangestrenght
	ShakeFade = _shakefade
	ShakeStrenght = ShakeRangeStrenght

func TickShake(delta) -> void:
	if(ShakeStrenght > 0):
		ShakeStrenght = lerpf(ShakeStrenght, 0, ShakeFade * delta)
		offset = ApplyShake()
func ApplyShake() -> Vector2:
	return Vector2(rng.randf_range(-ShakeStrenght, ShakeStrenght), rng.randf_range(-ShakeStrenght, ShakeStrenght))
#endregion
