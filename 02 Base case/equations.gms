*====================================================
* Paper Zagreb 2025
* Álvaro García-Cerezo, Petra Miljan, Hrvoje Pandzic
* Equations
*====================================================

*========================================
* EQUATIONS OF THE DETERMINISTIC PROBLEM
*========================================

EQUATIONS

* Objective function
dEQof       Objective function of the deterministic problem

* Market position and grid limits
EQmp        Market position
EQmpUL      Upper limit of mpDA
EQmpLL      Lower limit of mpDA

* Renewable generating unit
EQresDAUL   Upper limit of the resRDA

* Battery
EQsoeBDA        Evolution of soeBDA
EQsoeBDAUL      Upper limit of soeBDA
EQsoeBDALLend   Lower limit of soeBDA at the end
EQsoeBDAseg     Equation associated with soeBDA and soeBDAseg
EQsoeBDAsegUL   Upper limit of soeBDAseg
EQchBDAULlin    Upper limit of chBDA associated with the linearized curve
EQdisBDAUL      Upper limit of disBDA
EQchBDAUL       Upper limit of chBDA

* Electrolyzer
EQelEDAUL       Upper limit of elEDA
EQelEDALL       Lower limit of elEDA
EQelhatEDAH2    Equation associated with elHatEDA and chiEDA
EQelhatEDA      Equation associated with elHatEDA and elEDA
;

* Objective function
dEQof.. ofD =E= sum(t, LambdaDA(t) * mpDA(t) + LambdaH(t) * chiHDA(t)
            - LambdaW(t) * EtaW * chiHDA(t) );

* Market position and grid limits
EQmp(t)..   mpDA(t) =E= ( resRDA(t) + disBDA(t) - chBDA(t) - elEDA(t) ) * DeltaT;
EQmpUL(t).. mpDA(t) =L= PGRIDmax;
EQmpLL(t).. mpDA(t) =G= - PGRIDmax;

* Renewable generating unit
EQresDAUL(t)..  resRDA(t) =L= ResRDAmax(t);

* Battery
EQsoeBDA(t)..                           soeBDA(t) =E= SoeBini$(ord(t) eq 1) + soeBDA(t-1)$(ord(t) > 1)
                                            + etaB * chBDA(t) * DeltaT - (1/etaB) * disBDA(t) * DeltaT;
EQsoeBDAUL(t)..                         soeBDA(t) =L= SoeBmax;
EQsoeBDALLend(t)$(ord(t) eq card(t))..  soeBDA(t) =G= SoeBend;
EQsoeBDAseg(t)..                        soeBDA(t) =E= sum(j, soeBDAseg(t,j) );
EQsoeBDAsegUL(t,j)..                    soeBDAseg(t,j) =L= sum(i$(ord(i) eq ord(j)), RB(i+1) - RB(i) ) * SoeBmax;
EQchBDAULlin(t)..                       EtaB * chBDA(t) * DeltaT =L= sum(i$(ord(i) eq 1),FB(i)) * SoeBmax
                                            - sum(i$(ord(i) ge 2), sum(j$(ord(j) eq ord(i)-1), ( SoeBiniSeg(j)$(ord(t) eq 1) + soeBDAseg(t-1,j)$(ord(t) > 1) ) * ( FB(i-1) - FB(i) ) / ( RB(i) - RB(i-1) ) ) ); 
EQdisBDAUL(t)..                         disBDA(t) =L= ( 1 - xBDA(t) ) * PBmax;
EQchBDAUL(t)..                          chBDA(t) =L= xBDA(t) * PBmax;

* Electrolyzer
EQelEDAUL(t)..      elEDA(t) =L= PEmax * xEDA(t);
EQelEDALL(t)..      elEDA(t) =G= ZetaH * PEmax * xEDA(t);
EQelhatEDAH2(t)..   elHatEDA(t) * DeltaT =E= chiHDA(t) * ThetaH;
EQelhatEDA(t)..     elHatEDA(t) =E= EtaE * elEDA(t) + BetaE * PEmax * xEDA(t);

