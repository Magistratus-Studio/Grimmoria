extends Node

const HABILITA = true
const DESABILITA = false

@onready var telaInicial: Control = $TelaInicial
@onready var menu: Control = $Menu
@onready var biblioteca: Control = $Biblioteca
@onready var configuracoes: Control = $Configuracoes

func _ready() -> void:
	alternarElemento(DESABILITA, menu)
	alternarElemento(DESABILITA, biblioteca)
	alternarElemento(DESABILITA, configuracoes)

func alternarElemento(modo: bool, elemento: Control) -> void:
	elemento.visible = modo
	if not modo:
		elemento.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		elemento.process_mode = Node.PROCESS_MODE_INHERIT

func _on_button_iniciar_pressed() -> void:
	alternarElemento(DESABILITA, telaInicial)
	alternarElemento(HABILITA, menu)

func _on_button_biblioteca_pressed() -> void:
	alternarElemento(DESABILITA, menu)
	alternarElemento(HABILITA, biblioteca)

func _on_button_voltar_biblioteca_pressed() -> void:
	alternarElemento(DESABILITA, biblioteca)
	alternarElemento(HABILITA, menu)
	
func _on_button_config_pressed() -> void:
	alternarElemento(DESABILITA, menu)
	alternarElemento(HABILITA, configuracoes)

func _on_button_voltar_config_pressed() -> void:
	alternarElemento(DESABILITA, configuracoes)
	alternarElemento(HABILITA, menu)
