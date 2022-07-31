from qiskit import QuantumCircuit, Aer, execute
from qiskit.quantum_info import Operator
from qiskit.extensions import RXGate, RYGate, RZGate   
import numpy as np

def crear_circuito(tipo1, tipo2):
    I = np.array([[1, 0],
                  [0, 1]])
    X = np.array([[0, 1],
                  [1, 0]])    
    I_f = np.kron(I, I)
    X_f = np.kron(X, X)
    
    J = Operator(1 / np.sqrt(2) * (I_f + 1j * X_f))    
    J_dg = J.adjoint()
    circ = QuantumCircuit(2,2)
    circ.append(J, range(2))    
    circ.append(RXGate(tipo1[0]),[0])
    circ.append(RYGate(tipo1[1]),[0])
    circ.append(RZGate(tipo1[2]),[0])   
    circ.append(RXGate(tipo2[0]),[1])
    circ.append(RYGate(tipo2[1]),[1])
    circ.append(RZGate(tipo2[2]),[1])    
    circ.append(J_dg, range(2))
    circ.measure(range(2), range(2))  
    return circ

def reward_game(rotat1, rotat2):
    circ = crear_circuito(rotat1, rotat2)
    backend = Aer.get_backend('qasm_simulator')
    measurement = execute(circ, backend=backend, shots=1).result().get_counts(circ)    
    output = list(measurement.keys())[0]
    if output == '00':
        return [3,3]
    elif output == '01':
        return [0,5]
    elif output == '10':
        return [5,0]
    elif output == '11':
        return [1,1]

rotat1 = [0,0,0]
rotat2 = [0,0,0]   
reward = reward_game(rotat1, rotat2)[0]
print(reward)