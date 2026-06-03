extends Node2D

@onready var tileMap: TileMapLayer = $".."
@onready var destaqueLayer: TileMapLayer = $"../../DestaqueLayer"
@onready var jogador: Sprite2D = $Jogador
@onready var inimigo: Sprite2D = $Inimigo
@onready var condicaoMovimento: bool = true

# GRID
# canto superior esquerdo: (-3,-3)
# centro                 : (-1,0)
# canto inferior direito : (1,3)
const CENTER: Vector2i = Vector2i(-1,0)
const SPAWNPLAYER: Vector2i = Vector2i(-1,3)
const SPAWNINIMIGO: Vector2i = Vector2i(-1,-3)

var vizinhos: Array[Vector2i]

func _ready() -> void:
	# await get_tree().process_frame
	jogador.position = tileMap.map_to_local(SPAWNPLAYER)
	inimigo.position = tileMap.map_to_local(SPAWNINIMIGO)


#func _physics_process(delta: float) -> void:
	#pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and not event.double_click:
		var mousePos: Vector2 = event.position
		print(tileMap.position)
		print("local: ", tileMap.to_local(mousePos))
		print("global: ", tileMap.to_global(mousePos))
		print("mouse pos: ", mousePos)


func _on_turno_button_pressed() -> void:
	condicaoMovimento = not condicaoMovimento

func destacarMovimento():
	if condicaoMovimento:
		vizinhos = tileMap.get_surrounding_cells(tileMap.local_to_map(jogador.position))
		for vizinho in vizinhos:
			var data = tileMap.get_cell_tile_data(vizinho)
			if data:
				destaqueLayer.set_cell(vizinho, 1, Vector2i(0,0))
	else:
		vizinhos = tileMap.get_surrounding_cells(tileMap.local_to_map(jogador.position))
		for vizinho in vizinhos:
			var data = tileMap.get_cell_tile_data(vizinho)
			if data:
				destaqueLayer.set_cell(vizinho, -1, Vector2i(-1,-1))
