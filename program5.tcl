set ns [new Simulator -multicast on] 
 
set tf [open mcast.tr w] 
$ns trace-all $tf 
 
set fd [open mcast.nam w] 
$ns namtrace-all $fd 

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node] 
 
# Create links 
$ns duplex-link $n0 $n2 1.5Mb 10ms DropTail 
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail 
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail 
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail 
$ns duplex-link $n3 $n7 1.5Mb 10ms DropTail 
$ns duplex-link $n4 $n5 1.5Mb 10ms DropTail 
$ns duplex-link $n4 $n6 1.5Mb 10ms DropTail 
 
set mproto DM 
set mrthandle [$ns mrtproto $mproto {}] 
 
set group1 [Node allocaddr] 
set group2 [Node allocaddr] 
 
set udp0 [new Agent/UDP] 
$ns attach-agent $n0 $udp0 
$udp0 set dst_addr_ $group1 
$udp0 set dst_port_ 0 
set cbr1 [new Application/Traffic/CBR] 
$cbr1 attach-agent $udp0 
 
# Transport agent for the traffic source 
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1 
$udp1 set dst_addr_ $group2 
$udp1 set dst_port_ 0 
set cbr2 [new Application/Traffic/CBR] 
$cbr2 attach-agent $udp1 
 
set rcvr1 [new Agent/Null] 
$ns attach-agent $n2 $rcvr1 
$ns at 1.0 "$n2 join-group $rcvr1 $group1" 
 
set rcvr2 [new Agent/Null] 
$ns attach-agent $n3 $rcvr2 
$ns at 1.5 "$n3 join-group $rcvr2 $group1" 
 
set rcvr3 [new Agent/Null] 
$ns attach-agent $n4 $rcvr3 
$ns at 2.0 "$n4 join-group $rcvr3 $group1" 
 
set rcvr4 [new Agent/Null] 
$ns attach-agent $n5 $rcvr4 
$ns at 2.5 "$n5 join-group $rcvr4 $group2" 
 
set rcvr5 [new Agent/Null] 
$ns attach-agent $n6 $rcvr5
$ns at 3.0 "$n6 join-group $rcvr5 $group2"
 
set rcvr6 [new Agent/Null] 
$ns attach-agent $n7 $rcvr6 
$ns at 3.5 "$n7 join-group $rcvr6 $group2" 
 
$ns at 4.0 "$n2 leave-group $rcvr1 $group1" 
$ns at 4.5 "$n3 leave-group $rcvr2 $group1" 
$ns at 5.0 "$n4 leave-group $rcvr3 $group1" 
 
$ns at 5.5 "$n5 leave-group $rcvr4 $group2" 
$ns at 6.0 "$n6 leave-group $rcvr5 $group2" 
$ns at 6.5 "$n7 leave-group $rcvr6 $group2" 
 
$ns at 0.5 "$cbr1 start" 
$ns at 9.5 "$cbr1 stop" 
 
$ns at 0.5 "$cbr2 start" 
$ns at 9.5 "$cbr2 stop" 
$ns at 10.0 "finish" 

proc finish {} { 
        global ns tf fd 
        $ns flush-trace 
        close $tf 
        close $fd 
        exec nam mcast.nam & 
        exit 0 
}   
$n0 label "Source 1" 
$n1 label "Source 2" 
 
$ns color 1 red 
$ns color 2 green 
 
$n2 label "Receiver 1" 
$n2 color blue 
$n3 label "Receiver 2" 
$n3 color blue 
$n4 label "Receiver 3" 
$n4 color blue 
$ns run 
