extends Control

@onready var resultadoLeitura: PackedScene = load("res://Cenas/resultadoLeitura.tscn")

# UI Leitura
@onready var timer_text: Label = $TimerText
@onready var button_text: Label = $ControlStartLeitura/LabelButton
@onready var leitura_text: Label = $LeituraText
@onready var timer: Timer = $TimerLeitura
@onready var leitura_button: Control = $ControlStartLeitura

# UI Roleta
@onready var roda: Sprite2D = $Roda
@onready var ponteiro: Sprite2D = $Ponteiro
@onready var button_voltar: Control = $ControlVoltar
@onready var roda_control: Control = $RodaControl

var tempo_total_segundos: int = 0
var status_leitura: bool = false

func _ready() -> void:
	tempo_total_segundos = 0
	status_leitura = false
	
	timer_text.text = "00:00"
	button_text.text = "Iniciar Leitura"
	leitura_text.text = "Tempo de Leitura"
	
	# Chama a função que gerencia quem está visível e ativo
	_definir_estado_tela(true)

func _on_button_start_leitura_pressed() -> void:
	status_leitura = not status_leitura
	
	if status_leitura:
		timer.start()
		button_text.text = "Parar Leitura"
	else:
		timer.stop()
		Globals.tempoLeitura = tempo_total_segundos
		leitura_text.text = "Leitura Finalizada"
		# Quando para a leitura, muda para a tela da roleta
		_definir_estado_tela(false)

func _on_timer_leitura_timeout() -> void:
	tempo_total_segundos += 1
	
	# Calcula minutos e segundos na hora de exibir
	var minutos: int = tempo_total_segundos / 60
	var segundos: int = tempo_total_segundos % 60
	
	# Formatação limpa usando Array: [minutos, segundos]
	timer_text.text = "%02d:%02d" % [minutos, segundos]

func _on_button_voltar_pressed() -> void:
	get_tree().change_scene_to_packed(resultadoLeitura)

# --- FUNÇÃO AUXILIAR ---
# Controla quem aparece na tela. true = Leitura, false = Roleta
func _definir_estado_tela(modo_leitura: bool) -> void:
	var modo_roleta = not modo_leitura
	
	# Elementos da Leitura
	#timer_text.visible = modo_leitura
	leitura_button.visible = modo_leitura
	leitura_button.process_mode = Node.PROCESS_MODE_INHERIT if modo_leitura else Node.PROCESS_MODE_DISABLED
	
	# Elementos da Roleta
	roda.visible = modo_roleta
	ponteiro.visible = modo_roleta
	button_voltar.visible = modo_roleta
	
	var processamento_roleta = Node.PROCESS_MODE_INHERIT if modo_roleta else Node.PROCESS_MODE_DISABLED
	roda_control.process_mode = processamento_roleta
	button_voltar.process_mode = processamento_roleta
