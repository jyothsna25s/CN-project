#Code by S Jyothsna
#Reg No :123003243
#Name of Faculty : Dr. SasikalaDevi 
#residual energy of node--->remaining  energy after the greater part or quantity has sent.

#plot "energy.csv" using 1:2 with linespoints title "AODV","energy.csv"
#using 1:3 with linespoints title "DSR","energy.csv" using 1:4 with linespoints title "DSDV"

BEGIN {
	i=0
	n=0
	totalEnergy=0.0
	availEner[s] = initenergy;
}

{



event = $1
time =$3
node_id=$5
energy_value= $7
packet=$19
pkt_id=$41
pkt_type=$35

if(event == "N"){
	for(i=0;i<21;i++) {
		if(i==node_id) {
			availEner[i] = availEner[i]-(availEner[i] - energy_value);
# i = node #  availEner[i] =energy available for that node 
		}
	}
}
}

END {
for(i=0;i<21;i++) {
	printf(" %d %f \n",i,availEner[i]);
totalEnergy = totalEnergy + availEner[i];
if(availEner[i] !=0)
n++
}
#printf("the total Residual energy of the network is %f \n",totalEnergy);

}

