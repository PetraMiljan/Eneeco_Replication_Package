* Código empleado para crear pausas;

* Comienza a contar el tiempo de ejecución.
scalar starttime; starttime = jnow

SCALARS
TiempoEspera    tiempo de espera después de crear\modificar gdx [s]     /3/
AUX
;

VARIABLES
xPAUSA
zPAUSA
;

xPAUSA.lo = 0;

EQUATIONS
of
;

of..    zPAUSA =E= xPAUSA;

MODEL codigoPausa /of/;

SOLVE codigoPausa minimizing xPAUSA using lp;
AUX = sleep(TiempoEspera);
DISPLAY AUX;

* Termina de contar el tiempo de ejecución.
scalar elapsed; elapsed = (jnow - starttime)*24*3600; display elapsed;
