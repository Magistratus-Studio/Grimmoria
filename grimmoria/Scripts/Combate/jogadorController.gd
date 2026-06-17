extends Sprite2D

@onready var gameMap: TileMapLayer = $"../.."
@onready var destaqueLayer: TileMapLayer = $"../../../DestaqueLayer"

var podeMover: bool = false
var vizinhos: Array[Vector2i]

func _input(event: InputEvent) -> void:
	if podeMover:
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and not event.double_click:
			var mousePos: Vector2 = event.position
			var mousePosMapa: Vector2i = gameMap.local_to_map(gameMap.to_local(mousePos))
			if mousePosMapa in vizinhos and gameMap.get_cell_tile_data(mousePosMapa):
				self.position = gameMap.map_to_local(mousePosMapa)
				podeMover = not podeMover
				limparMovimento()


func destacarMovimento() -> void:
	for vizinho in vizinhos:
		var data = gameMap.get_cell_tile_data(vizinho)
		if data:
			destaqueLayer.set_cell(vizinho, 0, Vector2i(0,0))

func limparMovimento() -> void:
	for vizinho in vizinhos:
		var data = gameMap.get_cell_tile_data(vizinho)
		if data:
			destaqueLayer.set_cell(vizinho, -1, Vector2i(-1,-1))


func _on_turno_mago_habilitar_movimentacao() -> void:
	podeMover = true
	vizinhos = gameMap.get_surrounding_cells(gameMap.local_to_map(self.position))
	destacarMovimento()

func _on_turno_mago_desabilitar_movimentacao() -> void:
	podeMover = false
	limparMovimento()
