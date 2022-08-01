def bresenham(ponto_inicial, ponto_final):
    coeficiente_angular = (ponto_final[1] - ponto_inicial[1])/(ponto_final[0] - ponto_inicial[0])
    erro = coeficiente_angular - 0.5
    y = ponto_inicial[1]

    pixels = [ponto_inicial]

    for i in range(ponto_inicial[0] + 1, ponto_final[0]):
        if erro > 0:
            erro = erro - 1
            y += 1
        pixels.append([i, y])
        erro = erro + coeficiente_angular

    pixels.append(ponto_final)

# Reflexão:
def reflexao_inicial(ponto_inicial, ponto_final):
    m = (ponto_final[1] - ponto_inicial[1])/(ponto_final[0] - ponto_inicial[0])
    if (m > 1 or m < -1):
        ponto_inicial[0], ponto_inicial[1] = ponto_inicial[1], ponto_inicial[0]
        ponto_final[0], ponto_final[1] = ponto_final[1], ponto_final[0]
    if ponto_inicial[0] > ponto_final[0]:
        ponto_inicial[0], ponto_final[0] = -ponto_inicial[0], -ponto_final[0]
    if ponto_inicial[1] > ponto_final[1]:
        ponto_inicial[1], ponto_final[1] = -ponto_inicial[1], -ponto_final[1]

def reflexao_reta():
    print()