*====================================
* MODEL OF THE DETERMINISTIC PROBLEM
*====================================

MODEL deterministicProblem
/
dEQof,
EQmp, EQmpUL, EQmpLL,
EQresDAUL,
EQsoeBDA, EQsoeBDAUL, EQsoeBDALLend, EQsoeBDAseg, EQsoeBDAsegUL, EQchBDAULlin, EQdisBDAUL, EQchBDAUL, 
EQelEDAUL, EQelEDALL, EQelhatEDAH2, EQelhatEDA
/;

*=======================================
* EQUATIONS OF THE HYBRID SP RO PROBLEM
*=======================================

EQUATIONS

* Objective function
hsproEQof   Objective function of the hybrid SP RO problem

* Market position and grid limits
EQdIB       Market position deviation
EQrIB       Market position in balancing stage
EQrIBUL     Upper limit of rIB
EQrIBLL     Lower limit of rIB

* Renewable generating unit
EQresIBUL   Upper limit of the resRIB

* Battery
EQsoeBIB        Evolution of soeBIB
EQsoeBIBUL      Upper limit of soeBIB
EQsoeBIBLLend   Lower limit of soeBIB at the end
EQsoeBIBseg     Equation associated with soeBIB and soeBIBseg
EQsoeBIBsegUL   Upper limit of soeBIBseg
EQchBIBULlin    Upper limit of chBIB associated with the linearized curve
EQdisBIBUL      Upper limit of the discharge direction in IB
EQchBIBUL       Upper limit of the charge direction in IB
EQchplusBIBUL   Upper limit of the chBIBplus in IB
EQchminusBIBUL  Upper limit of the chBIBminus in IB
EQdisplusBIBUL  Upper limit of the disBIBplus in IB
EQdisminusBIBUL Upper limit of the disBIBminus in IB

* Electrolyzer
EQelEIB         Definition of elEIB
EQelEIBUL       Upper limit of elEIB
EQelEIBLL       Lower limit of elEIB
EQelhatEIBH2    Equation associated with elHatEIB and chiEIB
EQelhatEIB      Equation associated with elHatEIB and elEIB

* Linearization of the absolute value of dIB
EQyLLpos        Lower level of variable y associated with positive values of dIB
EQyLLneg        Lower level of variable y associated with negative values of dIB
EQkktStat       Stationarity conditions of the KKT
EQkktCS1        Complementary slackness condition 1 of the KKT
EQkktCS2        Complementary slackness condition 2 of the KKT
EQkktCS3        Complementary slackness condition 3 of the KKT
EQkktCS4        Complementary slackness condition 4 of the KKT

* Constraints associated with the dual robust subproblem
EQdualRO        Equation associated with the dual robust subproblem
;

* Objective function
hsproEQof.. ofHSPRO =E= sum(t, LambdaDA(t) * mpDA(t) + sum(s$ScenActS(s), ProbS(s) * ( LambdaDA(t) * dIB(t,s)
                + LambdaH(t) * chiHIB(t,s) - LambdaW(t) * EtaW * chiHIB(t,s)
                + LambdaDA(t) * KIB * y(t,s) - z(t,s) ) ) )
                - sum(s$ScenActS(s), ProbS(s) * delta(s) * GammaIBscalar );

* Market position deviation and grid limits
EQdIB(t,s)$ScenActS(s)..    dIB(t,s) =E= rIB(t,s) - mpDA(t); 
EQrIB(t,s)$ScenActS(s)..    rIB(t,s) =E= ( resRIB(t,s) + disBDA(t) - chBDA(t) - elEDA(t)
                                + disBIBplus(t,s) - disBIBminus(t,s) - chBIBplus(t,s) + chBIBminus(t,s)
                                - elEIBplus(t,s) + elEIBminus(t,s) ) * DeltaT;
EQrIBUL(t,s)$ScenActS(s)..  rIB(t,s) =L= PGRIDmax;
EQrIBLL(t,s)$ScenActS(s)..  rIB(t,s) =G= - PGRIDmax;

