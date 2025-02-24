extends RichTextLabel

@onready var Time_Left = $"../../Time_Left"
@onready var original_size = get_theme_font_size("normal_font_size")
@onready var Font_Size = get_theme_font_size("normal_font_size")

@export var change_size_multiplier : float = 1.2

@onready var previous_time = Time_Left
@onready var RaySprite = $"../Ray-time"

@onready var CurrentSecond = str(floor(Time_Left.time_left)) if Time_Left else 0
var TimeRest = 0

var DangerTime : bool = false
@export var DangerTimeStartTimer : float = 3
@export var Danger_change_size_multiplier : float = 1.5

#region Shake
var rng = RandomNumberGenerator.new()
@onready var OriginalPosition = self.position
var offset = Vector2(0, 0)

var ShakeRangeStrenght : float = 30.0
var ShakeFade : float = 5.0
var ShakeStrenght : float = 0.0

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

func ProcessPosition() -> void:
	self.position = OriginalPosition+offset
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TickShake(delta)
	#region Counter juice
	if(Time_Left):
		CurrentSecond = floor(Time_Left.time_left)
		TimeRest = floor((Time_Left.time_left - CurrentSecond)*100)
		self.text = str(CurrentSecond)+"[font_size={30}]"+str(TimeRest)+"[/font_size]"
		#region Trigger death when timer runs out
		if(Time_Left.time_left <= 0): get_node("../../Player").On_Death()
		#endregion
		
		#region Change size juice
		if(str(CurrentSecond) != str(previous_time) ):
			if(Time_Left.time_left <= 5): self.Shake(10, 10)
			else: self.Shake(1, 1)
			previous_time = CurrentSecond
			add_theme_font_size_override("normal_font_size", 10)
			Font_Size = original_size * change_size_multiplier if !DangerTime else original_size * Danger_change_size_multiplier
			if(RaySprite): RaySprite.position.y += 3
		#endregion
		
		#region Change color when in counter minor to 3
		#Final countdown change text color
		if(Time_Left.time_left < DangerTimeStartTimer):
			if(DangerTime == false):
				DangerTime = true
				set("theme_override_colors/default_color", Color("fff2f7ff"))
				set("theme_override_colors/font_shadow_color", Color("ff2e6dc6"))
			self.Shake(1.5, 1.5)
		#endregion
	Font_Size = lerpf(Font_Size, original_size, 5  * delta)
	
	#Apply font change
	if(get_theme_font_size("normal_font_size") != Font_Size): add_theme_font_size_override("normal_font_size", Font_Size)
	#endregion
	
	ProcessPosition()
	
