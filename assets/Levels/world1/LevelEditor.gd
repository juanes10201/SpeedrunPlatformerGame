extends Node2D

@onready var Map = $TileMapLayer 

@export var MapSourceId = 0
@export var AtlasCoord : Vector2i = Vector2i(11, 1)
@export var MapGroundLayer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_click")):
		var MousePos = get_global_mouse_position()
		_SetBlock(MousePos)

func _SetBlock(Pos):
	var LocalPos = Map.local_to_map(Pos)
	print(LocalPos)
	Map.set_cell(MapGroundLayer, LocalPos, MapSourceId, AtlasCoord) 
