import random

limite_x = int(input("Digite o tamanho do eixo x: "))
limite_y = int(input("Digite o tamanho do eixo y: "))
numero_de_itens = int(input("Digite o número de coordenadas aleatórias que você deseja gerar:"))

if limite_x > numero_de_itens and limite_y > numero_de_itens:
    lista_de_x = random.sample(range(limite_x), numero_de_itens)
    lista_de_y = random.sample(range(limite_y), numero_de_itens)
    lista_com_coordenadas = []

    arquivo = open("../coordenadas.txt", "w")

    arquivo.write("users1\n\nusers =\n\n")
    for i in range(numero_de_itens):
        arquivo.write(f"    {lista_de_x[i]}    {lista_de_y[i]}\n")

    arquivo.close()
    print(lista_com_coordenadas)
else:
    print("O número de itens não pode ser maior que as dimensões de x e/ou y!")
