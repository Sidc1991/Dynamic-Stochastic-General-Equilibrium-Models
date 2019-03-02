//Reproducing figure 3-5, Galì(2002)

//define 14 endogenous variables and 1 exogenous variables
var y, a, x, yn, pi, p, i, r, rn, n, m, ry, iy, piy ;

//description: y= output, yn=natural level of output, x=output gap,
//p=price level, pi=rate of inflation, i=nominal interest rate,
//r=real interest rate, rn=natural level of real interest rate,
//n= level of employment, m= money balance
//ry,iy,piy=annualised values of real & nominal int, and inflatio
//a=log productivity

//2 exogenous variables
varexo a_m, e_m;

//description: e_a=tech shock, e_m= monetary shock

parameters BETA,THETA,SIGMA,PHI,EPSILON,ETA,RHO_M,RHO,LAMBDA,KAPPA,PSI_A;

BETA = 0.99;
THETA = 0.75;
SIGMA = 1;
PHI = 1;
EPSILON = 11;
ETA = 4;
RHO_M = 0.5;
RHO = -log(BETA);
LAMBDA = THETA^(-1)*((1-THETA)*(1-(BETA*THETA)));
KAPPA = LAMBDA*(SIGMA+PHI);
PSI_A = (1 + PHI)/(SIGMA + PHI);

model;
pi = BETA*x(+1) + KAPPA*x;                  //Neo Keynesian Phillips Curve
x = x(+1) - (1/SIGMA)*(i - x(+1) - rn);     //Dynamic IS Curve
pi = p - p(-1);                             //inflation rate at time t
y = a + n;                                  //production function
yn = PSI_A*a;                               //natural rate of output
x = y - yn;                                 //output gap
rn = RHO + SIGMA*PSI_A*(a(+1) - a);         //ntural real interest rate
r = i - pi(+1);                             //real interest rate
m = p + y - ETA*i;                          //money demand
(m - m(-1)) = RHO_M*(m(-1) - m(-2)) + e_m;  //money growth
a = a(-1) + a_m;                            //technology shock
iy   = 4*i ;                                // anualized
ry   = 4*r ;                                // anualized
piy  = 4*pi ;                               // anualized
end;


initval; 
a     = 0;
x     = 0;
y     = 0;
yn    = 0;
m     = 0;
n     = 0;
p     = 0;
pi    = 0;
i     = RHO;
rn    = RHO;
r     = RHO;
ry    = 4*r;
iy    = 4*i;
piy   = 4*pi;
end;

steady;
check;

shocks;
var e_m; stderr 1;
var a_m; stderr 1;
end;

//model simulation
stoch_simul (irf=30, order=1);

//The graphs plotted are responses to a monetary policy shocks
figure (1);
subplot(4,1,1); plot(piy_e_m,'-o'); title ('Inflation'); axis ([1 24 0 2.5]);
subplot(4,1,2); plot(y_e_m,'-o'); title ('Output'); axis ([1 24 0 1.5]);
subplot(4,1,3); plot(ry_e_m,'-o'); title ('Real Rate'); axis ([1 24 -1.5 0]);
subplot(4,1,4); plot(iy_e_m,'-o'); title ('Nominal Rate'); axis ([1 24 0 0.8]);
subtitle ('Figure 1:Responses to a Monetary Shock, Money Growth Rule');

//The graphs plotted are responses to a technology shock
figure (2);
subplot(4,1,1); plot(piy_a_m,'-o'); title ('Inflation'); axis ([1 24 -1.5 0]);
subplot(4,1,2); plot(x_a_m,'-o'); title ('Output Gap'); axis ([1 24 -0.8 0]);
subplot(4,1,3); plot(y_a_m,'-o'); title ('Output'); axis ([1 24 0.2 1]);
subplot(4,1,4); plot(n_a_m, '-o'); title ('Employment'); axis ([1 24 -0.8 0]);
subtitle ('Figure 2:Responses to a Technology shock');

