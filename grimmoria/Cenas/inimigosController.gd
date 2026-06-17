extends Node2D

signal finalizarCombate(condicao: bool)

@onready var destaqueLayer: TileMapLayer = $"../../../DestaqueLayer"

func _ready() -> void:
	# trocar para ele utilizar os inimigos salvos dentro do global
	Globals.inimigos = get_children()

func _physics_process(_delta: float) -> void:
	if Globals.inimigos.size() == 0:
		finalizarCombate.emit(true)

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


func _on_combate_tratar_inimigo(posicaoSelecionada: Vector2i, dano: int, aoe: String) -> void:
	print("Dano Causado: ", dano, " em ", aoe, " na posição ", posicaoSelecionada)
	var posicao
	for inimigo in Globals.inimigos:
		posicao = destaqueLayer.local_to_map(inimigo.position)
		if posicao == posicaoSelecionada:
			match aoe:
				"1x1":
					inimigo.queue_free()
					Globals.inimigos.pop_at(Globals.inimigos.find(inimigo))
				"3x3":
					inimigo.queue_free()
					Globals.inimigos.pop_at(Globals.inimigos.find(inimigo))