* Renewable generating unit
EQresIBUL(t,s)$ScenActS(s)..    resRib(t,s) =L= ResRIBmax(t,s);

* Battery
EQsoeBIB(t,s)$ScenActS(s)..                                     soeBIB(t,s) =E= SoeBini$(ord(t) eq 1) + soeBIB(t-1,s)$(ord(t) > 1)
                                                                    + etaB * ( chBDA(t) + chBIBplus(t,s) - chBIBminus(t,s) ) * DeltaT
                                                                    - (1/etaB) * ( disBDA(t) + disBIBplus(t,s) - disBIBminus(t,s) ) * DeltaT;
EQsoeBIBUL(t,s)$ScenActS(s)..                                   soeBIB(t,s) =L= SoeBmax;
EQsoeBIBLLend(t,s)$((ord(t) eq card(t)) and ScenActS(s))..      soeBIB(t,s) =G= SoeBend;
EQsoeBIBseg(t,s)$ScenActS(s)..                                  soeBIB(t,s) =E= sum(j, soeBIBseg(t,s,j) );
EQsoeBIBsegUL(t,s,j)$ScenActS(s)..                              soeBIBseg(t,s,j) =L= sum(i$(ord(i) eq ord(j)), RB(i+1) - RB(i) ) * SoeBmax;
EQchBIBULlin(t,s)$ScenActS(s)..                                 EtaB * ( chBDA(t) + chBIBplus(t,s) - chBIBminus(t,s) ) * DeltaT =L= sum(i$(ord(i) eq 1),FB(i)) * SoeBmax
                                                                    - sum(i$(ord(i) ge 2), sum(j$(ord(j) eq ord(i)-1), ( SoeBiniSeg(j)$(ord(t) eq 1) + soeBIBseg(t-1,s,j)$(ord(t) > 1) ) * ( FB(i-1) - FB(i) ) / ( RB(i) - RB(i-1) ) ) ); 
EQdisBIBUL(t,s)$ScenActS(s)..                                   chBIBminus(t,s) + disBIBplus(t,s) =L= ( 1 - xBIB(t,s) ) * 2 * PBmax;
EQchBIBUL(t,s)$ScenActS(s)..                                    chBIBplus(t,s) + disBIBminus(t,s) =L= xBIB(t,s) * 2 * PBmax;
EQchplusBIBUL(t,s)$ScenActS(s)..                                chBIBplus(t,s) + chBDA(t) =L= PBmax;
EQchminusBIBUL(t,s)$ScenActS(s)..                               chBIBminus(t,s) =L= chBDA(t);
EQdisplusBIBUL(t,s)$ScenActS(s)..                               disBIBplus(t,s) + disBDA(t) =L= PBmax;
EQdisminusBIBUL(t,s)$ScenActS(s)..                              disBIBminus(t,s) =L= disBDA(t);

* Electrolyzer
EQelEIB(t,s)$ScenActS(s)..      elEIB(t,s) =E= elEDA(t) + elEIBplus(t,s) - elEIBminus(t,s);
EQelEIBUL(t,s)$ScenActS(s)..    elEIB(t,s) =L= PEmax * xEIB(t,s);
EQelEIBLL(t,s)$ScenActS(s)..    elEIB(t,s) =G= ZetaH * PEmax * xEIB(t,s);
EQelhatEIBH2(t,s)$ScenActS(s).. elHatEIB(t,s) * DeltaT =E= chiHIB(t,s) * ThetaH;
EQelhatEIB(t,s)$ScenActS(s)..   elHatEIB(t,s) =E= EtaE * elEIB(t,s) + BetaE * PEmax * xEIB(t,s);

