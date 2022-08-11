import random


def imprimir_lista_de_nos():
    """ESSA FUNÇÃO IMPRIME OS NÓS DE MANEIRA INTELIGÍVEL."""
    print("[", end="")
    for i in range(len(lista_com_nos)):
        if lista_com_nos[i].direcao == 0:
            direcao_string = 'X++'
        elif lista_com_nos[i].direcao == 1:
            direcao_string = 'Y++'
        elif lista_com_nos[i].direcao == 2:
            direcao_string = 'X--'
        else:
            direcao_string = 'Y--'

        print(f"[{lista_com_nos[i].x}, {lista_com_nos[i].y}]", end="")
        if i < len(lista_com_nos) - 1:
            print(", ", end="")
    print("]")


class No:
    def __init__(self, x, y, direcao):
        self.x = x
        self.y = y
        self.direcao = direcao


limite_x = 100
limite_y = 100
velocidade = 1

numero_de_itens = int(input("Digite o número de coordenadas aleatórias que você deseja gerar (1 a 25):"))
numero_de_episodios = int(input("Digite o número de episódios:"))

if 1 <= numero_de_itens <= 25:
    lista_de_x = random.sample(range(1, limite_x, 2), numero_de_itens)
    lista_de_y = random.sample(range(1, limite_y, 2), numero_de_itens)
    lista_com_nos = []

    for i in range(numero_de_itens):
        direcao = random.randrange(0, 4)
        lista_com_nos.append(No(lista_de_x[i], lista_de_y[i], direcao))

    print("Posições iniciais:")

    imprimir_lista_de_nos()

    print("Movimentações:")
    for episodio in range(numero_de_episodios):
        for i in range(numero_de_itens):
            # DEFINE A DIREÇÃO:
            # ESTÁ DENTRO DOS LIMITES?
            vai_ficar_dentro_de_x = (lista_com_nos[i].x + velocidade) <= limite_x and (lista_com_nos[i].x - velocidade) >= 0
            vai_ficar_dentro_de_y = (lista_com_nos[i].y + velocidade) <= limite_y and (lista_com_nos[i].y - velocidade) >= 0
            vai_ficar_nos_limites = vai_ficar_dentro_de_x and vai_ficar_dentro_de_y

            # NÃO ESTÁ DENTRO DOS LIMITES, ENTÃO VAI DAR MEIA VOLTA (180 GRAUS):
            if not vai_ficar_nos_limites:
                if lista_com_nos[i].direcao == 0:
                    lista_com_nos[i].direcao = 2
                elif lista_com_nos[i].direcao == 1:
                    lista_com_nos[i].direcao = 3
                elif lista_com_nos[i].direcao == 2:
                    lista_com_nos[i].direcao = 0
                elif lista_com_nos[i].direcao == 3:
                    lista_com_nos[i].direcao = 1

            # ESTÁ DENTRO DOS LIMITES:
            else:
                # ENCONTROU UM CRUZAMENTO. VAI MUDAR DE DIREÇÃO?
                if (lista_com_nos[i].x % 2 == 1) and (lista_com_nos[i].x % 2 == 1):
                    nova_direcao = random.randrange(0, 4)
                    if nova_direcao == 2:
                        # VIRA PARA A ESQUERDA
                        lista_com_nos[i].direcao = lista_com_nos[i].direcao - 1 if (lista_com_nos[i].direcao + 1) > 0 else 3
                    if nova_direcao == 3:
                        # VIRA PARA A DIREITA
                        lista_com_nos[i].direcao = lista_com_nos[i].direcao + 1 if (lista_com_nos[i].direcao + 1) < 4 else 0

            # MOVIMENTAÇÃO:
            if lista_com_nos[i].direcao == 0:
                lista_com_nos[i].x += 1
            elif lista_com_nos[i].direcao == 1:
                lista_com_nos[i].y += 1
            elif lista_com_nos[i].direcao == 2:
                lista_com_nos[i].x -= 1
            elif lista_com_nos[i].direcao == 3:
                lista_com_nos[i].y -= 1

        imprimir_lista_de_nos()

else:
    print("O número de itens não pode ser maior que as dimensões de x e/ou y!")
