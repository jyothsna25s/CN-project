#Code by S Jyothsna
#Reg No :123003243
#Name of Faculty : Dr. SasikalaDevi 
#instant Throughput awk file for  -new trace format
#-------------------->        if the measurement is taken over a very short time interval, we are measuring the instantaneous throughpu

BEGIN {
	recvpack=0
	curtime = 0
	prevtime = 0
	timequ=0.2
}

{



# Trace line format: normal
	if ($2 != "-t") {
		event = $1
		time = $2
		if (event == "+" || event == "-") nodeno= $3
		if (event == "r" || event == "d") nodeno = $4
		flow_id = $8
		pkt_id = $12
		packetsize = $6
		flow_type= $5
		
		packet = "AGT"
	}
	# Trace line format: new
	if ($2 == "-t") {
		event = $1
		time = $3
		nodeno = $5
		flow_id = $39
		pkt_id = $41
		packetsize = $37
		flow_type= $45
		packet = $19
		
	}

if(prevtime == 0)
	prevtime = time

if (packet == "AGT" && event == "r") {
	recvpack = recvpack + packetsize
	curtime = curtime + (time-prevtime)
	if (curtime >= timequ) {
		#printf ("at time  --%f throughput --> %f \n", time,(recvpack/curtime)*(8/1000))
		printf ("%f %f \n", time,(recvpack/curtime)*(8/1000))
		recvpack=0
		curtime=0
	}
	prevtime=time
}
}
END {
printf("\n")
}