* Linearization of the absolute value of dIB
EQyLLpos(t,s)$ScenActS(s)..     y(t,s) =G= dIB(t,s);
EQyLLneg(t,s)$ScenActS(s)..     y(t,s) =G= - dIB(t,s);
EQkktStat(t,s)$ScenActS(s)..    1 - muPlus(t,s) - muMinus(t,s) =E= 0;
EQkktCS1(t,s)$ScenActS(s)..     y(t,s) - dIB(t,s) =L= ( 1 - xPlus(t,s) ) * M;
EQkktCS2(t,s)$ScenActS(s)..     muPlus(t,s) =L= xPlus(t,s) * M;
EQkktCS3(t,s)$ScenActS(s)..     y(t,s) + dIB(t,s) =L= ( 1 - xMinus(t,s) ) * M;
EQkktCS4(t,s)$ScenActS(s)..     muMinus(t,s) =L= xMinus(t,s) * M;

* Constraints associated with the dual robust subproblem
EQdualRO(t,s)..     delta(s) + z(t,s) =G= 2 * LambdaDA(t) * KIB * y(t,s);

*===================================
* MODEL OF THE HYBRID SP RO PROBLEM
*===================================

MODEL hybridsproProblem
/
hsproEQof,
EQmp, EQmpUL, EQmpLL,
EQresDAUL,
EQsoeBDA, EQsoeBDAUL, EQsoeBDALLend, EQsoeBDAseg, EQsoeBDAsegUL, EQchBDAULlin, EQdisBDAUL, EQchBDAUL, 
EQelEDAUL, EQelEDALL,
EQdIB, EQrIB, EQrIBUL, EQrIBLL,
EQresIBUL,
EQsoeBIB, EQsoeBIBUL, EQsoeBIBLLend, EQsoeBIBseg, EQsoeBIBsegUL, EQchBIBULlin, EQdisBIBUL, EQchBIBUL, EQchplusBIBUL, EQchminusBIBUL, EQdisplusBIBUL, EQdisminusBIBUL,
EQelEIB, EQelEIBUL, EQelEIBLL, EQelhatEIBH2, EQelhatEIB,
EQyLLpos, EQyLLneg, EQkktStat, EQkktCS1, EQkktCS2, EQkktCS3, EQkktCS4,
EQdualRO
/;

*===================================
* EQUATIONS OF THE PROPOSED PROBLEM
*===================================

EQUATIONS

* Objective function
propEQof        Objective function of the proposed problem

* Constraints associated with the CVaR
EQCVaR          Constraint associated with the CVaR

* Constraints associated with the dual robust subproblem
EQdualROprop    Equation associated with the dual robust subproblem
;

* Objective function
propEQof..  ofPROP =E= sum(t, LambdaDA(t) * mpDA(t) ) + phiVAR
                - (1/(1-AlphaCVAR)) * sum(s$ScenActS(s), sum(xi$ScenActX(xi), ProbS(s) * ProbX(xi) * thetaCVAR(s,xi) ) );

* Constraints associated with the CVaR
EQCVaR(s,xi)$(ScenActS(s) and ScenActX(xi))..   thetaCVaR(s,xi) =G= phiVAR - ( sum(t, LambdaDA(t) * dIB(t,s)
                                                    + LambdaH(t) * chiHIB(t,s) - LambdaW(t) * EtaW * chiHIB(t,s)
                                                    + LambdaDA(t) * KIB * y(t,s) - zXI(t,s,xi) )
                                                    - deltaXI(s,xi) * GammaIBvector(xi) );

* Constraints associated with the dual robust subproblem
EQdualROprop(t,s,xi)$(ScenActS(s) and ScenActX(xi))..   deltaXI(s,xi) + zXI(t,s,xi) =G= 2 * LambdaDA(t) * KIB * y(t,s);

*===============================
* MODEL OF THE PROPOSED PROBLEM
*===============================

MODEL proposedProblem
/
propEQof,
EQmp, EQmpUL, EQmpLL,
EQresDAUL,
EQsoeBDA, EQsoeBDAUL, EQsoeBDALLend, EQsoeBDAseg, EQsoeBDAsegUL, EQchBDAULlin, EQdisBDAUL, EQchBDAUL, 
EQelEDAUL, EQelEDALL,
EQCVaR,
EQdIB, EQrIB, EQrIBUL, EQrIBLL,
EQresIBUL,
EQsoeBIB, EQsoeBIBUL, EQsoeBIBLLend, EQsoeBIBseg, EQsoeBIBsegUL, EQchBIBULlin, EQdisBIBUL, EQchBIBUL, EQchplusBIBUL, EQchminusBIBUL, EQdisplusBIBUL, EQdisminusBIBUL,
EQelEIB, EQelEIBUL, EQelEIBLL, EQelhatEIBH2, EQelhatEIB,
EQyLLpos, EQyLLneg, EQkktStat, EQkktCS1, EQkktCS2, EQkktCS3, EQkktCS4,
EQdualROprop
/;

