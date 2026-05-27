extends Control

@onready var animacao_premio: AnimatedSprite2D = $AnimatedSprite2D
@onready var texto_xp: Label = $TextoXP
@onready var texto_total: Label = $TextoTotal

func _ready() -> void:
	# 1. Resgata qual foi o prêmio sorteado na cena anterior
	var indice_ganho = Globals.ultimo_indice_sorteado
	
	# 2. Descobre quanto de XP esse prêmio vale consultando a tabela do Global
	var xp_ganho = Globals.tempoLeitura
	
	match indice_ganho:
		Globals.INDC_ALEGRIA:
			Globals.xpSentimentos[indice_ganho] += xp_ganho
			texto_xp.text = str(xp_ganho) + " XP de Alegria!"
			texto_total.text = "XP Alegria Total: " + str(Globals.xpSentimentos[indice_ganho])
		Globals.INDC_AMOR:
			Globals.xpSentimentos[indice_ganho] += xp_ganho
			texto_xp.text = str(xp_ganho) + " XP de Amor!"
			texto_total.text = "XP Amor Total: " + str(Globals.xpSentimentos[indice_ganho])
		Globals.INDC_MEDO:
			Globals.xpSentimentos[indice_ganho] += xp_ganho
			texto_xp.text = str(xp_ganho) + " XP de Medo!"
			texto_total.text = "XP Medo Total: " + str(Globals.xpSentimentos[indice_ganho])
		Globals.INDC_RAIVA:
			Globals.xpSentimentos[indice_ganho] += xp_ganho
			texto_xp.text = str(xp_ganho) + " XP de Raiva!"
			texto_total.text = "XP Raiva Total: " + str(Globals.xpSentimentos[indice_ganho])
		Globals.INDC_SURPRESA:
			Globals.xpSentimentos[indice_ganho] += xp_ganho
			texto_xp.text = str(xp_ganho) + " XP de Surpresa!"
			texto_total.text = "XP Surpresa Total: " + str(Globals.xpSentimentos[indice_ganho])
		Globals.INDC_TRISTEZA:
			Globals.xpSentimentos[indice_ganho] += xp_ganho
			texto_xp.text = str(xp_ganho) + " XP de Tristeza!"
			texto_total.text = "XP Tristeza Total: " + str(Globals.xpSentimentos[indice_ganho])
	
	var nome_animacao = "anim_" + str(indice_ganho)
	animacao_premio.play(nome_animacao)

# Opcional: Um botão para voltar ao menu principal
func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/menu_inicial.tscn")
