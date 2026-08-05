extends Control

@export var roda: TextureRect
@export var texto_emocao: Label

var angulo_setor_graus = 60.0
var total_setores = 6

# Variáveis de Controle
var arrastando: bool = false
var angulo_anterior: float = 0.0
var tween_alinhamento: Tween # Guardamos o Tween para poder cancelá-lo se necessário


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastando = true
			# Se a roda estava no meio de um "encaixe" e o jogador clicou, paramos a animação
			if tween_alinhamento and tween_alinhamento.is_running():
				tween_alinhamento.kill()
				
			angulo_anterior = _calcular_angulo_mouse()
		else:
			arrastando = false
			_alinhar_roleta()

	elif event is InputEventMouseMotion and arrastando:
		var angulo_atual = _calcular_angulo_mouse()
		var delta_angulo = wrapf(angulo_atual - angulo_anterior, -PI, PI)
		
		roda.rotation += delta_angulo
		angulo_anterior = angulo_atual
		var rotacao_graus = rad_to_deg(roda.rotation)
		var indice_setor = round(rotacao_graus / angulo_setor_graus)
		_calcular_resultado_parcial(int(indice_setor))


func _calcular_angulo_mouse() -> float:
	var centro_roda = roda.position + roda.pivot_offset
	return (get_local_mouse_position() - centro_roda).angle()

func _alinhar_roleta():
	var rotacao_graus = rad_to_deg(roda.rotation)
	var indice_setor = round(rotacao_graus / angulo_setor_graus)
	var alvo_graus = indice_setor * angulo_setor_graus
	
	# Criamos a animação de encaixe (SNAP)
	tween_alinhamento = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# 0.3 segundos é um bom tempo para um snap rápido e responsivo
	tween_alinhamento.tween_property(roda, "rotation", deg_to_rad(alvo_graus), 0.3)
	
	tween_alinhamento.finished.connect(func(): _calcular_resultado(int(indice_setor)))

func _calcular_resultado(indice_setor: int):
	var indice_selecionado = posmod(-indice_setor, total_setores)
	match indice_selecionado:
		Globals.INDC_TRISTEZA:
			texto_emocao.text = "Tristeza"
		Globals.INDC_ALEGRIA:
			texto_emocao.text = "Alegria"
		Globals.INDC_AMOR:
			texto_emocao.text = "Amor"
		Globals.INDC_MEDO:
			texto_emocao.text = "Medo"
		Globals.INDC_RAIVA:
			texto_emocao.text = "Raiva"
		Globals.INDC_SURPRESA:
			texto_emocao.text = "Surpresa"
	
	Globals.ultimo_indice_sorteado = indice_selecionado

func _calcular_resultado_parcial(indice_setor: int):
	var indice_selecionado = posmod(-indice_setor, total_setores)
	match indice_selecionado:
		Globals.INDC_TRISTEZA:
			texto_emocao.text = "Tristeza"
		Globals.INDC_ALEGRIA:
			texto_emocao.text = "Alegria"
		Globals.INDC_AMOR:
			texto_emocao.text = "Amor"
		Globals.INDC_MEDO:
			texto_emocao.text = "Medo"
		Globals.INDC_RAIVA:
			texto_emocao.text = "Raiva"
		Globals.INDC_SURPRESA:
			texto_emocao.text = "Surpresa"
