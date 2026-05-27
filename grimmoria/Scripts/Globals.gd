extends Node

const INDC_TRISTEZA: int = 0
const INDC_SURPRESA: int = 1
const INDC_ALEGRIA:  int = 2
const INDC_AMOR:     int = 3
const INDC_MEDO:     int = 4
const INDC_RAIVA:    int = 5

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
