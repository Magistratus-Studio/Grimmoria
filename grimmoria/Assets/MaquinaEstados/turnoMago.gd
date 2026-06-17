extends Estado

signal maximizarMana()
signal habilitarMovimentacao()
signal desabilitarMovimentacao()
signal habilitarCarta()
signal desabilitarCarta()

@export var carta_teste: CardResource

func entrar() -> void:
	print("Entrou no turno do mago")
	
	for i in 5:
		pai.comprar_carta()
	
	maximizarMana.emit()
	habilitarMovimentacao.emit()
	habilitarCarta.emit()

func sair() -> void:
	desabilitarMovimentacao.emit()
	desabilitarCarta.emit()

func processarTurno() -> Estado:
	return proximoEstado
