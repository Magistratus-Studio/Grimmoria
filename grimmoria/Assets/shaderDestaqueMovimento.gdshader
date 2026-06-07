shader_type canvas_item;

// A cor para a qual o bloco vai piscar (aparecerá no Inspector)
uniform vec4 cor_destaque : source_color = vec4(1.0, 0.8, 0.2, 1.0); // Padrão: Amarelo/Dourado

// A velocidade do pulsar
uniform float velocidade = 3.0;

// O quanto a nova cor vai sobrepor a original. 
// 0.0 = Cor original pura | 1.0 = Cor de destaque pura
uniform float intensidade_minima = 0.1;
uniform float intensidade_maxima = 0.8;

void fragment() {
    // 1. Lê a cor e a transparência originais do pixel da tua imagem
    vec4 cor_original = texture(TEXTURE, UV);
    
    // 2. Calcula a onda senoidal com o Tempo (TIME)
    // O sin() retorna valores entre -1 e 1. 
    // Somar 1.0 e dividir por 2.0 converte esse intervalo para ir de 0.0 a 1.0.
    float onda = (sin(TIME * velocidade) + 1.0) / 2.0;
    
    // 3. Ajusta a onda para respeitar os teus limites de intensidade
    float fator_mistura = mix(intensidade_minima, intensidade_maxima, onda);
    
    // 4. Mistura (interpola) a cor original com a cor de destaque
    vec4 cor_final = mix(cor_original, cor_destaque, fator_mistura);
    
    // 5. Preserva a transparência original! 
    // Isto garante que o que é transparente à volta do losango não se torne um quadrado colorido.
    cor_final.a = mix(cor_original.a, cor_destaque.a, fator_mistura) * cor_original.a;
    
    // 6. Aplica o resultado final no ecrã
    COLOR = cor_final;
}