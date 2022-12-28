def find_correlated_equilibrium(payoff_matrix, max_iterations, convergence_threshold):
  player_1_beliefs = [0.5, 0.5]
  player_2_beliefs = [0.5, 0.5]

  player_1_strategy = 1
  player_2_strategy = 1

  belief_difference = 1
  iteration = 0
  while (belief_difference > convergence_threshold) and (max_iterations > iteration):
    player_1_strategy = player_1_beliefs.index(max(player_1_beliefs))
    player_2_strategy = player_2_beliefs.index(max(player_2_beliefs))

    expected_payoff_2 = payoff_matrix[player_1_strategy][player_2_strategy][0]
    expected_payoff_1 = payoff_matrix[player_2_strategy][player_1_strategy][1]

    player_1_beliefs[player_2_strategy] = player_1_beliefs[player_2_strategy] * (1 + expected_payoff_2)
    player_2_beliefs[player_1_strategy] = player_2_beliefs[player_1_strategy] * (1 + expected_payoff_1)

    player_1_beliefs = [belief/sum(player_1_beliefs) for belief in player_1_beliefs]
    player_2_beliefs = [belief/sum(player_2_beliefs) for belief in player_2_beliefs]

    belief_difference = sum([abs(player_1_beliefs[i] - player_2_beliefs[i]) for i in range(2)])
    iteration += 1
    print(player_1_beliefs,  player_2_beliefs)
    print(player_1_strategy, player_2_strategy)
    print("Iteration {} => Reward of player 0 = {}. Reward of player 1 = {}.".format(iteration, expected_payoff_1, expected_payoff_2))
  return player_1_strategy, player_2_strategy

payoff_matrix = [[(33,33), (0,50)],
                 [(50,0), (10,10)]]
max_iterations = 1000
convergence_threshold = 0.01
equilibrium_strategies = find_correlated_equilibrium(payoff_matrix, max_iterations, convergence_threshold)
print(equilibrium_strategies)