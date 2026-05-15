extends Control

const ALEGRIA = 208
const AMOR = 136
const MEDO = 80
const RAIVA = 30
const TRISTEZA = 330
const SURPRESA = 280

@onready var main: PackedScene = load("res://Cenas/menu_inicial.tscn")

@onready var timerText: Label = $TimerText
@onready var buttonText: Label = $ControlStartLeitura/LabelButton
@onready var leituraText: Label = $LeituraText
@onready var timer: Timer = $TimerLeitura
@onready var leituraButton: Control = $ControlStartLeitura
@onready var roda: Sprite2D = $Roda
@onready var ponteiro: Sprite2D = $Ponteiro
@onready var slider: HSlider = $HSlider
@onready var buttonVoltar: Control = $ControlVoltar

var segundos: int = 0
var minutos: int = 0
var statusLeitura: bool = false

func _ready() -> void:
	segundos = 0
	minutos = 0
	statusLeitura = false
	timerText.text = "00:00"
	buttonText.text = "Iniciar Leitura"
	leituraText.text = "Tempo de Leitura"
	timerText.visible = true
	leituraButton.visible = true
	leituraButton.process_mode = Node.PROCESS_MODE_INHERIT
	roda.visible = false
	ponteiro.visible = false
	slider.visible = false
	slider.process_mode = Node.PROCESS_MODE_DISABLED
	buttonVoltar.visible = false
	buttonVoltar.process_mode = Node.PROCESS_MODE_DISABLED

func _on_button_start_leitura_pressed() -> void:
	statusLeitura = not statusLeitura
	if statusLeitura:
		comecar_leitura()
	else:
		parar_leitura()

func _on_timer_leitura_timeout() -> void:
	segundos += 1
	if segundos >= 60:
		minutos += 1
		segundos = 0
	timerText.text = str("%02d" % minutos) + ":" + str("%02d" % segundos)

func comecar_leitura() -> void:
	timer.start()
	buttonText.text = "Parar Leitura"

func parar_leitura() -> void:
	timer.stop()
	timerText.visible = false
	leituraText.text = "Leitura Finalizada"
	leituraButton.visible = false
	leituraButton.process_mode = Node.PROCESS_MODE_DISABLED
	roda.visible = true
	ponteiro.visible = true
	slider.visible = true
	slider.process_mode = Node.PROCESS_MODE_INHERIT
	buttonVoltar.visible = true
	buttonVoltar.process_mode = Node.PROCESS_MODE_INHERIT


func _on_h_slider_value_changed(value: float) -> void:
	value = int(value) % 360
	roda.rotation_degrees = value


func _on_button_voltar_pressed() -> void:
	get_tree().change_scene_to_packed(main)
