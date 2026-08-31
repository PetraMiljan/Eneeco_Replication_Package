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

LOOP(itAlpha$(ord(itAlpha) <= card(itAlpha)),

    AlphaCVAR = AlphaCVARvector(itAlpha);
    DISPLAY AlphaCVAR;

    SOLVE proposedProblem maximizing ofPROP using mip;
    ofPROPvector(itAlpha) = ofPROP.L;
    mpDAfixMatrix(t,itAlpha) = mpDA.L(t); 
    DISPLAY AlphaCVAR, mpDA.L, mpDAfixMatrix ofPROP.L, ofPROPvector;
    
    timePropAlpha(itAlpha) = proposedProblem.resUsd;
    DISPLAY timePropAlpha;
    
    LOOP(itSave$(ord(itSave) eq ord(itAlpha)),
        PAR_phiVAR(itSave) = phiVAR.L;
        PAR_ofPROP(itSave) = ofPROP.L;
        IF(phiVAR.L eq 0, PAR_phiVAR(itSave) = 1e-6);
        IF(ofPROP.L eq 0, PAR_ofPROP(itSave) = 1e-6);
    );
    
    LOOP(t,
        LOOP(itSave$(ord(itSave) eq ord(itAlpha)),
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
            LOOP(itSave$(ord(itSave) eq ord(itAlpha)),
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
            LOOP(itSave$(ord(itSave) eq ord(itAlpha)),
                PAR_soeBDAseg(t,j,itSave) = soeBDAseg.L(t,j);
                IF(soeBDAseg.L(t,j) eq 0, PAR_soeBDAseg(t,j,itSave) = 1e-6);
            );
        );
    );
    
    LOOP(t,
        LOOP(s,
            LOOP(j,
                LOOP(itSave$(ord(itSave) eq ord(itAlpha)),
                    PAR_soeBIBseg(t,s,j,itSave) = soeBIBseg.L(t,s,j);
                    IF(soeBIBseg.L(t,s,j) eq 0, PAR_soeBIBseg(t,s,j,itSave) = 1e-6);
                );
            );
        );
    );
    
    LOOP(t,
        LOOP(s,
            LOOP(xi$(ord(xi) <= card(X2)),
                LOOP(itSave$(ord(itSave) eq ord(itAlpha)),
                    PAR_zXI(t,s,xi,itSave) = zXI.L(t,s,xi);
                    IF(zXI.L(t,s,xi) eq 0, PAR_zXI(t,s,xi,itSave) = 1e-6);
                );
            );
        );
    );
    
    LOOP(s,
        LOOP(xi$(ord(xi) <= card(X2)),
            LOOP(itSave$(ord(itSave) eq ord(itAlpha)),
                PAR_deltaXI(s,xi,itSave) = deltaXI.L(s,xi);
                PAR_thetaCVAR(s,xi,itSave) = thetaCVAR.L(s,xi);
                IF(deltaXI.L(s,xi) eq 0, PAR_deltaXI(s,xi,itSave) = 1e-6);
                IF(thetaCVAR.L(s,xi) eq 0, PAR_thetaCVAR(s,xi,itSave) = 1e-6);
            );
        );
    );

);

LOOP(t,LOOP(itAlpha,IF(mpDAfixMatrix(t,itAlpha) eq 0,mpDAfixMatrix(t,itAlpha) = 1e-6)));
DISPLAY mpDAfixMatrix;

LOOP(itAlpha,IF(ofPROPvector(itAlpha) eq 0,ofPROPvector(itAlpha) = 1e-6));
DISPLAY ofPROPvector;

LOOP(itAlpha,IF(AlphaCVARvector(itAlpha) eq 0,AlphaCVARvector(itAlpha) = 1e-6));
DISPLAY AlphaCVARvector;

execute_unload 'resultsProposed_alpha.gdx' mpDAfixMatrix, ofPROPvector, AlphaCVARvector
timePropAlpha
*PAR_chiHDA
PAR_chiHIB
PAR_phiVAR
PAR_dIB
PAR_mpDA
*PAR_ofD
*PAR_ofHSPRO
*PAR_ofHSPROoa
PAR_ofPROP
*PAR_ofPROPoa
PAR_rIB
PAR_y
*PAR_delta
PAR_deltaXI
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
*PAR_z
PAR_zXI
PAR_xPlus
PAR_xMinus
PAR_xBDA
PAR_xBIB
PAR_xEDA
PAR_xEIB
;
