extends Estado

signal maximizarMana()
signal habilitarMovimentacao()
signal desabilitarMovimentacao()
signal habilitarCarta()
signal desabilitarCarta()

@export var carta_teste: CardResource

# comprar 5 cartas
# mana no máximo
func entrar() -> void:
	print("Entrou no turno do mago")
	
	for i in 5:
		# falta comprar do baralho de compra
		pai.comprar_carta(carta_teste)
	
	maximizarMana.emit()
	habilitarMovimentacao.emit()
	habilitarCarta.emit()

func sair() -> void:
	desabilitarMovimentacao.emit()
	desabilitarCarta.emit()

func processarTurno() -> Estado:
	return proximoEstado
