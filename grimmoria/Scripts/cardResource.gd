class_name CardResource
extends Resource

@export var nome: String = "Bola de Fogo"
@export var custo_ap: int = 1
@export var valor_dano: int = 5
@export_enum("Ataque", "Defesa", "Especial") var tipo: String = "Ataque"
@export_enum("1x1", "3x3", "Cruz", "Cone", "Diagonais", "Linha") var aoe: String = "1x1"
@export var imagem_da_carta: Texture2D

# A descrição que SERÁ MOSTRADA NO MODAL
@export_multiline var descricao_efeito: String = "Causa 5 de dano de fogo em um quadrado do grid."
