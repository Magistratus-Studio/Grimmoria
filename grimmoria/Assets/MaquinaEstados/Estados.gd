extends Node
class_name Estado

var pai : Node2D
@export var proximoEstado: Estado

func entrar() -> void:
	pass

func sair() -> void:
	pass

func processarTurno() -> Estado:
	return null
