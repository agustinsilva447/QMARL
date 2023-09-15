import copy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm

eps = [1e-3, 1e-4, 1e-5, 1e-6,  1e-7,  1e-8,   1e-9]
epsiln = np.log(eps)
alp = [0.1,  0.03, 0.01, 0.003, 0.001, 0.0003, 0.0001]
alphan = np.log(alp)
alphan, epsiln = np.meshgrid(alphan, epsiln)

avgr_rew = [[3.546382314835078, 4.662058680972602, 5.526963818099236, 4.2757762458043, 3.990912741366686, 4.3838574027091095, 4.925341611598927],
[2.7619040414794918, 4.631359051096131, 4.767845960139638, 4.630774892030493, 3.392380337086371, 4.252880290377678, 2.26758407119935],
[1.9012480413640236, 5.003128407929008, 5.1370496349738985, 4.540714967567341, 3.3310395565284416, 3.6927117149084383, 3.7839771250245247],
[1.402462861516617, 4.598094106115979, 4.468260530787734, 3.992917968353119, 3.6722730391184952, 2.6382443936243645, 4.918358350540338],
[1.4771436230930117, 4.124540765370315, 5.207807781705308, 4.278666325696083, 3.9961480482274956, 4.200661631693286, 3.9119714028719335],
[2.0154928238420395, 3.7965263034797188, 4.624861845850896, 4.072260837460109, 2.7065758634359693, 3.1356741009296925, 3.092832251649133],
[1.782100332531639, 4.356852035168207, 4.9920608772215065, 4.475268575622206, 3.646648258727696, 2.9857468764472945, 2.8858750049280752]]
arr_rew = np.array(avgr_rew)

fair_fac = [[0.8674905728114, 0.876168584503106, 0.6660777890715649, 0.881647749325915, 0.7776472694172148, 0.6310154659590442, 0.36607589944916336],
[0.6818452476564828, 0.7797492583720635, 0.8392407495352937, 0.8856099154366425, 0.7317245875132032, 0.6171312369200993, 0.419247333109795],
[0.8982636317071314, 0.8392825704696303, 0.7179588861576367, 0.822927070390186, 0.8267470386332904, 0.7625610644590206, 0.765033420922835],
[0.789062292597099, 0.8428389623341741, 0.9045278314561227, 0.7687127860276874, 0.8313070723229233, 0.7777576608555707, 0.540131861268632],
[0.7036932230998073, 0.7853005781617104, 0.764702480718474, 0.6998785740764517, 0.7231792939784892, 0.7546480302985105, 0.505335334176123],
[0.8782001431246023, 0.8635223268957437, 0.8605619202346533, 0.9130364015848025, 0.8960653615235852, 0.9519164048791298, 0.6753939566381624],
[0.7812621951148432, 0.8500908941383444, 0.810124727708663, 0.7546561754114144, 0.866717288849597, 0.9645863204845265, 0.7613347279656462]]
arr_fac = np.array(fair_fac)

copy_rew = copy.deepcopy(arr_rew)
sorted_array = np.sort(copy_rew.flatten())[::-1]
for rewi in sorted_array:
    id_rew = np.where(rewi == arr_rew)
    id_fac = fair_fac[id_rew[0][0]][id_rew[1][0]]
    best_epsil = eps[id_rew[0][0]]
    best_alpha = alp[id_rew[1][0]]
    print("Average reward = {:.6f}. Fairness factor = {:.6f}. Delta epsilon = {}. Learning rate = {}.".format(rewi, id_fac, best_epsil, best_alpha))


"""fig = plt.figure(figsize=plt.figaspect(0.5))
ax = fig.add_subplot(1, 2, 1, projection='3d')
surf = ax.plot_surface(alphan, epsiln, arr_rew, rstride=1, cstride=1, cmap=cm.coolwarm, linewidth=0, antialiased=False)
ax.set_zlim(0, 10)
ax = fig.add_subplot(1, 2, 2, projection='3d')
surf = ax.plot_surface(alphan, epsiln, arr_fac, rstride=1, cstride=1, cmap=cm.coolwarm, linewidth=0, antialiased=False)
ax.set_zlim(0, 1)
plt.show()"""