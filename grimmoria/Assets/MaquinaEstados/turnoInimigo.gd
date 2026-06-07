extends Estado

func entrar() -> void:
	print("Entrou no turno do inimigo")

func processarTurno() -> Estado:
	return proximoEstado
