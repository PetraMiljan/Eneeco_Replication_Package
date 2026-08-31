*===================================================================
* Paper Zagreb 2025
* Álvaro García-Cerezo, Petra Miljan, Hrvoje Pandzic
* Out-of-sample analysis modifying the uncertainty budget (GammaIB)
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

hybridsproProblem.optfile = 1;
hybridsproProblemOA.optfile = 1;

execute_load 'resultsHybridSPRO_Gamma.gdx' mpDAfixMatrixGamma;


LOOP(xi$(ord(xi) <= card(X2)),

* ==========================
*   Solution of the problem
* ==========================

    ScenActS(s) = no;
    ScenActX(xi) = no;

    GammaIBscalar = GammaIBvector(xi);
    DISPLAY GammaIBscalar;
    
    ScenActS(s)$S2(s) = yes;
    ScenActX(xi)$X2(xi) = yes;
    ProbS(s) = ProbSSet2(s);
    ResRIBmax(t,s) = ResRIBmaxSet2(t,s);
    
    mpDA.fx(t) = mpDAfixMatrixGamma(t,xi);
    
    SOLVE hybridsproProblem maximizing ofHSPRO using mip;
    DISPLAY GammaIBscalar, mpDA.L, ofHSPRO.L;
    
    mpDAfix(t) = mpDAfixMatrixGamma(t,xi);
    chBDAfix(t) = chBDA.L(t);
    disBDAfix(t) = disBDA.L(t);
    elEDAfix(t) = elEDA.L(t);
    DISPLAY mpDA.L, mpDAfix;   

* =======================================
*   Out-of-sample analysis - First stage
* =======================================

*   Fix DA bidding decisions and solve the problem for each scenario within S3

    ResRIBmax(t,s) = ResRIBmaxSet3(t,s);
    
    LOOP(s$(ord(s) <= card(S3)),
        
        v(s) = no;
        v(s) = yes;
        SOLVE hybridsproProblemOA maximizing ofHSPROoa using mip;
        DISPLAY ofHSPROoa.L;

* ========================================
*   Out-of-sample analysis - Second stage
* ========================================

*   Now the profit of each scenario s and xi is computed, being s associated with the set S3 and xi with X3.

        LOOP(xixi$X3(xixi),

            ProfitScenHybrid(v,xi,xixi) = sum(t, LambdaDA(t) * mpDAfix(t) + LambdaH(t) * chiHIB.L(t,s) - LambdaW(t) * EtaW * chiHIB.L(t,s)        
                + LambdaDA(t) * dIB.L(t,s) * ( 1 + KIB * ImbalanceDev(xixi,t) ) );
                
        );
        
        v(s) = no;
        
    );

);

LOOP(s$S3(s),LOOP(xi$X2(xi),LOOP(xixi$X3(xixi),IF(ProfitScenHybrid(s,xi,xixi) eq 0,ProfitScenHybrid(s,xi,xixi) = 1e-6))));
DISPLAY ProfitScenHybrid;

LOOP(xi$X2(xi),IF(GammaIBvector(xi) eq 0,GammaIBvector(xi) = 1e-6));
DISPLAY GammaIBvector;

execute_unload 'results_OA_hybrid.gdx' mpDAfixMatrixGamma, ProfitScenHybrid, GammaIBvector;
