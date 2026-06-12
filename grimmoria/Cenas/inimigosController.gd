extends Node2D

@onready var destaqueLayer: TileMapLayer = $"../../../DestaqueLayer"

func _ready() -> void:
	Globals.inimigos = get_children()

func _on_entidades_posicionar_inimigos(tileMap) -> void:
	var ocupados: Array[Vector2i]
	var randomSpawn: Vector2i = Vector2i(randi_range(-3, 1), randi_range(-3, -1))
	for inimigo in Globals.inimigos:
		while randomSpawn in ocupados:
			randomSpawn = Vector2i(randi_range(-3, 1), randi_range(-3, -1))
		ocupados.append(randomSpawn)
		inimigo.position = tileMap.map_to_local(randomSpawn)


func _on_combate_destacar_inimigos(aoe: String) -> void:
	var posicao: Vector2i
	for inimigo in Globals.inimigos:
		posicao = destaqueLayer.local_to_map(inimigo.position)
		destaqueLayer.set_cell(posicao, 0, Vector2i(0,0))


func _on_combate_limpar_destaque_inimigos() -> void:
	var posicao
	for inimigo in Globals.inimigos:
		posicao = destaqueLayer.local_to_map(inimigo.position)
		destaqueLayer.set_cell(posicao, -1, Vector2i(-1,-1))
