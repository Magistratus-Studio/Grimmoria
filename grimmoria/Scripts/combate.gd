extends Node2D

@onready var tileMap: TileMapLayer = $TileMapLayer
# Referências dos nós do Modal
@onready var modal_descricao: PanelContainer = $CanvasLayer/ModalDescricao
@onready var modal_nome: Label = $CanvasLayer/ModalDescricao/VBoxContainer/TextoNome
@onready var modal_descricao_texto: Label = $CanvasLayer/ModalDescricao/VBoxContainer/TextoDescricao

@onready var mao_jogador: HBoxContainer = $CanvasLayer/MaoJogador
var cena_carta = preload("res://Assets/carta.tscn") # Corrigido para .tscn

# Guarda temporariamente qual carta está aberta no modal
var carta_selecionada_dados: CardResource = null

# NOVA VARIÁVEL: Guarda a referência do NÓ visual da carta que está aberta no modal
var carta_selecionada_no: TextureButton = null

# NOVO: Lista que servirá como a sua pilha de descarte futuramente
var pilha_de_descarte: Array[CardResource] = []

# Temporario
@export var carta_teste: CardResource

func _ready() -> void:
	Globals.definir_orientacao(Globals.PAISAGEM)
	modal_descricao.visible = false
	
	var centro_monitor = get_window().size / 2
	var deslocamentoVertical = Vector2i(0, int(centro_monitor[1] * 0.3))
	tileMap.position = centro_monitor - deslocamentoVertical
	
	_inicializar_combate()
	
	# TESTE AUTOMÁTICO: Carrega sua bola de fogo se ela estiver configurada no editor
	# Se preferir usar o load(), mude para: comprar_carta(load("res://..."))
	# Para este exemplo, assumindo que você chamará comprar_carta() de algum lugar
	comprar_carta(carta_teste)
	comprar_carta(carta_teste)
	comprar_carta(carta_teste)
	comprar_carta(carta_teste)
	comprar_carta(carta_teste)

func _inicializar_combate() -> void:
	print("Combate Iniciado em Modo Paisagem!")

func _on_combate_terminou(vitoria: bool) -> void:
	if vitoria:
		print("Jogador venceu!")
	else:
		print("Jogador perdeu!")
	
	Globals.definir_orientacao(Globals.RETRATO)
	get_tree().change_scene_to_file("res://Cenas/menu_inicial.tscn")

func _on_turno_button_pressed() -> void:
	_on_combate_terminou(true)

func comprar_carta(dados_da_carta: CardResource) -> void:
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

func _on_botao_fechar_modal_pressed() -> void:
	modal_descricao.visible = false
	carta_selecionada_dados = null
	carta_selecionada_no = null

func _on_botao_jogar_modal_pressed() -> void:
	if carta_selecionada_dados and carta_selecionada_no:
		print("Executando o efeito da carta: ", carta_selecionada_dados.nome)
		
		# 1. LÓGICA DO JOGO: (Exemplo) APLICAR DANOS / MANA AQUI...
		# Seu código de redução de AP e dano vai aqui usando carta_selecionada_dados
		
		# 2. ADICIONAR À PILHA DE DESCARTE:
		# Guarda os dados lógicos da carta na nossa lista de descarte antes de sumir com ela
		pilha_de_descarte.append(carta_selecionada_dados)
		print("Carta adicionada ao descarte. Total no descarte: ", pilha_de_descarte.size())
		
		# 3. REMOVER VISUALMENTE DA MÃO:
		# Deleta o nó do botão da árvore. O HBoxContainer vai reorganizar as cartas restantes na hora!
		carta_selecionada_no.queue_free()
		
		# Limpa as referências e fecha o modal
		modal_descricao.visible = false
		carta_selecionada_dados = null
		carta_selecionada_no = null
