*====================================================
* Paper Zagreb 2025
* Álvaro García-Cerezo, Petra Miljan, Hrvoje Pandzic
* Variables
*====================================================

*======================================
* VARIABLES OF THE DETERMINISTIC MODEL
*======================================

VARIABLES
chiHDA(t)       Produced hydrogen amount (kg)
chiHIB(t,s)     Produced hydrogen amount (kg)
phiVAR          Value-at-risk (€)
dIB(t,s)        Deviation of the facility (MWh)
mpDA(t)         Market position of the facility at the DA stage (MWh)
ofD             Objective function value of the deterministic problem (€)
ofHSPRO         Objective function value of the hybrid SP RO problem (€)
ofHSPROoa       Objective function value of the hybrid SP RO problem - out-of-sample analysis (€)
ofPROP          Objective function value of the proposed problem (€)
ofPROPoa        Objective function value of the proposed problem - out-of-sample analysis (€)
rIB(t,s)        Realized production of the facility (MWh)
y(t,s)          Variable associated with the linearization of the absolute value of dIB (MWh)
;

POSITIVE VARIABLES
delta(s)            Dual variable associated with the dual robust subproblem (€\h)
deltaXI(s,xi)       Dual variable associated with the dual robust subproblem (€\h)
thetaCVAR(s,xi)     Auxiliary variable used to compute the CVaR (€)
muPlus(t,s)         Dual variable associated with KKT conditions
muMinus(t,s)        Dual variable associated with KKT conditions
*bIB(t,s)            Indicates the direction of deviation 1 unfavourable 0 favourable
*bIBxi(t,s,xi)       Indicates the direction of deviation 1 unfavourable 0 favourable
chBDA(t)            Battery charging power at the DA stage (MW)
chBIBplus(t,s)      Balancing power provided by battery charging in positive direction (MW)
chBIBminus(t,s)     Balancing power provided by battery charging in negative direction (MW)
disBDA(t)           Battery discharging power at the DA stage (MW)
disBIBplus(t,s)     Balancing power provided by battery discharging in positive direction (MW)
disBIBminus(t,s)    Balancing power provided by battery discharging in negative direction (MW)
elEDA(t)            Actual power required to produce a kilogram of hydrogen at the DA stage (MW)
elEIB(t,s)          Actual power required to produce a kilogram of hydrogen (MW)
elEIBplus(t,s)      Balancing power provided by electrolyzer in positive direction (MW)
elEIBminus(t,s)     Balancing power provided by electrolyzer in negative direction (MW)
elHatEDA(t)         Power consumption of the electrolyze at the DA stage (MW)
elHatEIB(t,s)       Power consumption of the electrolyzer (MW)
resRDA(t)           RES production injected into the grid at the DA stage (MW)
resRIB(t,s)         RES production injected into the grid (MW)
soeBDA(t)           Battery state-of-energy (MWh)
soeBDAseg(t,j)      Battery state-of-energy at the segment j (MWh)
soeBIB(t,s)         Battery state-of-energy at the DA stage (MWh)
soeBIBseg(t,s,j)    Battery state-of-energy at the segment j and the DA stage (MWh)
z(t,s)              Dual variable associated with the dual robust subproblem (€)
zXI(t,s,xi)         Dual variable associated with the dual robust subproblem (€)
;

BINARY VARIABLES
xPlus(t,s)      Binary variable used to linearized the non-linear constraints associated with the KKT conditions
xMinus(t,s)     Binary variable used to linearized the non-linear constraints associated with the KKT conditions
xBDA(t)         Binary variable 1 if battery is charging at the DA stage 0 otherwise
xBIB(t,s)       Binary variable 1 if the net charging power of the battery is increased in the balancing stage 0 otherwise
xEDA(t)         Binary variable 1 if electrolyzer is on at the DA stage 0 otherwise
xEIB(t,s)       Binary variable 1 if electrolyzer is on at the balancing stage 0 otherwise
;
