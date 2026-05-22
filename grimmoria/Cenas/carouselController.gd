extends Control

@export var espacamento: float = 200.0
@export var duracao_animacao: float = 0.3
@export var escala_foco: float = 1.3
@export var escala_normal: float = 0.8
@export var limite_arraste: float = 50.0

var itens: Array = []
var indice_atual: int = 0

var tocando: bool = false
var posicao_inicial_x: float = 0.0

func _ready():
	for child in get_children():
		if child is VBoxContainer:
			itens.append(child)
			
	# call_deferred garante que a UI inteira exista antes de tentar organizar
	call_deferred("atualizar_carrossel", false)

func _input(event):
	if event.is_action_pressed("ui_right"): mover_carrossel(1)
	elif event.is_action_pressed("ui_left"): mover_carrossel(-1)
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			tocando = true
			posicao_inicial_x = event.position.x
		else:
			if tocando:
				_verificar_arraste(event.position.x)
			tocando = false

	elif event is InputEventScreenTouch:
		if event.pressed:
			tocando = true
			posicao_inicial_x = event.position.x
		else:
			if tocando:
				_verificar_arraste(event.position.x)
			tocando = false

func _verificar_arraste(posicao_final_x: float):
	var distancia = posicao_inicial_x - posicao_final_x 
	if distancia > limite_arraste:
		mover_carrossel(1)
	elif distancia < -limite_arraste:
		mover_carrossel(-1)

func mover_carrossel(direcao: int):
	indice_atual = (indice_atual + direcao) % itens.size()
	if indice_atual < 0:
		indice_atual += itens.size()
		
	atualizar_carrossel(true)

func atualizar_carrossel(animado: bool):
	var centro_x = size.x / 2.0
	var centro_y = size.y / 2.0
	
	# Define o tempo: duração normal se animado, 0.0 se for o ajuste inicial
	var tempo = duracao_animacao if animado else 0.0
	
	# Agora criamos o Tween em TODAS as execuções
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	for i in range(itens.size()):
		var item = itens[i]
		var botao = item.get_node("TextureButton") 
		
		var distancia_index = i - indice_atual
		
		var metade_tamanho = itens.size() / 2
		if distancia_index > metade_tamanho:
			distancia_index -= itens.size()
		elif distancia_index < -metade_tamanho:
			distancia_index += itens.size()

		var posicao_alvo = Vector2(centro_x + (distancia_index * espacamento) - (item.size.x / 2.0), centro_y - (item.size.y / 2.0))
		var escala_alvo = Vector2(escala_foco, escala_foco) if distancia_index == 0 else Vector2(escala_normal, escala_normal)

		# Aplicamos tudo via Tween, usando a variável 'tempo'
		tween.tween_property(item, "position", posicao_alvo, tempo)
		
		var alpha_alvo = 1.0 if distancia_index == 0 else 0.5
		tween.tween_property(item, "modulate:a", alpha_alvo, tempo)
		
		if botao:
			# Atualiza o pivô dinamicamente para garantir que cresça do centro
			botao.pivot_offset = botao.size / 2.0 
			tween.tween_property(botao, "scale", escala_alvo, tempo)
