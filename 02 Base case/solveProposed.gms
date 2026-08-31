*====================================================
* Paper Zagreb 2025
* Álvaro García-Cerezo, Petra Miljan, Hrvoje Pandzic
* Solution of the proposed problem 
*====================================================

$ontext
* Turn off the listing of the input file
$offlisting
* Turn off the listing and cross-reference of the symbols used
$offsymxref offsymlist
option
* equations listed per block (default = 3)
limrow = 0,
* variables listed per block (default = 3)
limcol = 0,
* solver's solution output printed
solprint = off,
* solver's system output printed
sysout = off;
$offtext

* Load data
$include data.gms
$include data_set2.gms
$include data_set3.gms
*$include data_imbalance.gms

* Load variables
$include variables.gms

* Load equations
$include equations.gms

* Options of the solver
*OPTIONS  optcr = 0, optca = 0, lp = cplex, mip = cplex;
*OPTIONS  optcr = 1e-4, optca = 1e-4, lp = cplex, mip = cplex;
*OPTIONS  optcr = 1e-2, optca = 1e-2, lp = gurobi, mip = gurobi;
OPTIONS  optcr = 1e-2, optca = 1e-2, lp = gurobi, mip = gurobi;

file opt gurobi option file /gurobi.opt/;
put opt;
put '';
*put 'method 2';
*put 'IntFeasTol 1e-9';
put 'threads 56';
putclose;
*$offtext

file outopt /cplex.opt/;
put outopt;
put "ParallelMode -1"/;
put "threads 56"/;
put "solvefinal 0"/;
putclose outopt;

proposedProblem.optfile=1;

SCALAR MPprofit;

ScenActS(s) = no;
ScenActX(xi) = no;

*$ontext
ScenActS(s)$S2(s) = yes;
ScenActX(xi)$X2(xi) = yes;
ProbS(s) = ProbSSet2(s);
ResRIBmax(t,s) = ResRIBmaxSet2(t,s);
*$offtext

$ontext
ScenActS(s)$S3(s) = yes;
ScenActX(xi)$X2(xi) = yes;
ProbS(s) = 1/card(S3);
display ProbS;
ResRIBmax(t,s) = ResRIBmaxSet3(t,s);
$offtext

AlphaCVAR = 0.999;
SOLVE proposedProblem maximizing ofPROP using mip;
DISPLAY AlphaCVAR, ofPROP.L;
MPprofit = sum(t, LambdaDA(t) * mpDA.L(t) );          
DISPLAY MPprofit, mpDA.L;

execute_unload 'resultsProposed'
* VARIABLES =======================================
chiHIB.L
phiVAR.L
dIB.L
ofPROP.L
y.L
thetaCVAR.L
deltaXI.L
muPlus.L
muMinus.L
chBDA.L
chBIBplus.L
chBIBminus.L
disBDA.L
disBIBplus.L
disBIBminus.L
elEDA.L
elEIB.L
elEIBplus.L
elEIBminus.L
elHatEIB.L
mpDA.L
rIB.L
resRDA.L
resRIB.L
soeBDA.L
soeBDAseg.L
soeBIB.L
soeBIBseg.L
zXI.L
xPlus.L
xMinus.L
xBDA.L
xBIB.L
xEIB.L
* PARAMETERS ======================================
AlphaCVAR
BetaE
DeltaT
ZetaH
EtaB
EtaE
EtaW
ThetaH
KIB
M
PBmax
PEmax
PGRIDmax
SoeBini
SoeBend
SoeBmax
GammaIBvector
LambdaDA
LambdaH
LambdaW
FB
RB
ProbS
ProbX
ResRDAmax
ResRIBmax
SoeBiniSeg
MPprofit
;

SCALAR MPprofit;
MPprofit = sum(t, LambdaDA(t) * mpDA.L(t) );
                
DISPLAY MPprofit;
*$offtext
