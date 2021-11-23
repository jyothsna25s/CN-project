#Code by S Jyothsna
#Reg No :123003243
#Name of Faculty : Dr. SasikalaDevi 

# Average End-to-End Delay.
#---------------->End-to-end delay or one-way delay (OWD) refers to the time taken for a packet to be transmitted across a network from source to destination. It is a common term in IP network monitoring, and differs from round-trip time (RTT) in that only path in the one direction from source to destination is measured.
BEGIN {
    seqno = -1;    
    count = 0;
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

	
   if(packet == "AGT" && event == "s" && seqno < pkt_id) {
          seqno = pkt_id;
    } 

    if(packet == "AGT" && event == "s") {
          start_time[pkt_id] = time;
    } else if((flow_type== "tcp") && (event == "r")) {
        end_time[pkt_id] = time;
    } else if( event== "D" && flow_type == "tcp") {
          end_time[pkt_id] = -1;
    } 
}
END {        

   for(i=0; i<=seqno; i++) {
          if(end_time[i] > 0) {
              delay[i] = end_time[i] - start_time[i];
            #  printf("%f  %f\n", start_time[i], delay[i])
                  count++;
        }
           else
            {
                  delay[i] = -1;
            }
    }
    for(i=0; i<=seqno; i++) {
          if(delay[i] > 0) {
              e2eDelay = e2eDelay + delay[i];
        }         
   }
   e2eDelay = e2eDelay/count;

   print "\n";
    print "GeneratedPackets            = " seqno+1;
   
    print "Average End-to-End Delay    = " e2eDelay * 1000 " ms";
    print "\n";

} 

