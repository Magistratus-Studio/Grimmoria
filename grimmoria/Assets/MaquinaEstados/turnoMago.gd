extends Estado

func entrar() -> void:
	print("Entrou no turno do mago")

func processarTurno() -> Estado:
	return proximoEstado