*============================================================
* EQUATIONS OF THE PROPOSED PROBLEM - OUT-OF-SAMPLE ANALYSIS
*============================================================

EQUATIONS

* Objective function
propOAEQof          Objective function of the proposed problem (out-of-sample analysis)

* Constraints associated with the CVaR
oaEQCVaR            Constraint associated with the CVaR

* Market position and grid limits
oaEQdIB             Market position deviation
oaEQrIB             Market position in balancing stage
oaEQrIBUL           Upper limit of rIB
oaEQrIBLL           Lower limit of rIB

* Renewable generating unit
oaEQresIBUL           Upper limit of the resRIB

* Battery
oaEQsoeBIB          Evolution of soeBIB
oaEQsoeBIBUL        Upper limit of soeBIB
oaEQsoeBIBLLend     Lower limit of soeBIB at the end
oaEQsoeBIBseg       Equation associated with soeBIB and soeBIBseg
oaEQsoeBIBsegUL     Upper limit of soeBIBseg
oaEQchBIBULlin      Upper limit of chBIB associated with the linearized curve
oaEQdisBIBUL        Upper limit of the discharge direction in IB
oaEQchBIBUL         Upper limit of the charge direction in IB
oaEQchplusBIBUL     Upper limit of the chBIBplus in IB
oaEQchminusBIBUL    Upper limit of the chBIBminus in IB
oaEQdisplusBIBUL    Upper limit of the disBIBplus in IB
oaEQdisminusBIBUL   Upper limit of the disBIBminus in IB

* Electrolyzer
oaEQelEIB           Definition of elEIB
oaEQelEIBUL         Upper limit of elEIB
oaEQelEIBLL         Lower limit of elEIB
oaEQelhatEIBH2      Equation associated with elHatEIB and chiEIB
oaEQelhatEIB        Equation associated with elHatEIB and elEIB

* Linearization of the absolute value of dIB
oaEQyLLpos          Lower level of variable y associated with positive values of dIB
oaEQyLLneg          Lower level of variable y associated with negative values of dIB
oaEQkktStat         Stationarity conditions of the KKT
oaEQkktCS1          Complementary slackness condition 1 of the KKT
oaEQkktCS2          Complementary slackness condition 2 of the KKT
oaEQkktCS3          Complementary slackness condition 3 of the KKT
oaEQkktCS4          Complementary slackness condition 4 of the KKT

* Constraints associated with the dual robust subproblem
oaEQdualROprop      Equation associated with the dual robust subproblem
;

* Objective function considering each scenario s independently through v
propOAEQof..    ofPROPoa =E= sum(t, LambdaDA(t) * mpDAfix(t) ) + phiVAR
                    - (1/(1-AlphaCVAR)) * sum(v, sum(xi$ScenActX(xi), ProbX(xi) * thetaCVAR(v,xi) ) );

* Constraints associated with the CVaR
oaEQCVaR(v,xi)$ScenActX(xi)..   thetaCVaR(v,xi) =G= phiVAR - ( sum(t, LambdaDA(t) * dIB(t,v)
                                    + LambdaH(t) * chiHIB(t,v) - LambdaW(t) * EtaW * chiHIB(t,v)
                                    + LambdaDA(t) * KIB * y(t,v) - zXI(t,v,xi) )
                                    - deltaXI(v,xi) * GammaIBvector(xi) );

