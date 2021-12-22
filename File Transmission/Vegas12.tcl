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
set val(ifqlen) 7                         ;# max packet in ifq
set val(nn)     12                         ;# number of mobilenodes
set val(rp)     AOMDV                       ;# routing protocol
set val(x)      723                      ;# X dimension of topography
set val(y)      794                      ;# Y dimension of topography
set val(stop)   15.0                         ;# time of simulation end


#        Initialization        

#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open vegas12.tr w]
$ns trace-all $tracefile
$ns use-newtrace
#Open the NAM trace file
set namfile [open vegas12.nam w]
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

#Create 12 nodes
set n0 [$ns node]
$n0 set X_ 202
$n0 set Y_ 596
$n0 set Z_ 0.0
$ns initial_node_pos $n0 30
set n1 [$ns node]
$n1 set X_ 595
$n1 set Y_ 603
$n1 set Z_ 0.0
$ns initial_node_pos $n1 30
set n2 [$ns node]
$n2 set X_ 403
$n2 set Y_ 502
$n2 set Z_ 0.0
$ns initial_node_pos $n2 30
set n3 [$ns node]
$n3 set X_ 395
$n3 set Y_ 608
$n3 set Z_ 0.0
$ns initial_node_pos $n3 30
set n4 [$ns node]
$n4 set X_ 299
$n4 set Y_ 440
$n4 set Z_ 0.0
$ns initial_node_pos $n4 30
set n5 [$ns node]
$n5 set X_ 529
$n5 set Y_ 437
$n5 set Z_ 0.0
$ns initial_node_pos $n5 30
set n6 [$ns node]
$n6 set X_ 411
$n6 set Y_ 375
$n6 set Z_ 0.0
$ns initial_node_pos $n6 30
set n7 [$ns node]
$n7 set X_ 176
$n7 set Y_ 464
$n7 set Z_ 0.0
$ns initial_node_pos $n7 30
set n8 [$ns node]
$n8 set X_ 623
$n8 set Y_ 487
$n8 set Z_ 0.0
$ns initial_node_pos $n8 30
set n9 [$ns node]
$n9 set X_ 302
$n9 set Y_ 317
$n9 set Z_ 0.0
$ns initial_node_pos $n9 30
set n10 [$ns node]
$n10 set X_ 516
$n10 set Y_ 310
$n10 set Z_ 0.0
$ns initial_node_pos $n10 30
set n11 [$ns node]
$n11 set X_ 269
$n11 set Y_ 694
$n11 set Z_ 0.0
$ns initial_node_pos $n11 30
#time,distance,dest cord,velocity,
#last parameter is velocity 25

$ns at 0.5 "$n0 setdest 400.0 500.0 25.0"
$ns at 0.0 "$n1 setdest 500.0 100.0 25.0"
$ns at 0.7 "$n2 setdest 500.0 100.0 20.0"
$ns at 0.5 "$n3 setdest 480.0 400.0 26.0"
$ns at 0.0 "$n4 setdest 300.0 500.0 5.0"
$ns at 0.0 "$n5 setdest 102.0 200.0 30.0"
$ns at 0.5 "$n6 setdest 100.0 600.0 17.0"
$ns at 0.5 "$n7 setdest 400.0 300.0 25.0"
$ns at 0.0 "$n8 setdest 334.0 330.0 25.0"
$ns at 0.7 "$n9 setdest 656.0 600.0 20.0"
$ns at 0.5 "$n10 setdest 675.0 400.0 26.0"
$ns at 0.0 "$n11 setdest 500.0 30.0 5.0"


#        Agents Definition        

#Setup a TCP/Vegas connection
set tcp0 [new Agent/TCP/Vegas]
$ns attach-agent $n0 $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp0 $sink1
$tcp0 set packetSize_ 1500

#Setup a TCP/Vegas connection
set tcp2 [new Agent/TCP/Vegas]
$ns attach-agent $n7 $tcp2
set sink3 [new Agent/TCPSink]
$ns attach-agent $n8 $sink3
$ns connect $tcp2 $sink3
$tcp2 set packetSize_ 1500



#        Applications Definition        

#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set packetSize_ 1500
$ftp0 set rate_ 1.0Mb
$ftp0 set random_ null
$ns at 1.0 "$ftp0 start"
$ns at 10.0 "$ftp0 stop"

#Setup a FTP Application over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp2
$ftp1 set packetSize_ 1500
$ftp1 set rate_ 1.0Mb
$ftp1 set random_ null
$ns at 1.0 "$ftp1 start"
$ns at 10.0 "$ftp1 stop"
proc plotWindow {tcpSource file1} {
global ns 
set now [$ns now]
set cwnd [$tcpSource set cwnd_ ]  

puts $file1 "$now $cwnd"
$ns at [expr $now+0.1] "plotWindow $tcpSource $file1"
}
set  vegas12 [open "Vegas12.plot" w]
$ns at 0.0 "plotWindow $tcp0 $vegas12"


#        Termination        

#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam vegas12.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at 0.5 "$ns trace-annotate \"Starting FTP0 node0 to node1\"" 
$ns at 0.5 "$ns trace-annotate \"Starting FTP1 node7 to node8\"" 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
