extends Control

@onready var resultadoLeitura: PackedScene = load("res://Cenas/resultadoLeitura.tscn")

@export_category("UI Leitura")
@export var container_leitura: Control
@export var timer_text: Label
@export var leitura_text: Label
@export var timer: Timer

@export_category("UI Roleta")
@export var container_emocao: Control

@export_category("UI Caixa Dialogo")
@export var caixa_dialogo: Panel

@export_category("UI Finalizar")
@export var container_finalizar: Control

var tempo_total_segundos: int = 0
var status_leitura: bool = true
var tela_atual: Control = null

func _ready() -> void:
	tempo_total_segundos = 0
	status_leitura = true
	timer.start()
	
	timer_text.text = "00:00"
	leitura_text.text = "Tempo de Leitura"
	
	desabilitar_tela(container_emocao)
	desabilitar_tela(container_finalizar)
	desabilitar_tela(caixa_dialogo)
	# Chama a função que gerencia quem está visível e ativo
	definir_estado_tela(container_leitura)

func _on_timer_leitura_timeout() -> void:
	tempo_total_segundos += 1
	
	# Calcula minutos e segundos na hora de exibir
	var minutos: int = tempo_total_segundos / 60
	var segundos: int = tempo_total_segundos % 60
	
	# Formatação limpa usando Array: [minutos, segundos]
	timer_text.text = "%02d:%02d" % [minutos, segundos]

func _on_button_parar_leitura_pressed() -> void:
	status_leitura = false
	leitura_text.text = "Leitura Finalizada"
	timer.stop()
	
	definir_estado_tela(container_emocao)

func _on_button_finalizar_pressed() -> void:
	get_tree().change_scene_to_packed(resultadoLeitura)

func _on_button_selecionar_emocao_pressed() -> void:
	caixa_dialogo.show()
	caixa_dialogo.process_mode = Node.PROCESS_MODE_INHERIT
	container_emocao.process_mode = Node.PROCESS_MODE_DISABLED

func _on_sim_pressed() -> void:
	desabilitar_tela(caixa_dialogo)
	definir_estado_tela(container_finalizar)

func _on_nao_pressed() -> void:
	desabilitar_tela(caixa_dialogo)
	container_emocao.process_mode = Node.PROCESS_MODE_INHERIT

func definir_estado_tela(tela: Control) -> void:
	if tela_atual:
		tela_atual.hide()
		tela_atual.process_mode = Node.PROCESS_MODE_DISABLED
	tela_atual = tela
	tela_atual.show()
	tela_atual.process_mode = Node.PROCESS_MODE_INHERIT

func desabilitar_tela(tela) -> void:
	tela.hide()
	tela.process_mode = Node.PROCESS_MODE_DISABLED
