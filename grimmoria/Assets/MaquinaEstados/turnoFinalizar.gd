extends Estado

func entrar() -> void:
	print("Entrou na finalização de turno")

func processarTurno() -> Estado:
	return proximoEstado
