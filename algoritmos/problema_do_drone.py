import numpy as np
import random
from matplotlib import pyplot, colors


class usuario:
    def __init__(self, x, y, banda):
        self.classe = "usuario"
        self.x = x
        self.y = y
        self.banda = banda


class drone:
    def __init__(self, x, y, raio):
        self.classe = "drone"
        self.x = x
        self.y = y
        self.raio = raio


def criar_drone(raio):
    while True:
        x, y = random.randint(0, 99), random.randint(0, 99)
        if ambiente_aereo[x][y] is None:
            novo_drone = drone(x, y, raio)
            lista_de_drones.append(novo_drone)
            break


def criar_usuario(banda):
    while True:
        x, y = random.randint(0, 99), random.randint(0, 99)
        if ambiente_terrestre[x][y] is None:
            novo_usuario = usuario(x, y, banda)
            lista_de_usuarios.append(novo_usuario)
            break


ambiente_aereo = [[None for i in range(0, 100)] for i in range(0, 100)]
ambiente_terrestre = [[None for i in range(0, 100)] for i in range(0, 100)]

n_drones = int(input("Digite o número de drones: "))
n_usuarios = int(input("Digite o número de usuários: "))

lista_de_usuarios, lista_de_drones = [], []

for i in range(n_drones):
    criar_drone(100)

for i in range(n_usuarios):
    criar_usuario(50)

print("LISTA DE DRONES")
for i in range(n_drones):
    print(f"Drone #{i}:\n\tX: {lista_de_drones[i].x}"
          f"\n\tY: {lista_de_drones[i].y}"
          f"\n\tRAIO: {lista_de_drones[i].raio}\n")

print("LISTA DE USUÁRIOS")
for i in range(n_usuarios):
    print(f"Usuário #{i}:\n\tX: {lista_de_usuarios[i].x}"
          f"\n\tY: {lista_de_usuarios[i].y}"
          f"\n\tBANDA: {lista_de_usuarios[i].banda}\n")

exibicao = [[0.0 for i in range(0, 100)] for i in range(0, 100)]

for i in range(1, 100):
    for j in range(1, 100):
        if ambiente_aereo[i][j] is None and ambiente_terrestre[i][j] is None:
            pass
        elif ambiente_aereo[i][j].group == "drone":
            exibicao[i][j] = 1.0  # 1.0 significa "drone"
        else:
            exibicao[i][j] = 2.0  # 2.0 significa "usuario"


# usando cores de matplotlib, defina um mapa de cores
colormap = colors.ListedColormap(["lightgrey", "green", "blue"])
# definir o tamanho da figura usando pyplot
pyplot.figure(figsize=(12, 12))
# usando pyplot adicione um título
pyplot.title("battlefield before simulation run (green = A, blue = B)",
             fontsize=24)
# usando pyplot adicione rótulos x e y
pyplot.xlabel("x coordinates", fontsize=20)
pyplot.ylabel("y coordinates", fontsize=20)
# ajustar as marcações dos eixos xey, usando pyplot
pyplot.xticks(fontsize=16)
pyplot.yticks(fontsize=16)
# use o método .imshow () do pyplot para visualizar as localizações dos agentes
pyplot.imshow(X=population,
              cmap=colormap)
