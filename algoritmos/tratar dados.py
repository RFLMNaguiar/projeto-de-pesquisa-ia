import statistics as st
import math
import matplotlib.pyplot as plt

caminho_do_arquivo = input("Digite aqui o caminho do arquivo:")
f = open(caminho_do_arquivo, "r")
string = f.read()

string = string.replace("\n", " ")
string = string.replace("  ", " ")

dados = string.split()

for i in range(len(dados)):
    dados[i] = int(dados[i])

dados.sort()

# Medidas de Centralidade
media = st.mean(dados)
mediana = st.median(dados)
moda = st.mode(dados)
minimo = min(dados)
maximo = max(dados)

# Medidas de Dispersão
amplitude = maximo - minimo
desvio_padrao = st.stdev(dados)
variancia = st.variance(dados)
coeficiente_de_variacao = (desvio_padrao / variancia) * 100
quartis = st.quantiles(dados)
q1, q2, q3 = quartis[0], quartis[1], quartis[2]
coeficiente_de_assimetria = q3 / mediana ** (3 / 2)

print(f"Dados coletados ({len(dados)}):")
print(f"{dados}\n")

print("Resultados com dados brutos:")
print(
    f"\tMEDIDAS DE CENTRALIDADE\n\tMédia: {media}\n\tMediana: {mediana}\n\tModa: {moda}\n\tMínimo: {minimo}\n\tMáximo: "
    f"{maximo}\n\tMEDIDAS DE DISPERSÃO\n\tAmplitude: {amplitude}\n\tDesvio Padrão: {desvio_padrao}\n\tVariância: "
    f"{variancia}\n\tCoeficiente de Variação: {coeficiente_de_variacao}\n\tCoeficiente de Assimetria: "
    f"{coeficiente_de_assimetria}")

amplitude_interquartil = q3 - q1
outliers = []

for i in range(3 * (len(dados) // 4), len(dados)):
    if dados[i] < q1 - 1.5 * amplitude_interquartil or dados[i] > q3 + 1.5 * amplitude_interquartil:
        outliers.append(dados[i])
        if dados[i] < q1 - 3 * amplitude_interquartil or dados[i] > q3 + 3 * amplitude_interquartil:
            print(f"Outlier extremo encontrado: {dados[i]}")
        else:
            print(f"Outlier moderado encontrado: {dados[i]}")

novos_dados = dados.copy()

for i in outliers:
    novos_dados.remove(i)

# Medidas de Centralidade
nmedia = st.mean(novos_dados)
nmediana = st.median(novos_dados)
nmoda = st.mode(novos_dados)
nminimo = min(novos_dados)
nmaximo = max(novos_dados)

# Medidas de Dispersão
namplitude = nmaximo - nminimo
ndesvio_padrao = st.stdev(novos_dados)
nvariancia = st.variance(novos_dados)
ncoeficiente_de_variacao = (ndesvio_padrao / nvariancia) * 100
nquartis = st.quantiles(novos_dados)
nq1, nq2, nq3 = nquartis[0], nquartis[1], nquartis[2]
ncoeficiente_de_assimetria = nq3 / nmediana ** (3 / 2)

print(f"\nNovos dados ({len(novos_dados)}):")
print(f"{novos_dados}\n")

print("Resultados com dados tratados:")
print(
    f"\tMEDIDAS DE CENTRALIDADE\n\tMédia: {nmedia}\n\tMediana: {nmediana}\n\tModa: {nmoda}\n\tMínimo: {nminimo}\n\t"
    f"Máximo: {nmaximo}\n\tMEDIDAS DE DISPERSÃO\n\tAmplitude: {namplitude}\n\tDesvio Padrão: {ndesvio_padrao}\n\t"
    f"Variância: {nvariancia} \n\tCoeficiente de Variação: {ncoeficiente_de_variacao}\n\tCoeficiente de Assimetria: "
    f"{ncoeficiente_de_assimetria}")

# Plotagem do histograma
numero_de_classes = round(1 + 3.3 * math.log10(len(novos_dados)))
tamanho_das_classes = namplitude / numero_de_classes
frequencias = []

for i in range(numero_de_classes):
    print(f"Classe {i + 1}:")
    print(
        f"\t{((i * tamanho_das_classes) + min(novos_dados))} < valor < {(((i + 1) * tamanho_das_classes) + min(novos_dados))}")
    frequencia_classe_atual = 0
    for j in novos_dados:
        if ((i * tamanho_das_classes) + min(novos_dados)) < j <= (((i + 1) * tamanho_das_classes) + min(novos_dados)):
            frequencia_classe_atual += 1
    print(f"\tFrequência: {frequencia_classe_atual}")
    frequencias.append(frequencia_classe_atual)

plt.hist(novos_dados, bins=numero_de_classes)
plt.show()
