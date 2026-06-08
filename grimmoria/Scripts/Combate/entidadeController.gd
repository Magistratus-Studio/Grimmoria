extends Node2D

signal posicionarInimigos(tileMap: TileMapLayer)

@onready var tileMap: TileMapLayer = $".."
@onready var jogador: Sprite2D = $Jogador

func _ready() -> void:
	jogador.position = tileMap.map_to_local(Globals.SPAWNPLAYER)
	posicionarInimigos.emit(tileMap)
	#inimigo.position = tileMap.map_to_local(Globals.SPAWNINIMIGO)
