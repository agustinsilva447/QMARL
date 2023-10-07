import numpy as np
import matplotlib.pyplot as plt

n = 2
with open('platonia_2q.npy', 'rb') as f:
    feedback = np.load(f)

for i in range(n):
  plt.plot(feedback[i], label="Player {}".format(i))
plt.ylim(0, 10)
plt.xlabel("Iterations")
plt.ylabel("Rewards")
plt.legend()
plt.show()