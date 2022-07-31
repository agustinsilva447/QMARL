#import nistrng, numpy
from time import sleep

def config(div = 4, rule= 1771476585, fb = 6, sync= 0, test = 0, clear= 0, set=0):
	app("connect -s 192.168.1.10:7")
	app('set debug true')
	app('x_write_reg 6 0')
	#Reduce clock frequency by factor of 8
	app('x_write_reg 11 1')
	app(f'x_write_reg 10 {div}')
	app('x_write_reg 11 0')
	# reset cell
	app('x_write_reg 5 1')
	# clear ofifo
	app('x_write_reg 21 1')
	app('x_write_reg 21 0')
	# clear ififo
	app('x_write_reg 17 1')
	app('x_write_reg 17 0')
	# clear fifo through loopback reg
	app('x_write_reg 7 1')
	app('x_write_reg 7 0')
	#test disable
	app(f'x_write_reg 9 {test}')
	# write rule
	app(f'x_write_reg 8 {rule}')
	# set fb_type
	app(f'x_write_reg 0 {fb}')
	# set sync
	app(f'x_write_reg 1 {sync}')
	# clear cell
	app(f'x_write_reg 2 {clear}')
	# set cell
	app(f'x_write_reg 3 {set}')
	# reset cell
	app('x_write_reg 5 0')
	# fifo write enable
	app('x_write_reg 6 1')
	# disable log
	app('log 0')

def get_data(N, s= 0.1, filename= 'out.txt', tries= 5):
	N_dat = N
	print(f'Requesting: {N_dat} values')
	while N_dat > 0 and tries > 0:
		result = app(f'x_read_fifo 4000 -f {filename} -r b')
		if result.stderr :
			print(result.stderr)
		N_dat -= int(result.data[0][1]) if int(result.data[0][1]) <= N else N_dat
		print(f'Ndat: {N_dat} - received {result.data[0][1]}')
		if result.data[0][1] < 1 or result.data[0][1] > N :
			tries -= 1
		sleep(s)
		N = N_dat

def txt2bin(filename= 'out.txt'):
	with open(filename, 'r') as txt_file:
		with open(filename[:-4]+'.bin' , 'wb') as bin_file:
			temp = txt_file.readline().replace('\'','').replace('[','').replace(']',' ').replace('0b','').replace(',','').split()
			bins = [int(x,2).to_bytes(4, 'big') for x in temp]
			bin_file.write(b''.join(bins))

config(rule= 1771476585)
get_data(320000)
txt2bin()

