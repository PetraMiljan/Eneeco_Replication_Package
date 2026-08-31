*====================================================
* Paper Zagreb 2025
* Álvaro García-Cerezo, Petra Miljan, Hrvoje Pandzic
* Data: Sets, parameters and tables 
*====================================================

SETS
i       Breakpoints used in the linearization of the battery charging curve /i1*i4/
it      Axiliar index                                                       /it1*it100/
itAlpha Auxiliar index                                                      /itAlpha1*itAlpha11/
*itAlpha Auxiliar index                                                      /itAlpha1/
itSave  Auxiliar index                                                      /itSave1*itSave25/
j       Segments used in the linearization of the battery charging curve    /j1*j3/
t       Time periods                                                        /t1*t24/
s       RES output scenarios                                                /s1*s200/
S2(s)   Set of scenarios used when the optimization problem is solved       /s1*s10/
S3(s)   Set of scenarios used in the out-of-sample analysis                 /s1*s200/
v(s)    Dynamic index of s
xi      Imbalance price deviation scenarios                                 /xi1*xi366/
* CAMBIO DEL SENSITIVITY ANALYSIS
X2(xi)  Set of scenarios used when the optimization problem is solved       /xi1*xi5/
*
X3(xi)  Set of scenarios used in the out-of-sample analysis                 /xi1*xi366/
*xi      Imbalance price deviation scenarios                                 /xi13*xi25/
*xi      Imbalance price deviation scenarios                                 /xi1/
;

ALIAS(xi,xixi);

SCALARS
AlphaCVAR       Confidence level associated with the CVaR               /0.999/
BetaE           Fixed electrolyzer inefficiency coefficient             /0.011/
GammaIBscalar   Uncertainty budget (h)                                  /24/
DeltaT          Duration of time period (h)                             /1/
ZetaH           Minimum stable operation of the electrolizer (%)        /0.10/
EtaB            Charging \ discharging battery efficiency               /0.92/
EtaE            Variable electrolyzer inefficiency coefficient          /0.689/
EtaW            Variable electrolyzer inefficiency coefficient (m3\kg)  /0.01/
ThetaH          Energy-to-hydrogen conversion coefficient (MWh\kg)      /0.0394/
KIB             Coefficient for calculating the imbalance price         /0.4/
M               Large enough constant                                   /1000/
PBmax           Installed power of the battery inverter (MW)            /5/
PEmax           Maximum power of the electrolyzer (MW)                  /5/
PGRIDmax        Grid connection power limit (MW)                        /20/
SoeBini         Energy stored in the battery at the beginning of the planning horizon (MWh) /0/
SoeBend         Minimum energy stored in the battery at the ending of the planning horizon (MWh) /0/
SoeBmax         Maximum battery capacity (MWh)                          /5/     
;

PARAMETERS
LambdaH(t)      Price of hydrogen (€\kg)
LambdaW(t)      Price of water (€\m3)
;
LambdaH(t) = 2;
LambdaW(t) = 0.397;

PARAMETER AlphaCVaRvector(itAlpha) Confidence level
/
itAlpha1    0
itAlpha2    0.1
itAlpha3    0.2
itAlpha4    0.3
itAlpha5    0.4
itAlpha6    0.5
itAlpha7    0.6
itAlpha8    0.7
itAlpha9    0.8
itAlpha10   0.9
itAlpha11   0.999
/;

PARAMETER GammaIBvector(xi) Uncertainty budget (h)
/
*xi1     24
*$ontext
* CAMBIO DEL SENSITIVITY ANALYSIS
xi1     0
xi2     6
xi3     12
xi4     18
xi5     24
$ontext
xi6     5
xi7     6
xi8     7
xi9     8
xi10    9
xi11    10
xi12    11
*$offtext
*$ontext
xi13    12
xi14    13
xi15    14
xi16    15
xi17    16
xi18    17
xi19    18
xi20    19
xi21    20
xi22    21
xi23    22
xi24    23
xi25    24
$offtext
*
/;

PARAMETER LambdaDA(t) Day-ahead electricity market price (€\MWh) 
/
t1  33.29
t2  31.1
t3  29.03
t4  28.5
t5  29
t6  33.69
t7  40.92
t8  43.09
t9  43.3
t10 44.2
t11 44.05
t12 42.95
t13 42.49
t14 42.97
t15 42.8
t16 45.67
t17 66.22
t18 94.43
t19 53.35
t20 73.71
t21 48
t22 39.79
t23 61.42
t24 57.32
/;

Parameter ProbS(s) Probability of RES scenario realization
;

