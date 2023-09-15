import copy
import numpy as np
import matplotlib.pyplot as plt

q_noise = [0.000, 0.001, 0.003, 0.010, 0.030, 0.100, 0.300, 1.000]
gamman  = [np.pi/2]
alpha1n = [0.1, 0.01, 0.001, 0.0001]
alpha2n = [1e-8]
beta1n  = [0.9]
beta2n  = [0.99]
epsilnn = [1e-8]

para    = []
for g in gamman:
    for a1 in alpha1n:
        for a2 in alpha2n:
            for b1 in beta1n:
                for b2 in beta2n:
                    for e in epsilnn:
                        para.append([g,a1,a2,b1,b2,e])

avg_rew_n0_000_2 = [9.632618, 9.690043, 9.072438, 8.564203]
far_fac_n0_000_2 = [0.984011, 0.940626, 0.921849, 0.787867]
arr_rew_n0_000_2 = np.array(avg_rew_n0_000_2)
arr_fac_n0_000_2 = np.array(far_fac_n0_000_2)
avg_rew_n0_001_2 = [4.792500, 5.225198, 5.256291, 7.404455]
far_fac_n0_001_2 = [0.965705, 0.827055, 0.910704, 0.855796]
arr_rew_n0_001_2 = np.array(avg_rew_n0_001_2)
arr_fac_n0_001_2 = np.array(far_fac_n0_001_2)
avg_rew_n0_003_2 = [4.362906, 4.854712, 3.319884, 2.121166]
far_fac_n0_003_2 = [0.982547, 0.886833, 0.902615, 0.666415]
arr_rew_n0_003_2 = np.array(avg_rew_n0_003_2)
arr_fac_n0_003_2 = np.array(far_fac_n0_003_2)
avg_rew_n0_010_2 = [4.467505, 4.600384, 3.850909, 6.713798]
far_fac_n0_010_2 = [0.986588, 0.990026, 0.989416, 0.506876]
arr_rew_n0_010_2 = np.array(avg_rew_n0_010_2)
arr_fac_n0_010_2 = np.array(far_fac_n0_010_2)
avg_rew_n0_030_2 = [4.423417, 4.853746, 4.616679, 4.921513]
far_fac_n0_030_2 = [0.990422, 0.999911, 0.954636, 0.997442]
arr_rew_n0_030_2 = np.array(avg_rew_n0_030_2)
arr_fac_n0_030_2 = np.array(far_fac_n0_030_2)
avg_rew_n0_100_2 = [4.555948, 4.630590, 5.053634, 2.776841]
far_fac_n0_100_2 = [0.988334, 0.987821, 0.999543, 0.716337]
arr_rew_n0_100_2 = np.array(avg_rew_n0_100_2)
arr_fac_n0_100_2 = np.array(far_fac_n0_100_2)
avg_rew_n0_300_2 = [4.545632, 4.701435, 4.869777, 4.076203]
far_fac_n0_300_2 = [0.993783, 0.988679, 0.993539, 0.959693]
arr_rew_n0_300_2 = np.array(avg_rew_n0_300_2)
arr_fac_n0_300_2 = np.array(far_fac_n0_300_2)
avg_rew_n1_000_2 = [4.601101, 4.948169, 4.448175, 4.650930]
far_fac_n1_000_2 = [0.998253, 0.989577, 0.980732, 0.851161]
arr_rew_n1_000_2 = np.array(avg_rew_n1_000_2)
arr_fac_n1_000_2 = np.array(far_fac_n1_000_2)

