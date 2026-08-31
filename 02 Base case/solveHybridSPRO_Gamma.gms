*===========================================================================
* Paper Zagreb 2025
* Álvaro García-Cerezo, Petra Miljan, Hrvoje Pandzic
* Solution of the hybrid stochastic programming robust optimization problem
*===========================================================================

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

hybridsproProblem.optfile=1;

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

LOOP(xi$(ord(xi) <= card(X2)),

    GammaIBscalar = GammaIBvector(xi);
    DISPLAY GammaIBscalar;

    SOLVE hybridsproProblem maximizing ofHSPRO using mip;
    ofHSPROvector(xi) = ofHSPRO.L;
    mpDAfixMatrixGamma(t,xi) = mpDA.L(t); 
    DISPLAY GammaIBscalar, mpDA.L, mpDAfixMatrixGamma ofHSPRO.L, ofHSPROvector;
    
    timePropGamma(xi) = hybridsproProblem.resUsd;
    DISPLAY timePropGamma;
    
    LOOP(itSave$(ord(itSave) eq ord(xi)),
        PAR_ofHSPRO(itSave) = ofHSPRO.L;
        IF(ofHSPRO.L eq 0, PAR_ofHSPRO(itSave) = 1e-6);
    );
    
    LOOP(t,
        LOOP(itSave$(ord(itSave) eq ord(xi)),
            PAR_mpDA(t,itSave) = mpDA.L(t);
            PAR_chBDA(t,itSave) = chBDA.L(t);
            PAR_disBDA(t,itSave) = disBDA.L(t);
            PAR_elEDA(t,itSave) = elEDA.L(t);
            PAR_resRDA(t,itSave) = resRDA.L(t);
            PAR_soeBDA(t,itSave) = soeBDA.L(t);
            PAR_xBDA(t,itSave) = xBDA.L(t);
            PAR_xEDA(t,itSave) = xEDA.L(t);
            IF(mpDA.L(t) eq 0, PAR_mpDA(t,itSave) = 1e-6);
            IF(chBDA.L(t) eq 0, PAR_chBDA(t,itSave) = 1e-6);
            IF(disBDA.L(t) eq 0, PAR_disBDA(t,itSave) = 1e-6);
            IF(elEDA.L(t) eq 0, PAR_elEDA(t,itSave) = 1e-6);
            IF(resRDA.L(t) eq 0, PAR_resRDA(t,itSave) = 1e-6);
            IF(soeBDA.L(t) eq 0, PAR_soeBDA(t,itSave) = 1e-6);
            IF(xBDA.L(t) eq 0, PAR_xBDA(t,itSave) = 1e-6);
            IF(xEDA.L(t) eq 0, PAR_xEDA(t,itSave) = 1e-6);
        );
    );
    
    LOOP(t,
        LOOP(s,
            LOOP(itSave$(ord(itSave) eq ord(xi)),
                PAR_chiHIB(t,s,itSave) = chiHIB.L(t,s);
                PAR_dIB(t,s,itSave) = dIB.L(t,s);
                PAR_rIB(t,s,itSave) = rIB.L(t,s);
                PAR_y(t,s,itSave) = y.L(t,s);
                PAR_muPlus(t,s,itSave) = muPlus.L(t,s);
                PAR_muMinus(t,s,itSave) = muMinus.L(t,s);
                PAR_chBIBplus(t,s,itSave) = chBIBplus.L(t,s);
                PAR_chBIBminus(t,s,itSave) = chBIBminus.L(t,s);
                PAR_disBIBplus(t,s,itSave) = disBIBplus.L(t,s);
                PAR_disBIBminus(t,s,itSave) = disBIBminus.L(t,s);
                PAR_elEIB(t,s,itSave) = elEIB.L(t,s);
                PAR_elEIBplus(t,s,itSave) = elEIBplus.L(t,s);
                PAR_elEIBminus(t,s,itSave) = elEIBminus.L(t,s);
                PAR_elHatEIB(t,s,itSave) = elHatEIB.L(t,s);
                PAR_resRIB(t,s,itSave) = resRIB.L(t,s);
                PAR_soeBIB(t,s,itSave) = soeBIB.L(t,s);
                PAR_xPlus(t,s,itSave) = xPlus.L(t,s);
                PAR_xMinus(t,s,itSave) = xMinus.L(t,s);
                PAR_xBIB(t,s,itSave) = xBIB.L(t,s);
                PAR_xEIB(t,s,itSave) = xEIB.L(t,s);
                IF(chiHIB.L(t,s) eq 0, PAR_chiHIB(t,s,itSave) = 1e-6);
                IF(dIB.L(t,s) eq 0, PAR_dIB(t,s,itSave) = 1e-6);
                IF(rIB.L(t,s) eq 0, PAR_rIB(t,s,itSave) = 1e-6);
                IF(y.L(t,s) eq 0, PAR_y(t,s,itSave) = 1e-6);
                IF(muPlus.L(t,s) eq 0, PAR_muPlus(t,s,itSave) = 1e-6);
                IF(muMinus.L(t,s) eq 0, PAR_muMinus(t,s,itSave) = 1e-6);
                IF(chBIBplus.L(t,s) eq 0, PAR_chBIBplus(t,s,itSave) = 1e-6);
                IF(chBIBminus.L(t,s) eq 0, PAR_chBIBminus(t,s,itSave) = 1e-6);
                IF(disBIBplus.L(t,s) eq 0, PAR_disBIBplus(t,s,itSave) = 1e-6);
                IF(disBIBminus.L(t,s) eq 0, PAR_disBIBminus(t,s,itSave) = 1e-6);
                IF(elEIB.L(t,s) eq 0, PAR_elEIB(t,s,itSave) = 1e-6);
                IF(elEIBplus.L(t,s) eq 0, PAR_elEIBplus(t,s,itSave) = 1e-6);
                IF(elEIBminus.L(t,s) eq 0, PAR_elEIBminus(t,s,itSave) = 1e-6);
                IF(elHatEIB.L(t,s) eq 0, PAR_elHatEIB(t,s,itSave) = 1e-6);
                IF(resRIB.L(t,s) eq 0, PAR_resRIB(t,s,itSave) = 1e-6);
                IF(soeBIB.L(t,s) eq 0, PAR_soeBIB(t,s,itSave) = 1e-6);
                IF(xPlus.L(t,s) eq 0, PAR_xPlus(t,s,itSave) = 1e-6);
                IF(xMinus.L(t,s) eq 0, PAR_xMinus(t,s,itSave) = 1e-6);
                IF(xBIB.L(t,s) eq 0, PAR_xBIB(t,s,itSave) = 1e-6);
                IF(xEIB.L(t,s) eq 0, PAR_xEIB(t,s,itSave) = 1e-6);
            );
        );
    );
    
    LOOP(t,
        LOOP(j,
            LOOP(itSave$(ord(itSave) eq ord(xi)),
                PAR_soeBDAseg(t,j,itSave) = soeBDAseg.L(t,j);
                IF(soeBDAseg.L(t,j) eq 0, PAR_soeBDAseg(t,j,itSave) = 1e-6);
            );
        );
    );
    
    LOOP(t,
        LOOP(s,
            LOOP(j,
                LOOP(itSave$(ord(itSave) eq ord(xi)),
                    PAR_soeBIBseg(t,s,j,itSave) = soeBIBseg.L(t,s,j);
                    IF(soeBIBseg.L(t,s,j) eq 0, PAR_soeBIBseg(t,s,j,itSave) = 1e-6);
                );
            );
        );
    );
    
    LOOP(t,
        LOOP(s,
            LOOP(itSave$(ord(itSave) eq ord(xi)),
                PAR_z(t,s,itSave) = z.L(t,s);
                IF(z.L(t,s) eq 0, PAR_z(t,s,itSave) = 1e-6);
            );
        );
    );
    
    LOOP(s,
        LOOP(itSave$(ord(itSave) eq ord(xi)),
            PAR_delta(s,itSave) = delta.L(s);
            IF(delta.L(s) eq 0, PAR_delta(s,itSave) = 1e-6);
        );
    );

);

