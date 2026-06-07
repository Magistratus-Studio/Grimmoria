extends Node

@export var estadoInicial: Estado
var estadoAtual: Estado

func init(pai: Node2D) -> void:
	for filho in get_children():
		filho.pai = pai
	
	mudarEstado(estadoInicial)

func mudarEstado(novoEstado: Estado) -> void:
	if estadoAtual:
		estadoAtual.sair()
	
	estadoAtual = novoEstado
	estadoAtual.entrar()

func processarTurno() -> void:
	var novoEstado = estadoAtual.processarTurno()
	if novoEstado:
		mudarEstado(novoEstado)