avg_rew_n0_000_3 = [9.555914, 9.927094, 9.872661, 9.540060]
far_fac_n0_000_3 = [0.945553, 0.610797, 0.346694, 0.410474]
arr_rew_n0_000_3 = np.array(avg_rew_n0_000_3)
arr_fac_n0_000_3 = np.array(far_fac_n0_000_3)
avg_rew_n0_001_3 = [3.715610, 2.857231, 4.322579, 2.541879]
far_fac_n0_001_3 = [0.982276, 0.967798, 0.835833, 0.791982]
arr_rew_n0_001_3 = np.array(avg_rew_n0_001_3)
arr_fac_n0_001_3 = np.array(far_fac_n0_001_3)
avg_rew_n0_003_3 = [3.339015, 3.280601, 3.147173, 1.076087]
far_fac_n0_003_3 = [0.983656, 0.967552, 0.896873, 0.598869]
arr_rew_n0_003_3 = np.array(avg_rew_n0_003_3)
arr_fac_n0_003_3 = np.array(far_fac_n0_003_3)
avg_rew_n0_010_3 = [3.372963, 3.339735, 3.829144, 2.536462]
far_fac_n0_010_3 = [0.991922, 0.934783, 0.870885, 0.767401]
arr_rew_n0_010_3 = np.array(avg_rew_n0_010_3)
arr_fac_n0_010_3 = np.array(far_fac_n0_010_3)
avg_rew_n0_030_3 = [3.301429, 3.234736, 3.258629, 0.736725]
far_fac_n0_030_3 = [0.992946, 0.965616, 0.942810, 0.611079]
arr_rew_n0_030_3 = np.array(avg_rew_n0_030_3)
arr_fac_n0_030_3 = np.array(far_fac_n0_030_3)
avg_rew_n0_100_3 = [3.314258, 3.365965, 3.180213, 2.318689]
far_fac_n0_100_3 = [0.992091, 0.964315, 0.981116, 0.756747]
arr_rew_n0_100_3 = np.array(avg_rew_n0_100_3)
arr_fac_n0_100_3 = np.array(far_fac_n0_100_3)
avg_rew_n0_300_3 = [3.329782, 3.562495, 2.405393, 1.492101]
far_fac_n0_300_3 = [0.997917, 0.993286, 0.870137, 0.743913]
arr_rew_n0_300_3 = np.array(avg_rew_n0_300_3)
arr_fac_n0_300_3 = np.array(far_fac_n0_300_3)
avg_rew_n1_000_3 = [3.368472, 3.588021, 3.482089, 3.722834]
far_fac_n1_000_3 = [0.992600, 0.984105, 0.955564, 0.806854]
arr_rew_n1_000_3 = np.array(avg_rew_n1_000_3)
arr_fac_n1_000_3 = np.array(far_fac_n1_000_3)

avg_rew_n0_000_4 = [2.062501, 4.472420, 4.372547, 4.879209]
far_fac_n0_000_4 = [0.716889, 0.911284, 0.764105, 0.302235]
arr_rew_n0_000_4 = np.array(avg_rew_n0_000_4)
arr_fac_n0_000_4 = np.array(far_fac_n0_000_4)
avg_rew_n0_001_4 = [2.252832, 2.217212, 1.784257, 3.779302]
far_fac_n0_001_4 = [0.962536, 0.889295, 0.750657, 0.703286]
arr_rew_n0_001_4 = np.array(avg_rew_n0_001_4)
arr_fac_n0_001_4 = np.array(far_fac_n0_001_4)
avg_rew_n0_003_4 = [2.108070, 2.159002, 2.228964, 5.316119]
far_fac_n0_003_4 = [0.961943, 0.944193, 0.838661, 0.793107]
arr_rew_n0_003_4 = np.array(avg_rew_n0_003_4)
arr_fac_n0_003_4 = np.array(far_fac_n0_003_4)
avg_rew_n0_010_4 = [2.179511, 2.069698, 2.428663, 2.473888]
far_fac_n0_010_4 = [0.979376, 0.910528, 0.863664, 0.574025]
arr_rew_n0_010_4 = np.array(avg_rew_n0_010_4)
arr_fac_n0_010_4 = np.array(far_fac_n0_010_4)
avg_rew_n0_030_4 = [2.140372, 2.034976, 1.891812, 5.160596]
far_fac_n0_030_4 = [0.980454, 0.930862, 0.946153, 0.718919]
arr_rew_n0_030_4 = np.array(avg_rew_n0_030_4)
arr_fac_n0_030_4 = np.array(far_fac_n0_030_4)
avg_rew_n0_100_4 = [2.129971, 2.063465, 2.178156, 1.770666]
far_fac_n0_100_4 = [0.988187, 0.977392, 0.960422, 0.569692]
arr_rew_n0_100_4 = np.array(avg_rew_n0_100_4)
arr_fac_n0_100_4 = np.array(far_fac_n0_100_4)
avg_rew_n0_300_4 = [2.139590, 2.039255, 2.543915, 2.445811]
far_fac_n0_300_4 = [0.994636, 0.979767, 0.955038, 0.951663]
arr_rew_n0_300_4 = np.array(avg_rew_n0_300_4)
arr_fac_n0_300_4 = np.array(far_fac_n0_300_4)
avg_rew_n1_000_4 = [2.101604, 2.112037, 1.951957, 1.632249]
far_fac_n1_000_4 = [0.993017, 0.964504, 0.920882, 0.776254]
arr_rew_n1_000_4 = np.array(avg_rew_n1_000_4)
arr_fac_n1_000_4 = np.array(far_fac_n1_000_4)

