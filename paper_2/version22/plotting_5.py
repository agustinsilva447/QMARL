import numpy as np
import matplotlib.pyplot as plt

q_noise = [0, 1/1024, 1/512, 1/256, 1/128, 1/64, 1/32, 1/16, 1/8, 1/4, 1/2, 1]

Rewards_5_1  = [0.7138874720071647, 1.7180239585248376, 1.20415860228492, 1.3522141893930777, 1.4247824771682063, 1.5062401298748975, 1.5292883228900598, 1.8003468882780853, 1.7574154471761647, 1.2543596127854144, 1.6153025377622705, 1.2951831343491091]
Fairness_5_1 = [0.21210096355735242, 0.7998358347005554, 0.8069624066152012, 0.6975426070613087, 0.7574707741832158, 0.6611205688930031, 0.7529912703783647, 0.8186463366857807, 0.8408207645952672, 0.7804568627722289, 0.9254943134121503, 0.8832379491281539]
Rewards_5_2  = [0.9211632097081248, 0.6808228614807679, 1.709106388473887, 1.380813067457816, 1.2651564258875123, 1.458183114880229, 1.6098488965413422, 1.3085613338380986, 1.667651003035068, 1.6388801683307168, 1.7237836966346143, 1.367536146576556]
Fairness_5_2 = [0.22439906461371756, 0.802654412517444, 0.522055928411224, 0.7185211580626555, 0.8458561288010477, 0.9051718248891545, 0.7884231083066777, 0.8000498166351783, 0.9323834938640838, 0.7759460746036034, 0.9803277892379392, 0.9006039428769719]
Rewards_5_3  = [0.4360574321971136, 1.841051043876292, 1.1185700346581737, 1.9848078075207993, 1.436375723129731, 1.3025215099055718, 1.6547531635061687, 1.6708218670921928, 1.436161764588261, 1.745916073152796, 1.675177504292021, 1.4213576187087973]
Fairness_5_3 = [0.424102221499569, 0.7100659492656886, 0.7761982488128448, 0.6353229874401648, 0.8161116955647147, 0.8969979187549126, 0.8476006257596631, 0.7737379422447034, 0.9721867089166824, 0.9058240699952058, 0.9377320872584114, 0.9649289466091604]
Rewards_5_4  = [6.450810319835602, 1.725166482813567, 1.3995352300086723, 1.926685147321611, 1.8169811955314075, 1.748158054040599, 1.2353786692808408, 1.5597295438452212, 1.3771759162565809, 1.6235078564643333, 1.6143023096539426, 1.486660895083313]
Fairness_5_4 = [0.5147632871304582, 0.7749913995694475, 0.8653806009568858, 0.5991997825290136, 0.7023695698140581, 0.8172143683248567, 0.7787339298478932, 0.8740592116071348, 0.7447283455910112, 0.8751776925910376, 0.9693153202378584, 0.8988397022445789]
Rewards_5_5  = [1.692603076262443, 2.2794314153678887, 1.4651175270209387, 1.6043275617928956, 1.488525342871814, 1.6883970395903787, 1.1842068595688044, 1.6000058115596292, 2.078359438979607, 1.5764281155467867, 1.3594009018311906, 1.358383404217883]
Fairness_5_5 = [0.2270037670067972, 0.6749267207990691, 0.6651213402974877, 0.7303767142281052, 0.8615949515102561, 0.7267304861318167, 0.6124320382372994, 0.7632614685064557, 0.9057166058486559, 0.9733204953217682, 0.9090413387788605, 0.8766210615103757]

rewa_5 = [Rewards_5_1,
          Rewards_5_2,
          Rewards_5_3,
          Rewards_5_4,
          Rewards_5_5]
rew_5 = np.mean(rewa_5, axis=0)

fair_5 = [Fairness_5_1,
          Fairness_5_2,
          Fairness_5_3,
          Fairness_5_4,
          Fairness_5_5]
fai_5 = np.mean(fair_5, axis=0)

max = 0
arg = 0
for i in rewa_5:
    if np.max(i)>max:
        max = np.max(i)
        arg = np.argmax(i)
print("Maximum average reward = {:.3f} for quantum noise with $\gamma$ = {}.".format(max,q_noise[arg]))
"""
fig0, axs = plt.subplots(1,2,figsize=(20,8))
fig0.suptitle("Reward and fairness vs quantum noise.", fontsize=16)
axs[0].set_title("Reward vs quantum noise")
axs[0].plot(q_noise, rew_5,"o-")
axs[0].set_xlabel("Quantum noise")
axs[0].set_ylabel("Average reward")
axs[1].set_title("Fairness vs quantum noise")
axs[1].plot(q_noise, fai_5,"o-")
axs[1].set_xlabel("Average Fairness")
axs[1].set_ylabel("Quantum noise")
plt.show()
"""
plt.title("Reward vs quantum noise (5 players)")
plt.plot(q_noise, rew_5, "o-", label = "noisy")
plt.axhline(y = rew_5[0], color = 'r', linestyle = 'dashed', label = "noiseless")
plt.xlabel("Quantum noise")
plt.ylabel("Average reward")
plt.legend(loc="upper right")
plt.show()