PARAMETER ProbX(xi) Probability of imbalance price deviation scenario realization
;
ProbX(xi)$X2(xi) = 1/card(X2);
DISPLAY ProbX;

PARAMETER FB(i) Coefficients for battery charging curve linearization
/
i1       0.823
i2       0.658
i3       0.046
i4       0
/;

PARAMETER RB(i) Coefficients for battery charging curve linearization
/
i1       0
i2       0.23
i3       0.947
i4       1
/;

PARAMETER ResRDAmax(t) Forecast available production of RES (MW)
/
t1  0
t2  0
t3  0
t4  0
t5  0
t6  0
t7  0
t8  0
t9  0.024865
t10 4.3018
t11 9.0652
t12 13.681
t13 14.658
t14 14.278
t15 7.9838
t16 4.2282
t17 0.8303
t18 0.00021938
t19 0
t20 0
t21 0
t22 0
t23 0
t24 0
/;

PARAMETER ResRIBmax(t,s) Actual available production of RES (MW)
;

* Values of SoeBiniSeg(j) fixed for SoeBini/SoeBmax
PARAMETER SoeBiniSeg(j) Energy stored in the battery at the beginning of the planning horizon and segment j (MWh)
/
j1       0
j2       0
j3       0
*j1       0.23
*j2       0.27
*j3       0
/;
SoeBiniSeg(j) = SoeBiniSeg(j)*SoeBmax;

PARAMETERS
ScenActS(s)     Logical parameter used to identify the scenarios s considered in the problem
ScenActX(xi)    Logical parameter used to identify the scenarios xi considered in the problem
;
* I initialize these parameter to prevent errors in the GAMS's code. 
ScenActS(s) = yes;
ScenActX(xi)$X2(xi) = yes;

*========================================================================
* Sets, parameters and tables associated with the out-of-sample analysis
*========================================================================

PARAMETERS mpDAfix(t), chBDAfix(t), disBDAfix(t), elEDAfix(t);
* I initialize these parameter to prevent errors in the GAMS's code.
mpDAfix(t) = 0;
chBDAfix(t) = 0;
disBDAfix(t) = 0;
elEDAfix(t) = 0;
PARAMETER mpDAfixMatrix(t,itAlpha);
PARAMETER mpDAfixMatrixGamma(t,xi);
PARAMETER ofHSPROvector(xi);
PARAMETER ofPROPvector(itAlpha);
PARAMETER ProfitScen(s,xi,itAlpha);
PARAMETER ProfitScenHybrid(s,xi,xixi);

*========================================================================
* Parameters used to save the results
*========================================================================

PARAMETERS timePropAlpha(itAlpha), timePropGamma(xi)
PAR_chiHDA(t,itSave)
PAR_chiHIB(t,s,itSave)
PAR_phiVAR(itSave)
PAR_dIB(t,s,itSave)
PAR_mpDA(t,itSave)
PAR_ofD
PAR_ofHSPRO(itSave)
PAR_ofHSPROoa(itSave)
PAR_ofPROP(itSave)
PAR_ofPROPoa(itSave)
PAR_rIB(t,s,itSave)
PAR_y(t,s,itSave)
PAR_delta(s,itSave)
PAR_deltaXI(s,xi,itSave)
PAR_thetaCVAR(s,xi,itSave)
PAR_muPlus(t,s,itSave)
PAR_muMinus(t,s,itSave)
PAR_chBDA(t,itSave)
PAR_chBIBplus(t,s,itSave)
PAR_chBIBminus(t,s,itSave)
PAR_disBDA(t,itSave)
PAR_disBIBplus(t,s,itSave)
PAR_disBIBminus(t,s,itSave)
PAR_elEDA(t,itSave)
PAR_elEIB(t,s,itSave)
PAR_elEIBplus(t,s,itSave)
PAR_elEIBminus(t,s,itSave)
PAR_elHatEDA(t,itSave)
PAR_elHatEIB(t,s,itSave)
PAR_resRDA(t,itSave)
PAR_resRIB(t,s,itSave)
PAR_soeBDA(t,itSave)
PAR_soeBDAseg(t,j,itSave) 
PAR_soeBIB(t,s,itSave) 
PAR_soeBIBseg(t,s,j,itSave) 
PAR_z(t,s,itSave) 
PAR_zXI(t,s,xi,itSave) 
PAR_xPlus(t,s,itSave) 
PAR_xMinus(t,s,itSave)
PAR_xBDA(t,itSave)
PAR_xBIB(t,s,itSave)
PAR_xEDA(t,itSave)
PAR_xEIB(t,s,itSave)
;
