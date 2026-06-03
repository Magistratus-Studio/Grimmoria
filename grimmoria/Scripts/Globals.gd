extends Node

# Constantes mago
const MAXVIDA:             int = 100
const MAXMANA:             int = 3

# Constantes indices roda sentimentos
const INDC_TRISTEZA:    int = 0
const INDC_SURPRESA:    int = 1
const INDC_ALEGRIA:     int = 2
const INDC_AMOR:        int = 3
const INDC_MEDO:        int = 4
const INDC_RAIVA:       int = 5

# Constantes ajuste de tela
const LARGURA_PORTRAIT: int = 720
const ALTURA_PORTRAIT:  int = 1280
const PAISAGEM:        bool = true
const RETRATO:         bool = false

var ultimo_indice_sorteado: int = 0
var tempoLeitura: int = 0
var xpSentimentos: Array[float] = [
	0, #xp tristeza
	0, #xp surpresa
	0, #xp alegria
	0, #xp amor
	0, #xp medo
	0, #xp raiva
]

var hp: int = MAXVIDA
var mp: int = MAXMANA

# --- SISTEMA DE ORIENTAÇÃO INTELIGENTE ---

func definir_orientacao(paisagem: bool) -> void:
	if OS.has_feature("mobile"):
		if paisagem:
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
		else:
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
	else:
		var janela = get_window()
		
		if not janela.is_embedded():
			var tamanho_alvo: Vector2i
			var tamanho_base_projeto: Vector2i # O tamanho base para o cálculo do Aspect Ratio
			
			if paisagem:
				tamanho_alvo = Vector2i(ALTURA_PORTRAIT, LARGURA_PORTRAIT) # Ex: 1280x720
				tamanho_base_projeto = Vector2i(ALTURA_PORTRAIT, LARGURA_PORTRAIT)
			else:
				tamanho_alvo = Vector2i(LARGURA_PORTRAIT, ALTURA_PORTRAIT) # Ex: 720x1280
				tamanho_base_projeto = Vector2i(LARGURA_PORTRAIT, ALTURA_PORTRAIT)
			
			# --- O SEGREDO PARA ATUALIZAR O ASPECT RATIO DINAMICAMENTE ---
			# Atualiza o tamanho interno de renderização do jogo (A resolução base da lógica)
			janela.content_scale_size = tamanho_base_projeto
			
			# Define como a Godot vai esticar os elementos (Equivalente ao Stretch Mode: Canvas Items)
			janela.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
			
			# Garante que o aspecto seja mantido ou expandido corretamente sem amassar a UI
			janela.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
			
			# Aplica o novo tamanho físico da janela no Windows/Linux/Mac
			janela.size = tamanho_alvo
			
			# Centraliza a janela na tela do seu monitor
			var centro_monitor = DisplayServer.screen_get_size() / 2
			janela.position = centro_monitor - (tamanho_alvo / 2)
		else:
			print("Modo de tela ignorado: A janela está embutida.")

# --- ATALHO DE DEBUG PARA O PC ---
func _input(event: InputEvent) -> void:
	# Só funciona no PC e em builds de teste (Debug)
	if OS.has_feature("pc") and OS.is_debug_build():
		# Se você apertar a tecla F1 no teclado, ele inverte o tamanho atual da janela
		if event is InputEventKey and event.pressed and event.keycode == KEY_F1:
			var tamanho_atual = DisplayServer.window_get_size()
			# Se a largura atual for menor que a altura, significa que está em pé
			var esta_em_pe = tamanho_atual.x < tamanho_atual.y
			definir_orientacao(esta_em_pe) # Passa o oposto para inverter
