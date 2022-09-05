def minority_variant(output):
    # Minority game variant (only 1s)  
    reward = [0 for i in range(len(output))]
    if (output.count('1') == 1):
        reward[output.find('1')] = 10
    return reward
    """
    Rqc0 = Rq0 / Rc0 = 4.9596/0.1322 = 37.515885022692885
    Rqc1 = Rq1 / Rc1 = 4.9398/0.0874 = 56.51945080091533
    Entanglement final = 0.5595300000000004
    QUANTUM WINS
    """
    
def prisoners_dilemma_1(output):
    # Prisoner's dilemma with rewards
    if output == "00":
      return [6.6, 6.6]
    elif output == "01":
      return [0, 10]
    elif output == "10":
      return [10, 0]
    elif output == "11":
      return [3.3, 3.3]
    """
    Rqc0 = Rq0 / Rc0 = 4.973115999999999/3.318461999999999 = 1.4986207465988766
    Rqc1 = Rq1 / Rc1 = 4.972915999999999/3.315261999999999 = 1.5000069376115674
    Entanglement final = 0.3070250000000008
    QUANTUM WINS
    """
    
def prisoners_dilemma_2(output):
    # Prisoner's dilemma with rewards
    if output == "00":
      return [5, 5]
    elif output == "01":
      return [-10, 30]
    elif output == "10":
      return [30, -10]
    elif output == "11":
      return [-5, -5]
    """
    Rqc0 = Rq0 / Rc0 = 9.8917/-4.8429 = -2.0425158479423486
    Rqc1 = Rq1 / Rc1 = 9.9165/-4.8629 = -2.0392152830615475
    Entanglement final = 0.6879600000000002
    QUANTUM WINS
    """
    
def deadlock_game_1(output):
    # The most beneficial action is also dominant.
    if output == "00":
      return [6.6, 6.6]
    elif output == "01":
      return [10, 0]
    elif output == "10":
      return [0, 10]
    elif output == "11":
      return [3.3, 3.3]
    """
    Rqc0 = Rq0 / Rc0 = 4.9604479999999995/6.582607999999997 = 0.7535687982635457
    Rqc1 = Rq1 / Rc1 = 4.996448/6.584607999999997 = 0.7588072061389232
    Entanglement final = 0.3031100000000008
    CLASSICAL WINS
    """

def deadlock_game_2(output):
    # The most beneficial action is also dominant.
    if output == "00":
      return [5, 5]
    elif output == "01":
      return [30, -10]
    elif output == "10":
      return [-10, 30]
    elif output == "11":
      return [-5, -5]
    """
    Rqc0 = Rq0 / Rc0 = 9.738/5.0458 = 1.9299219152562528
    Rqc1 = Rq1 / Rc1 = 10.0708/5.057 = 1.9914573858018587
    Entanglement final = 0.7351100000000003
    QUANTUM WINS
    """

def disc_game(output):
    #  Discoordination games have no pure Nash equilibria
    if output == "00":
      return [10, 0]
    elif output == "01":
      return [0, 10]
    elif output == "10":
      return [0, 10]
    elif output == "11":
      return [10, 0]
    """
    Rqc0 = Rq0 / Rc0 = 4.973/5.0682 = 0.9812162108835484
    Rqc1 = Rq1 / Rc1 = 5.027/4.9318 = 1.0193032969706801
    Entanglement final = 0.3230250000000008
    TIE !
    """

def battle_sexes(output):
    # The BoS involves elements of conflict
    if output == "00":
      return [10,7]
    elif output == "01":
      return [2,2]
    elif output == "10":
      return [0,0]
    elif output == "11":
      return [7,10]
    """
    Rqc0 = Rq0 / Rc0 = 8.4319/6.94082 = 1.2148276428433529
    Rqc1 = Rq1 / Rc1 = 8.42326/9.9116 = 0.8498385729851892
    Entanglement final = 0.6030450000000004
    QUANTUM MORE FAIR
    """

def chicken_game(output):
    # The game of chicken, also known as the hawk–dove game
    if output == "00":
      return [0,0]
    elif output == "01":
      return [-1,1]
    elif output == "10":
      return [1,-1]
    elif output == "11":
      return [-1000,-1000]
    """
    Rqc0 = Rq0 / Rc0 = -3.91944/0.0001 = -39194.399999999994
    Rqc1 = Rq1 / Rc1 = -5.88056/-0.0001 = 58805.6
    Entanglement final = 0.00531000000000033
    CLASSICAL WINS
    """

def stag_hunt(output):
    # Describes a conflict between safety and social cooperation
    if output == "00":
      return [10,10]
    elif output == "01":
      return [1,8]
    elif output == "10":
      return [8,1]
    elif output == "11":
      return [5,5]
    """
    100%|██████████| 1000000/1000000 [47:10<00:00, 353.32it/s]
    Rqc0 = Rq0 / Rc0 = 6.060816/4.99624 = 1.2130754327254094
    Rqc1 = Rq1 / Rc1 = 6.079436/4.994112 = 1.2173207168761935
    Entanglement final = 0.3768437515791964
    QUANTUM WINS
    """