avg_rew_n0_000_5 = [0.091283, 0.873790, 1.642989, 4.598968]
far_fac_n0_000_5 = [0.408249, 0.279443, 0.223257, 0.227959]
arr_rew_n0_000_5 = np.array(avg_rew_n0_000_5)
arr_fac_n0_000_5 = np.array(far_fac_n0_000_5)
avg_rew_n0_001_5 = [1.774209, 1.770400, 1.503303, 1.739484]
far_fac_n0_001_5 = [0.956941, 0.880370, 0.526653, 0.544819]
arr_rew_n0_001_5 = np.array(avg_rew_n0_001_5)
arr_fac_n0_001_5 = np.array(far_fac_n0_001_5)
avg_rew_n0_003_5 = [1.736374, 1.316962, 1.785714, 1.769623]
far_fac_n0_003_5 = [0.973712, 0.901797, 0.600850, 0.842144]
arr_rew_n0_003_5 = np.array(avg_rew_n0_003_5)
arr_fac_n0_003_5 = np.array(far_fac_n0_003_5)
avg_rew_n0_010_5 = [1.668004, 1.464955, 1.811365, 2.486347]
far_fac_n0_010_5 = [0.962505, 0.960788, 0.721131, 0.380069]
arr_rew_n0_010_5 = np.array(avg_rew_n0_010_5)
arr_fac_n0_010_5 = np.array(far_fac_n0_010_5)
avg_rew_n0_030_5 = [1.589707, 1.446478, 1.466511, 1.312776]
far_fac_n0_030_5 = [0.983808, 0.918125, 0.845763, 0.520884]
arr_rew_n0_030_5 = np.array(avg_rew_n0_030_5)
arr_fac_n0_030_5 = np.array(far_fac_n0_030_5)
avg_rew_n0_100_5 = [1.561227, 1.433671, 1.666833, 1.981052]
far_fac_n0_100_5 = [0.988200, 0.941538, 0.907093, 0.798282]
arr_rew_n0_100_5 = np.array(avg_rew_n0_100_5)
arr_fac_n0_100_5 = np.array(far_fac_n0_100_5)
avg_rew_n0_300_5 = [1.466596, 1.402285, 1.372517, 1.557458]
far_fac_n0_300_5 = [0.991096, 0.953187, 0.904858, 0.722982]
arr_rew_n0_300_5 = np.array(avg_rew_n0_300_5)
arr_fac_n0_300_5 = np.array(far_fac_n0_300_5)
avg_rew_n1_000_5 = [1.464736, 1.457530, 1.165631, 1.135311]
far_fac_n1_000_5 = [0.994360, 0.996091, 0.896298, 0.763334]
arr_rew_n1_000_5 = np.array(avg_rew_n1_000_5)
arr_fac_n1_000_5 = np.array(far_fac_n1_000_5)

