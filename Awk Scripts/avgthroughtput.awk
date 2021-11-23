#Code by S Jyothsna
#Reg No :123003243
#Name of Faculty : Dr. SasikalaDevi 

#average throughput awk file for  -new trace format
#--------------->Data transmission, network throughput is the amount of data moved successfully from one place to another in a given time period, and typically measured in bits per second (bps)
BEGIN {
        #receiver size ,start time,stop time,no of recived packets
	recv_size=0
	startt=9999999999
	stopt=0
	nopackrecv=0
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
		seqno=$11
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
		seqno = $11
	}


if(packet=="AGT" && sendTime[pkt_id] == 0 && (event == "+" || event == "s")) {
	if (time < startt) {
		startt=time
	}
	sendTime[pkt_id] = time
	this_flow=flow_type
}

if(packet=="AGT" && event == "r") {
	if(time >stopt) {
		stopt=time
	}
	recv_size += packetsize
	recvTime[pkt_id] = time
	nopackrecv = nopackrecv + 1
}
}

END {
	if (nopackrecv ==0) {
		printf("No packets received \n")
	}
	printf("start Time -------%d\n", startt)
	printf("stop Time---- %d\n", stopt)
	printf("received Packets----- %d\n", nopackrecv)
	printf("throughput (Kbps) is-------- %f \n", (recv_size/(stopt-startt)*(8/1000)))		
}