LOOP(t,LOOP(xi$X2(xi),IF(mpDAfixMatrixGamma(t,xi) eq 0,mpDAfixMatrixGamma(t,xi) = 1e-6)));
DISPLAY mpDAfixMatrixGamma;

LOOP(xi$X2(xi),IF(ofHSPROvector(xi) eq 0,ofHSPROvector(xi) = 1e-6));
DISPLAY ofHSPROvector;

LOOP(xi$X2(xi),IF(GammaIBvector(xi) eq 0,GammaIBvector(xi) = 1e-6));
DISPLAY GammaIBvector;

execute_unload 'resultsHybridSPRO_Gamma.gdx' mpDAfixMatrixGamma, ofHSPROvector, GammaIBvector,
timePropGamma
*PAR_chiHDA
PAR_chiHIB
*PAR_phiVAR
PAR_dIB
PAR_mpDA
*PAR_ofD
PAR_ofHSPRO
*PAR_ofHSPROoa
*PAR_ofPROP
*PAR_ofPROPoa
PAR_rIB
PAR_y
PAR_delta
*PAR_deltaXI
PAR_thetaCVAR
PAR_muPlus
PAR_muMinus
PAR_chBDA
PAR_chBIBplus
PAR_chBIBminus
PAR_disBDA
PAR_disBIBplus
PAR_disBIBminus
PAR_elEDA
PAR_elEIB
PAR_elEIBplus
PAR_elEIBminus
*PAR_elHatEDA
PAR_elHatEIB
PAR_resRDA
PAR_resRIB
PAR_soeBDA
PAR_soeBDAseg
PAR_soeBIB
PAR_soeBIBseg
PAR_z
*PAR_zXI
PAR_xPlus
PAR_xMinus
PAR_xBDA
PAR_xBIB
PAR_xEDA
PAR_xEIB
;