avg_rew_n0_000_6 = [0.146334, 1.061149, 0.833613, 1.118373]
far_fac_n0_000_6 = [0.732041, 0.570863, 0.495009, 0.718575]
arr_rew_n0_000_6 = np.array(avg_rew_n0_000_6)
arr_fac_n0_000_6 = np.array(far_fac_n0_000_6)
avg_rew_n0_001_6 = [1.645033, 1.065245, 1.465772, 0.802157]
far_fac_n0_001_6 = [0.977747, 0.737440, 0.684606, 0.419154]
arr_rew_n0_001_6 = np.array(avg_rew_n0_001_6)
arr_fac_n0_001_6 = np.array(far_fac_n0_001_6)
avg_rew_n0_003_6 = [1.410158, 0.909000, 1.651516, 1.287044]
far_fac_n0_003_6 = [0.956484, 0.822826, 0.819560, 0.467202]
arr_rew_n0_003_6 = np.array(avg_rew_n0_003_6)
arr_fac_n0_003_6 = np.array(far_fac_n0_003_6)
avg_rew_n0_010_6 = [1.315731, 1.050179, 1.032788, 1.500196]
far_fac_n0_010_6 = [0.967369, 0.814782, 0.675622, 0.427621]
arr_rew_n0_010_6 = np.array(avg_rew_n0_010_6)
arr_fac_n0_010_6 = np.array(far_fac_n0_010_6)
avg_rew_n0_030_6 = [1.241286, 1.027898, 1.020290, 1.284695]
far_fac_n0_030_6 = [0.970896, 0.936878, 0.684469, 0.672912]
arr_rew_n0_030_6 = np.array(avg_rew_n0_030_6)
arr_fac_n0_030_6 = np.array(far_fac_n0_030_6)
avg_rew_n0_100_6 = [1.178328, 0.888566, 0.783645, 1.110999]
far_fac_n0_100_6 = [0.983472, 0.896471, 0.777281, 0.432064]
arr_rew_n0_100_6 = np.array(avg_rew_n0_100_6)
arr_fac_n0_100_6 = np.array(far_fac_n0_100_6)
avg_rew_n0_300_6 = [1.015847, 0.905907, 0.972357, 1.304118]
far_fac_n0_300_6 = [0.975151, 0.942194, 0.832952, 0.741931]
arr_rew_n0_300_6 = np.array(avg_rew_n0_300_6)
arr_fac_n0_300_6 = np.array(far_fac_n0_300_6)
avg_rew_n1_000_6 = [0.975093, 0.810502, 0.837877, 1.194238]
far_fac_n1_000_6 = [0.979581, 0.941336, 0.927866, 0.756334]
arr_rew_n1_000_6 = np.array(avg_rew_n1_000_6)
arr_fac_n1_000_6 = np.array(far_fac_n1_000_6)

arr_rew = [arr_rew_n0_000_2,
           arr_rew_n0_001_2,
           arr_rew_n0_003_2,
           arr_rew_n0_010_2,
           arr_rew_n0_030_2,
           arr_rew_n0_100_2,
           arr_rew_n0_300_2,
           arr_rew_n1_000_2]
arr_fac = [arr_fac_n0_000_2,
           arr_fac_n0_001_2,
           arr_fac_n0_003_2,
           arr_fac_n0_010_2,
           arr_fac_n0_030_2,
           arr_fac_n0_100_2,
           arr_fac_n0_300_2,
           arr_fac_n1_000_2]

best_rwg = []
aver_rwg = []

for i, (l, n) in enumerate(zip(arr_rew, arr_fac)):    
    aver_rwg.append(np.mean(l))
    print("\n ---> Best rewards and fairness for quantum noise = {}".format(q_noise[i]))
    copy_rew = copy.deepcopy(l)
    sorted_array = np.sort(copy_rew)[::-1]    
    best_rwg.append(sorted_array[0])
    for rewi in sorted_array:
        id_rew = np.where(rewi == l)
        id_fac = n[id_rew[0][0]]
        hypara = para[id_rew[0][0]]
        print("Average reward = {:.6f}. Fairness factor = {:.6f}. A1 = {}. A2 = {}. B1 = {}. B2 = {}.".format(rewi, id_fac, hypara[1], hypara[2], hypara[3], hypara[4]))

bestbest = np.max(best_rwg)
id_best  = np.where(best_rwg == bestbest)
id_rew   = np.where(arr_rew[id_best[0][0]] == bestbest)
hypara = para[id_rew[0][0]]
print("\nBest average rewards = {}. Quantum noise = {}. A1 = {}. A2 = {}. B1 = {}. B2 = {}.".format(best_rwg[id_best[0][0]], q_noise[id_best[0][0]], hypara[1], hypara[2], hypara[3], hypara[4]))

fig0, axs = plt.subplots(1,2,figsize=(20,8))
axs[0].set_title("Best Reward vs Quantum Noise")
axs[0].plot(q_noise, best_rwg, marker="o")
axs[0].set_xlabel("Quantum Noise")
axs[0].set_ylabel("Best Reward")
#axs[0].set_ylim(0,10)

axs[1].set_title("Avg Reward vs Quantum Noise")
axs[1].plot(q_noise, aver_rwg, marker="o")
axs[1].set_xlabel("Quantum Noise")
axs[1].set_ylabel("Avg Reward")
#axs[1].set_ylim(0,10)
plt.show()