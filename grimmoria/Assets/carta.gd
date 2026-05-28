extends TextureButton

# Criamos um sinal que envia junto os dados da carta
signal carta_tocada(dados_da_carta: CardResource)

@export var dados: CardResource:
	set(value):
		dados = value
		if is_inside_tree():
			texture_normal = dados.imagem_da_carta

func _ready() -> void:
	if dados:
		texture_normal = dados.imagem_da_carta

# Conecte o sinal "pressed" do próprio TextureButton aqui
func _on_pressed() -> void:
	# Emite o sinal personalizado avisando que esta carta foi selecionada
	carta_tocada.emit(dados)
