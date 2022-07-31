filename = 'out.txt'

with open(filename, 'r') as txt_file:
	with open(filename[:-4]+'.bin' , 'wb') as bin_file:
		temp = txt_file.readline().replace('\'','').replace('[','').replace(']',' ').replace('0b','').replace(',','').split()
		bins = [int(x,2).to_bytes(4, 'big') for x in temp]
		bin_file.write(b''.join(bins))

#.to_bytes(4, 'big')