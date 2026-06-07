extends Node2D

@onready var tileMap: TileMapLayer = $".."
@onready var jogador: Sprite2D = $Jogador
@onready var inimigo: Sprite2D = $Inimigo

func _ready() -> void:
	jogador.position = tileMap.map_to_local(Globals.SPAWNPLAYER)
	inimigo.position = tileMap.map_to_local(Globals.SPAWNINIMIGO)
