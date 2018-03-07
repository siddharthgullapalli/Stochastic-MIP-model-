set pallet;
set machine;
set part;
set scenario;

param prob{s in scenario}; # probability of scenario
param tt{f in pallet}; #totaltime to load and unload the parts 
param mt{i in machine,j in part}; # machining time on part
param imp{j in part}; #importance of each part
param h{i in machine, s in scenario}; #capacity of machine in each scenario
param dem{j in part, s in scenario}; #demand of part in each scenario
param buff{i in machine}; #maximum number of pallets that can be assigned to a machine
param np{f in pallet}; #number of parts that are fixed on the pallet
param M{f in pallet, j in part}; #binary matrix
param B{f in pallet, i in machine}; #binary matrix
param tfix{f in pallet, i in machine}; #machining time to process all the parts on the pallet in the machine 

var x{pallet,machine} binary; # variable to determine to which machine a pallet in assigned 
var loads{pallet,machine,scenario} >=0 integer; # variable to determine the number of times that a pallet is loaded with a part on a machine in a scenario
var ys{machine,part,scenario} >=0 integer; #no of products to be produced on a machine in a scenario
var zs{part,scenario} >=0 integer; #no of products which are late in a scenario

minimize late: sum{s in scenario, j in part} prob[s]*imp[j]*zs[j,s]; #minimizing the weighted number of late parts

subject to c1{f in pallet}: sum{i in machine} x[f,i] = 1; # each pallet is must be assigned to one machine
subject to c2{f in pallet,i in machine}: x[f,i] <= B[f,i]; #possible assignments of the pallets to the machines
subject to c3{i in machine}: sum{f in pallet}x[f,i]<=buff[i]; #the maximum number of pallets assigned to each machine
subject to c5{j in part, s in scenario}: sum{i in machine}ys[i,j,s] + zs[j,s]>= dem[j,s]; #The demand must be satisfied by the production
subject to c6{f in pallet,i in machine, s in scenario}: loads[f,i,s]<=x[f,i]*1000; # a pallet can be loaded in a machine only if it has been assigned to that machine
subject to c7{i in machine, j in part, s in scenario}: ys[i,j,s] = sum{f in pallet}loads[f,i,s]*np[f]*M[f,j];
subject to c8{s in scenario}: sum{f in pallet, i in machine}loads[f,i,s]*tt[f]<= 480;
subject to c9{i in machine, s in scenario}: sum{j in part}mt[i,j]*ys[i,j,s]<= h[i,s];
subject to c10{f in pallet, s in scenario}: sum{i in machine}loads[f,i,s]*tfix[f,i] +sum{i in machine}loads[f,i,s]*tt[f]<=480;
