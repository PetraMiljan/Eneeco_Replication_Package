*===================================================================
* Paper Zagreb 2025
* Álvaro García-Cerezo, Petra Miljan, Hrvoje Pandzic
* Out-of-sample analysis modifying the confidence level (alphaCVaR)
*===================================================================

*$ontext
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
*$offtext

* Load data
$include data.gms
$include data_set2.gms
$include data_set3.gms
$include data_imbalance.gms

* Load variables
$include variables.gms

* Load equations
$include equations.gms

* Options of the solver
*OPTIONS  optcr = 0, optca = 0, lp = cplex, mip = cplex;
*OPTIONS  optcr = 1e-4, optca = 1e-4, lp = cplex, mip = cplex;
*OPTIONS  optcr = 1e-2, optca = 1e-2, lp = gurobi, mip = gurobi;
*OPTIONS  optcr = 5e-2, optca = 5e-2, lp = gurobi, mip = gurobi;
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

proposedProblem.optfile = 1;
proposedProblemOA.optfile = 1;

LOOP(itAlpha$(ord(itAlpha) <= card(itAlpha)),

* ==========================
*   Solution of the problem
* ==========================

    ScenActS(s) = no;
    ScenActX(xi) = no;

    AlphaCVAR = AlphaCVARvector(itAlpha);
    DISPLAY AlphaCVAR;
    
    ScenActS(s)$S2(s) = yes;
    ScenActX(xi)$X2(xi) = yes;
    ProbS(s) = ProbSSet2(s);
    ResRIBmax(t,s) = ResRIBmaxSet2(t,s);
    
    SOLVE proposedProblem maximizing ofPROP using mip;
    DISPLAY ofPROP.L;
    
    mpDAfix(t) = mpDA.L(t);
    chBDAfix(t) = chBDA.L(t);
    disBDAfix(t) = disBDA.L(t);
    elEDAfix(t) = elEDA.L(t);
    mpDAfixMatrix(t,itAlpha) = mpDA.L(t);    
    DISPLAY mpDA.L, mpDAfix, mpDAfixMatrix;   

* =======================================
*   Out-of-sample analysis - First stage
* =======================================

*   Fix DA bidding decisions and solve the problem for each scenario within S2
    
    LOOP(s$(ord(s) <= card(S2)),
        
        v(s) = no;
        v(s) = yes;
        SOLVE proposedProblemOA maximizing ofPROPoa using mip;
        DISPLAY ofPROPoa.L;

* ========================================
*   Out-of-sample analysis - Second stage
* ========================================

*   Now the profit of each scenario s and xi is computed, being s associated with the set S2 and xi with X3.

        LOOP(xi$X3(xi),

            ProfitScen(v,xi,itAlpha) = sum(t, LambdaDA(t) * mpDAfix(t) + LambdaH(t) * chiHIB.L(t,s) - LambdaW(t) * EtaW * chiHIB.L(t,s)        
                + LambdaDA(t) * dIB.L(t,s) * ( 1 + KIB * ImbalanceDev(xi,t) ) );
                
        );
        
        v(s) = no;
        
    );
        
);

LOOP(t,LOOP(itAlpha,IF(mpDAfixMatrix(t,itAlpha) eq 0,mpDAfixMatrix(t,itAlpha) = 1e-6)));
DISPLAY mpDAfixMatrix;

LOOP(s$S2(s),LOOP(xi$X3(xi),LOOP(itAlpha,IF(ProfitScen(s,xi,itAlpha) eq 0,ProfitScen(s,xi,itAlpha) = 1e-6))));
DISPLAY ProfitScen;

LOOP(itAlpha,IF(AlphaCVARvector(itAlpha) eq 0,AlphaCVARvector(itAlpha) = 1e-6));
DISPLAY AlphaCVARvector;

execute_unload 'results_OA_S2_X3.gdx' mpDAfixMatrix, ProfitScen, AlphaCVARvector;