* Market position deviation and grid limits
oaEQdIB(t,v)..    dIB(t,v) =E= rIB(t,v) - mpDAfix(t); 
oaEQrIB(t,v)..    rIB(t,v) =E= ( resRIB(t,v) + disBDAfix(t) - chBDAfix(t) - elEDAfix(t)
                                + disBIBplus(t,v) - disBIBminus(t,v) - chBIBplus(t,v) + chBIBminus(t,v)
                                - elEIBplus(t,v) + elEIBminus(t,v) ) * DeltaT;
oaEQrIBUL(t,v)..  rIB(t,v) =L= PGRIDmax;
oaEQrIBLL(t,v)..  rIB(t,v) =G= - PGRIDmax;

* Renewable generating unit
oaEQresIBUL(t,v)..    resRib(t,v) =L= ResRIBmax(t,v);

* Battery
oaEQsoeBIB(t,v)..                                   soeBIB(t,v) =E= SoeBini$(ord(t) eq 1) + soeBIB(t-1,v)$(ord(t) > 1)
                                                        + etaB * ( chBDAfix(t) + chBIBplus(t,v) - chBIBminus(t,v) ) * DeltaT
                                                        - (1/etaB) * ( disBDAfix(t) + disBIBplus(t,v) - disBIBminus(t,v) ) * DeltaT;
oaEQsoeBIBUL(t,v)..                                 soeBIB(t,v) =L= SoeBmax;
oaEQsoeBIBLLend(t,v)$(ord(t) eq card(t))..          soeBIB(t,v) =G= SoeBend;
oaEQsoeBIBseg(t,v)..                                soeBIB(t,v) =E= sum(j, soeBIBseg(t,v,j) );
oaEQsoeBIBsegUL(t,v,j)..                            soeBIBseg(t,v,j) =L= sum(i$(ord(i) eq ord(j)), RB(i+1) - RB(i) ) * SoeBmax;
oaEQchBIBULlin(t,v)..                               EtaB * ( chBDAfix(t) + chBIBplus(t,v) - chBIBminus(t,v) ) * DeltaT =L= sum(i$(ord(i) eq 1),FB(i)) * SoeBmax
                                                        - sum(i$(ord(i) ge 2), sum(j$(ord(j) eq ord(i)-1), ( SoeBiniSeg(j)$(ord(t) eq 1) + soeBIBseg(t-1,v,j)$(ord(t) > 1) ) * ( FB(i-1) - FB(i) ) / ( RB(i) - RB(i-1) ) ) ); 
oaEQdisBIBUL(t,v)..                                 chBIBminus(t,v) + disBIBplus(t,v) =L= ( 1 - xBIB(t,v) ) * 2 * PBmax;
oaEQchBIBUL(t,v)..                                  chBIBplus(t,v) + disBIBminus(t,v) =L= xBIB(t,v) * 2 * PBmax;
oaEQchplusBIBUL(t,v)..                              chBIBplus(t,v) + chBDAfix(t) =L= PBmax;
oaEQchminusBIBUL(t,v)..                             chBIBminus(t,v) =L= chBDAfix(t);
oaEQdisplusBIBUL(t,v)..                             disBIBplus(t,v) + disBDAfix(t) =L= PBmax;
oaEQdisminusBIBUL(t,v)..                            disBIBminus(t,v) =L= disBDAfix(t);

* Electrolyzer
oaEQelEIB(t,v)..        elEIB(t,v) =E= elEDAfix(t) + elEIBplus(t,v) - elEIBminus(t,v);
oaEQelEIBUL(t,v)..      elEIB(t,v) =L= PEmax * xEIB(t,v);
oaEQelEIBLL(t,v)..      elEIB(t,v) =G= ZetaH * PEmax * xEIB(t,v);
oaEQelhatEIBH2(t,v)..   elHatEIB(t,v) * DeltaT =E= chiHIB(t,v) * ThetaH;
oaEQelhatEIB(t,v)..     elHatEIB(t,v) =E= EtaE * elEIB(t,v) + BetaE * PEmax * xEIB(t,v);

