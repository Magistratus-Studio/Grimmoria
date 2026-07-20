extends Node2D

signal cartaUsada(mp: int)
signal destacarInimigos(aoe: String)
signal limparDestaqueInimigos
signal inimigoSelecionado(posicao: Vector2i)
signal tratarInimigo(posicaoSelecionada: Vector2i, dano: int, aoe: String)

@onready var maquinaEstados: Node = $TurnManager

@onready var botaoTurno: Button = $CanvasLayer/TurnoButton

@onready var gameMap: TileMapLayer = $GameLayer
@onready var destaqueMap: TileMapLayer = $DestaqueLayer
@onready var destaqueInimigoMap: TileMapLayer = $DestaqueLayerInimigo
@onready var fundoMap: TileMapLayer = $FundoLayer

# Referências dos nós do Modal
@onready var modal_descricao: PanelContainer = $CanvasLayer/ModalDescricao
@onready var modal_nome: Label = $CanvasLayer/ModalDescricao/VBoxContainer/TextoNome
@onready var modal_descricao_texto: Label = $CanvasLayer/ModalDescricao/VBoxContainer/TextoDescricao

@onready var mao_jogador: HBoxContainer = $CanvasLayer/MaoJogador
var cena_carta = preload("res://Assets/Cartas/carta.tscn")

# Guarda temporariamente qual carta está aberta no modal
var carta_selecionada_dados: CardResource = null

# NOVA VARIÁVEL: Guarda a referência do NÓ visual da carta que está aberta no modal
var carta_selecionada_no: TextureButton = null

# NOVO: Lista que servirá como a sua pilha de descarte futuramente
var pilha_de_descarte: Array[CardResource] = []
var pilhaDeCompra: Array[CardResource]

var podeAtacar: bool = false

func _ready() -> void:
	Globals.definir_orientacao(Globals.PAISAGEM)
	modal_descricao.visible = false
	
	var centro_monitor = get_window().size / 2
	var deslocamentoVertical = Vector2i(0, int(centro_monitor[1] * 0.3))
	gameMap.position = centro_monitor - deslocamentoVertical
	destaqueMap.position = centro_monitor - deslocamentoVertical
	destaqueInimigoMap.position = centro_monitor - deslocamentoVertical
	fundoMap.position = centro_monitor - deslocamentoVertical
	
	Globals.gerar_baralho_teste()
	
	_inicializar_combate()

func _input(event: InputEvent) -> void:
	if podeAtacar:
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and not event.double_click:
			var mousePos: Vector2 = event.position
			var mousePosMapa: Vector2i = gameMap.local_to_map(gameMap.to_local(mousePos))
			for inimigo in Globals.inimigos:
				if mousePosMapa == gameMap.local_to_map(inimigo.position) and gameMap.get_cell_tile_data(mousePosMapa):
					podeAtacar = false
					inimigoSelecionado.emit(gameMap.local_to_map(inimigo.position))

func _inicializar_combate() -> void:
	print("Combate Iniciado em Modo Paisagem!")
	pilhaDeCompra = Globals.baralho.duplicate_deep(Resource.DEEP_DUPLICATE_NONE)
	pilhaDeCompra.shuffle()
	maquinaEstados.init(self)

func _on_combate_terminou(vitoria: bool) -> void:
	if vitoria:
		print("Jogador venceu!")
	else:
		print("Jogador perdeu!")
	
	Globals.definir_orientacao(Globals.RETRATO)
	get_tree().change_scene_to_file("res://Cenas/menu_inicial.tscn")

func _on_turno_button_pressed() -> void:
	maquinaEstados.processarTurno()

func comprar_carta() -> void:
	# COLOCAR DEPOIS: não permitir ações que possam aumentar o tamanho da mão quando estiver cheia
	if mao_jogador.get_children().size() == 5:
		print("Mão em cheia")
		return
	
	var dados_da_carta: CardResource = pilhaDeCompra.pop_back()
	$CanvasLayer/StatusTopo/Label2.text = "Cartas na pilha de compra: " + str(pilhaDeCompra.size())
	
	if !dados_da_carta:
		print("Mão vazia")
		return
	
	var nova_carta = cena_carta.instantiate()
	nova_carta.dados = dados_da_carta
	mao_jogador.add_child(nova_carta)
	
	# O sinal na sua carta precisa passar ela mesma como argumento. 
	# Para não precisar mudar o script da carta, podemos passar o nó usando um "bind" no connect:
	nova_carta.carta_tocada.connect(_on_carta_selecionada.bind(nova_carta))

