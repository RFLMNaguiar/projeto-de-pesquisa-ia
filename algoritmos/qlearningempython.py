import numpy


def qlearning():
    gamma = 0.5  # Fator de desconto
    alpha = 0.5  # Learning rate.
    epsilon = 0.9  # Chance de explorar.

    state = [0, 1, 2, 3, 4, 5]
    action = [-1, 1]

    Q = numpy.zeros((len(state), len(action)))  # Matriz Q.
    K = 1000  # Número máximo de interações.
    state_idx = 3  # O estado inicial por onde começar.

    for i in range(K):
        print(f"Iteração #{i}")
        r = numpy.random.uniform()  # consegue um número aleatório entre 0 e 1.
        x = numpy.sum(r >= numpy.cumsum([0, 1 - epsilon, epsilon]))

        if x == 1: #exploit


qlearning()