* Linearization of the absolute value of dIB
oaEQyLLpos(t,v)..       y(t,v) =G= dIB(t,v);
oaEQyLLneg(t,v)..       y(t,v) =G= - dIB(t,v);
oaEQkktStat(t,v)..      1 - muPlus(t,v) - muMinus(t,v) =E= 0;
oaEQkktCS1(t,v)..       y(t,v) - dIB(t,v) =L= ( 1 - xPlus(t,v) ) * M;
oaEQkktCS2(t,v)..       muPlus(t,v) =L= xPlus(t,v) * M;
oaEQkktCS3(t,v)..       y(t,v) + dIB(t,v) =L= ( 1 - xMinus(t,v) ) * M;
oaEQkktCS4(t,v)..       muMinus(t,v) =L= xMinus(t,v) * M;

* Constraints associated with the dual robust subproblem
oaEQdualROprop(t,v,xi)$ScenActX(xi)..   deltaXI(v,xi) + zXI(t,v,xi) =G= 2 * LambdaDA(t) * KIB * y(t,v);

*========================================================
* MODEL OF THE PROPOSED PROBLEM - OUT-OF-SAMPLE ANALYSIS
*========================================================

MODEL proposedProblemOA
/
propOAEQof,
oaEQCVaR,
oaEQdIB, oaEQrIB, oaEQrIBUL, oaEQrIBLL,
oaEQresIBUL,
oaEQsoeBIB, oaEQsoeBIBUL, oaEQsoeBIBLLend, oaEQsoeBIBseg, oaEQsoeBIBsegUL, oaEQchBIBULlin, oaEQdisBIBUL, oaEQchBIBUL, oaEQchplusBIBUL, oaEQchminusBIBUL, oaEQdisplusBIBUL, oaEQdisminusBIBUL,
oaEQelEIB, oaEQelEIBUL, oaEQelEIBLL, oaEQelhatEIBH2, oaEQelhatEIB,
oaEQyLLpos, oaEQyLLneg, oaEQkktStat, oaEQkktCS1, oaEQkktCS2, oaEQkktCS3, oaEQkktCS4,
oaEQdualROprop
/;

*================================================================
* EQUATIONS OF THE HYBRID SP RO PROBLEM - OUT-OF-SAMPLE ANALYSIS
*================================================================

EQUATIONS

* Objective function
hsproOAEQof   Objective function of the hybrid SP RO problem (out-of-sample analysis)

* Constraints associated with the dual robust subproblem
oaEQdualRO        Equation associated with the dual robust subproblem
;

* Objective function
hsproOAEQof..   ofHSPROoa =E= sum(t, LambdaDA(t) * mpDA(t) + sum(v, LambdaDA(t) * dIB(t,v)
                    + LambdaH(t) * chiHIB(t,v) - LambdaW(t) * EtaW * chiHIB(t,v)
                    + LambdaDA(t) * KIB * y(t,v) - z(t,v) ) )
                    - sum(v(v), delta(v) * GammaIBscalar );

* Constraints associated with the dual robust subproblem
oaEQdualRO(t,v)..   delta(v) + z(t,v) =G= 2 * LambdaDA(t) * KIB * y(t,v);

*============================================================
* MODEL OF THE HYBRID SP RO PROBLEM - OUT-OF-SAMPLE ANALYSIS
*============================================================

MODEL hybridsproProblemOA
/
hsproOAEQof,
oaEQdIB, oaEQrIB, oaEQrIBUL, oaEQrIBLL,
oaEQresIBUL,
oaEQsoeBIB, oaEQsoeBIBUL, oaEQsoeBIBLLend, oaEQsoeBIBseg, oaEQsoeBIBsegUL, oaEQchBIBULlin, oaEQdisBIBUL, oaEQchBIBUL, oaEQchplusBIBUL, oaEQchminusBIBUL, oaEQdisplusBIBUL, oaEQdisminusBIBUL,
oaEQelEIB, oaEQelEIBUL, oaEQelEIBLL, oaEQelhatEIBH2, oaEQelhatEIB,
oaEQyLLpos, oaEQyLLneg, oaEQkktStat, oaEQkktCS1, oaEQkktCS2, oaEQkktCS3, oaEQkktCS4,
oaEQdualRO
/;