# Modificado para receber também o nó visual da carta
func _on_carta_selecionada(dados_da_carta: CardResource, no_da_carta: TextureButton) -> void:
	carta_selecionada_dados = dados_da_carta
	carta_selecionada_no = no_da_carta
	
	# Preenche o Modal
	modal_nome.text = dados_da_carta.nome
	modal_descricao_texto.text = dados_da_carta.descricao_efeito
	
	# --- NOVO: POSICIONAMENTO DINÂMICO AO LADO DA CARTA ---
	# Pega a posição global exata de onde a carta está renderizada na tela do celular
	var pos_carta = no_da_carta.global_position
	
	# Calcula a posição do modal: 
	# X = Lado direito da carta (posição X da carta + a largura dela + um pequeno espaço de 10 pixels)
	# Y = Alinhado com o topo da carta, mas subindo um pouco para o modal subir se a carta for baixa
	var nova_posicao_modal = Vector2(
		pos_carta.x + no_da_carta.size.x + 10,
		pos_carta.y - (modal_descricao.size.y / 2.0) + (no_da_carta.size.y / 2.0)
	)
	
	# SEGURANÇA PARA MOBILE: Se o modal for sair da tela pela direita, joga ele para o lado ESQUERDO da carta
	var limite_direita_tela = get_viewport_rect().size.x
	if nova_posicao_modal.x + modal_descricao.size.x > limite_direita_tela:
		nova_posicao_modal.x = pos_carta.x - modal_descricao.size.x - 10
		
	# Impede que o modal saia pelo topo ou pelo fundo da tela
	nova_posicao_modal.y = clamp(nova_posicao_modal.y, 10, get_viewport_rect().size.y - modal_descricao.size.y - 10)
	
	# Aplica a posição calculada
	modal_descricao.global_position = nova_posicao_modal
	modal_descricao.visible = true
	if Globals.mp >= carta_selecionada_dados.custo_ap:
		$CanvasLayer/ModalDescricao/VBoxContainer/HBoxContainer/BotaoJogar.text = "Usar Carta" 
		$CanvasLayer/ModalDescricao/VBoxContainer/HBoxContainer/BotaoJogar.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		$CanvasLayer/ModalDescricao/VBoxContainer/HBoxContainer/BotaoJogar.text = "Mana Insuficiente" 
		$CanvasLayer/ModalDescricao/VBoxContainer/HBoxContainer/BotaoJogar.process_mode = Node.PROCESS_MODE_DISABLED

func fecharModal() -> void:
	modal_descricao.visible = false
	carta_selecionada_dados = null
	carta_selecionada_no = null
	#limparDestaqueInimigos.emit()

func _on_botao_fechar_modal_pressed() -> void:
	fecharModal()

func _on_botao_jogar_modal_pressed() -> void:
	if carta_selecionada_dados and carta_selecionada_no:
		
		# 1. LÓGICA DO JOGO: (Exemplo) APLICAR DANOS / MANA AQUI...
		# Seu código de redução de AP e dano vai aqui usando carta_selecionada_dados
		#botaoTurno.visible = false
		botaoTurno.process_mode = Node.PROCESS_MODE_DISABLED
		mao_jogador.process_mode = Node.PROCESS_MODE_DISABLED
		
		if Globals.mp >= carta_selecionada_dados.custo_ap:
			# Fazer depois a verficação com base se o feitiço é no inimigo ou no campo
			# no momoento está apenas no inimigo
			print("Executando o efeito da carta: ", carta_selecionada_dados.nome)
			cartaUsada.emit(carta_selecionada_dados.custo_ap)
			match carta_selecionada_dados.tipo:
				"Ataque":
					destacarInimigos.emit(carta_selecionada_dados.aoe)
					executarAtaque(carta_selecionada_dados.valor_dano, carta_selecionada_dados.aoe)
				"Defesa":
					print("Magia de defesa")
				"Especial":
					print("Magia especial")
		else: 
			print("Mana insuficiente")
			fecharModal()
			botaoTurno.process_mode = Node.PROCESS_MODE_INHERIT
			mao_jogador.process_mode = Node.PROCESS_MODE_INHERIT
			return
		
		# 2. ADICIONAR À PILHA DE DESCARTE:
		# Guarda os dados lógicos da carta na nossa lista de descarte antes de sumir com ela
		pilha_de_descarte.append(carta_selecionada_dados)
		print("Carta adicionada ao descarte. Total no descarte: ", pilha_de_descarte.size())
		
		# 3. REMOVER VISUALMENTE DA MÃO:
		# Deleta o nó do botão da árvore. O HBoxContainer vai reorganizar as cartas restantes na hora!
		carta_selecionada_no.queue_free()
		
		# Limpa as referências e fecha o modal
		fecharModal()


func executarAtaque(dano: int, aoe: String) -> void:
	print("Magia de ataque")
	podeAtacar = true
	var posicaoSelecionada = await inimigoSelecionado
	var posicaoInimigo: Vector2i
	botaoTurno.process_mode = Node.PROCESS_MODE_INHERIT
	mao_jogador.process_mode = Node.PROCESS_MODE_INHERIT
	print("Dano Causado: ", dano, " em ", aoe, " na posição ", posicaoSelecionada)
	limparDestaqueInimigos.emit()
	match aoe:
		"1x1":
			tratarInimigo.emit(posicaoSelecionada, dano)
		"3x3":
			for pos in Globals.GRID3X3:
					posicaoInimigo = posicaoSelecionada + pos
					tratarInimigo.emit(posicaoInimigo, dano)
		"Cruz":
			for pos in Globals.GRIDCRUZ:
					posicaoInimigo = posicaoSelecionada + pos
					tratarInimigo.emit(posicaoInimigo, dano)
		"Diagonais":
			for pos in Globals.GRIDDIAGONAL:
					posicaoInimigo = posicaoSelecionada + pos
					tratarInimigo.emit(posicaoInimigo, dano)

func _on_turno_mago_habilitar_carta() -> void:
	mao_jogador.process_mode = Node.PROCESS_MODE_INHERIT

func _on_turno_mago_desabilitar_carta() -> void:
	mao_jogador.process_mode = Node.PROCESS_MODE_DISABLED
	fecharModal()
