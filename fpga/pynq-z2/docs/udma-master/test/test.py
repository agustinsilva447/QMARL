import tqdm, math

def getsize(filename):
    """Get the size of a file

    Parameters
    ----------
    filename : file
    The file from which we want to get the size in lines

    Returns
    -------
    int
    The number of lines in the file
    """
    count = 0
    for line in open(filename).readlines(): count += 1
    return count
filename = "test_ram.txt" 
filesize = getsize(filename)
with open(filename, "r") as f:
    print('start cycle?')
    for i in tqdm.trange(math.ceil(filesize/100)):
        print(i)
        address, data = list(zip(*[f.readline().split(',') for x in range((filesize%100) if (filesize-i*100) < 100 else 100)]))
        print([int(d, 10) for d in address], [int(d, 10) for d in data])


