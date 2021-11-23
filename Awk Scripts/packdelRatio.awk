#Code by S Jyothsna
#Reg No :123003243
#Name of Faculty : Dr. SasikalaDevi 
#packet Delivery Ratio
BEGIN {
	sendPkt =0
	recvPkt=0
	forwardPkt=0
}

{


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


if(event =="s" && packet == "AGT") {
	sendPkt++;
}

if(event =="r" && packet == "AGT") {
	recvPkt++;
}

if(event =="f" && packet == "RTR") {
	forwardPkt++;
}

}

END {
	printf ("the sent packets are %d \n", sendPkt);
	printf ("the received packets are %d \n", recvPkt);
	printf ("the forwarded packets are %d \n", forwardPkt);
	printf ("Packet Delivery Ratio is %f \n", (recvPkt/sendPkt));

	
}

