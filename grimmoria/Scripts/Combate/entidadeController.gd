extends Node2D

signal posicionarInimigos(gameMap: TileMapLayer)

@onready var gameMap: TileMapLayer = $".."
@onready var jogador: Sprite2D = $Jogador

func _ready() -> void:
	jogador.position = gameMap.map_to_local(Globals.SPAWNPLAYER)
	posicionarInimigos.emit(gameMap)
