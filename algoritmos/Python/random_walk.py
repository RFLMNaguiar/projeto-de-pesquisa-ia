import random

limite_x = int(input("Digite o tamanho do eixo x: "))
limite_y = int(input("Digite o tamanho do eixo y: "))
numero_de_itens = int(input("Digite o número de coordenadas aleatórias que você deseja gerar:"))
velocidade = int(input("Digite a velocidade com que os indivíduos se movem:"))
numero_de_episodios = int(input("Digite o número de episódios:"))

if limite_x > numero_de_itens and limite_y > numero_de_itens:
    lista_de_x = random.sample(range(limite_x), numero_de_itens)
    lista_de_y = random.sample(range(limite_y), numero_de_itens)
    lista_com_coordenadas = []

    for i in range(numero_de_itens):
        lista_com_coordenadas.append([lista_de_x[i], lista_de_y[i]])

    print("Posições iniciais:")
    print(lista_com_coordenadas)

    print("Movimentações:")
    for episodio in range(numero_de_episodios):
        for i in range(numero_de_itens):
            direcao = random.randrange(0, 4)
            if direcao == 0:
                # NORTE
                if (lista_com_coordenadas[i][0] + velocidade) <= limite_x:
                    lista_com_coordenadas[i][0] += velocidade
            elif direcao == 1:
                # LESTE
                if (lista_com_coordenadas[i][1] + velocidade) <= limite_y:
                    lista_com_coordenadas[i][1] += velocidade
            elif direcao == 2:
                # SUL
                if (lista_com_coordenadas[i][0] - velocidade) >= 0:
                    lista_com_coordenadas[i][0] -= velocidade
            elif direcao == 3:
                # OESTE
                if (lista_com_coordenadas[i][1] - velocidade) >= 0:
                    lista_com_coordenadas[i][1] -= velocidade

        print(lista_com_coordenadas)

else:
    print("O número de itens não pode ser maior que as dimensões de x e/ou y!")
