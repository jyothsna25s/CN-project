#Code by S Jyothsna
#Reg No :123003243
#Name of Faculty : Dr. SasikalaDevi 


#     Simulation parameters setup

set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     12                         ;# number of mobilenodes
set val(rp)   DSDV                  ;# routing protocol
set val(x)      1000                      ;# X dimension of topography
set val(y)      1000                   ;# Y dimension of topography
set val(stop)   15.0                         ;# time of simulation end


#        Initialization        

#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open Dsdv2.tr w]
$ns trace-all $tracefile
$ns use-newtrace
#Open the NAM trace file
set namfile [open Dsdv2.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel


#     Mobile node parameter setup

$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -energyModel   "EnergyModel" \
                -initialEnergy   50.0  \
                -txPower  0.9  \
                -rxPower  0.7  \
                -idlePower  0.6  \
                -sleepPower  0.1  \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON


#        Nodes Definition        

#Create 11 nodes
set n0 [$ns node]
$n0 set X_ 995
$n0 set Y_ 556
$n0 set Z_ 0.0
$ns initial_node_pos $n0 30
set n1 [$ns node]
$n1 set X_ 482
$n1 set Y_ 637
$n1 set Z_ 0.0
$ns initial_node_pos $n1 30
set n2 [$ns node]
$n2 set X_ 549
$n2 set Y_ 950
$n2 set Z_ 0.0
$ns initial_node_pos $n2 30
set n3 [$ns node]
$n3 set X_ 708
$n3 set Y_ 473
$n3 set Z_ 0.0
$ns initial_node_pos $n3 30
set n4 [$ns node]
$n4 set X_ 233
$n4 set Y_ 949
$n4 set Z_ 0.0
$ns initial_node_pos $n4 30
set n5 [$ns node]
$n5 set X_ 354
$n5 set Y_ 555
$n5 set Z_ 0.0
$ns initial_node_pos $n5 30
set n6 [$ns node]
$n6 set X_ 432
$n6 set Y_ 362
$n6 set Z_ 0.0
$ns initial_node_pos $n6 30
set n7 [$ns node]
$n7 set X_ 587
$n7 set Y_ 512
$n7 set Z_ 0.0
$ns initial_node_pos $n7 30
set n8 [$ns node]
$n8 set X_ 456
$n8 set Y_ 471
$n8 set Z_ 0.0
$ns initial_node_pos $n8 30
set n9 [$ns node]
$n9 set X_ 248
$n9 set Y_ 174
$n9 set Z_ 0.0
$ns initial_node_pos $n9 30
set n10 [$ns node]
$n10 set X_ 388
$n10 set Y_ 272
$n10 set Z_ 0.0
$ns initial_node_pos $n10 30
set n11 [$ns node]
$n11 set X_ 475
$n11 set Y_ 985
$n11 set Z_ 0.0
$ns initial_node_pos $n11 30

#time,distance,dest cord,velocity,
#last parameter is velocity 25

$ns at 0.5 "$n0 setdest 400.0 300.0 25.0"
$ns at 0.0 "$n1 setdest 500.0 30.0 25.0"
$ns at 0.7 "$n2 setdest 500.0 100.0 20.0"
$ns at 0.5 "$n3 setdest 480.0 400.0 26.0"
$ns at 0.0 "$n4 setdest 300.0 500.0 5.0"
$ns at 0.0 "$n5 setdest 102.0 200.0 30.0"
$ns at 0.5 "$n6 setdest 100.0 600.0 17.0"
$ns at 0.5 "$n7 setdest 700.0 300.0 25.0"
$ns at 0.0 "$n8 setdest 134.0 30.0 25.0"
$ns at 0.7 "$n9 setdest 656.0 600.0 20.0"
$ns at 0.5 "$n10 setdest 675.0 400.0 26.0"
$ns at 0.0 "$n11 setdest 500.0 30.0 5.0"


#        Agents Definition        

#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n1 $sink3
$ns connect $tcp0 $sink3
$tcp0 set packetSize_ 1500

#Setup a TCP connection
set tcp1 [new Agent/TCP]
$ns attach-agent $n10 $tcp1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n9 $sink2
$ns connect $tcp1 $sink2
$tcp1 set packetSize_ 1500


#        Applications Definition        

#Setup a cbr Application over TCP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 2.0Mb
$cbr0 set random_ 2
$ns at 1.0 "$cbr0 start"
$ns at 15.0 "$cbr0 stop"

#Setup a cbr Application over TCP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $tcp1
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 2.0Mb
$cbr1 set random_ 2
$ns at 1.0 "$cbr1 start"
$ns at 15.0 "$cbr1 stop"

#        Termination        

#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam Dsdv2.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at 0.5 "$ns trace-annotate \"Starting CBR0 node0 to node1\"" 
$ns at 0.5 "$ns trace-annotate \"Starting CBR1 node10 to node9\"" 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run


