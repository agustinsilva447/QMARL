import numpy as np
import tensorflow as tf
from tensorflow import keras

# Define the payoff matrix
R, T, S, P = 3, 5, 0, 1
payoff_matrix = np.array([[R, S], [T, P]])

# Define the neural network architecture
model = keras.Sequential([keras.layers.Dense(units=3, activation="sigmoid", input_shape=(2,)),
                           keras.layers.Dense(units=1, activation="sigmoid")])

# Define the function for generating an action from the neural network
def generate_action(state, model):
    return np.argmax(model.predict(np.array(state).reshape(1,-1))[0])

# Define the function for playing a game between two agents
def play_game(model1, model2, num_rounds):
    a1, a2, a1_score, a2_score = 0, 0, 0, 0 # Initialize agents' actions and scores
    for i in range(num_rounds):
        state = [a1, a2] # Generate the current state
        a1, a2 = generate_action(state, model1), generate_action(state[::-1], model2) # Generate agents' actions
        a1_score, a2_score = payoff_matrix[a1,a2], payoff_matrix[a2,a1] # Calculate agents' scores
    return a1_score, a2_score # Return the final scores

# Play the game multiple times and update the neural networks
num_games = 1000
for i in range(num_games):
    # Play the game
    agent1_score, agent2_score = play_game(model, model, num_rounds=10)
    # Update the neural networks
    if agent1_score > agent2_score:
        model.fit(np.array([[0,0],[1,0],[0,1],[1,1]]), np.array([0,1,1,0]).reshape(-1,1), epochs=1, verbose=0)
    elif agent2_score > agent1_score:
        model.fit(np.array([[0,0],[1,0],[0,1],[1,1]]), np.array([1,0,0,1]).reshape(-1,1), epochs=1, verbose=0)
    else:
        pass # Do nothing if the scores are tied

# Test the agents by playing a final game
agent1_score, agent2_score = play_game(model, model, num_rounds=10)
print(f"Final scores: Agent 1 = {agent1_score}, Agent 2 = {agent2_score}")