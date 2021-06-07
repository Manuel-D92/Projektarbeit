clc; clear all; close all;
xx= [2;2;2.5;3;3;4];
yy= [0;0.001;1.89;2;2.1;0];
syms a b s0 ym;
x = sym ('x',[length(xx) 1]);
y = sym ('y',[length(yy) 1]);
x0= [4,0]; iteration = 0; z=1; n=0; ks=0; x_x_k=[];
fprintf('Iteration |  Rho  |  mu   |  x_k   \n');
while(n==0)
M = (x-a).^2 + (exp(b.*(x.^2+y.^2)))-5; %Modell
F_x = subs(M,[x,y],[xx,yy]);
F_x_ab = [diff(F_x,a) diff(F_x,b)];%abgeleitende Funktion
F_x0 = subs(F_x,[a,b],x0);
F_x0_ab = subs(F_x_ab,[a,b],x0); % F'(x^0)
%lineare Ausgleichsproblem
J = subs([F_x0_ab;ym*eye(length(x0))],ym,(z)); %jakobi Matrix
A = [F_x0;zeros(length(x0),1)]; % A-Matrix mit nullen auffühlen
s0 = (J.'*J) \ (J.'*(-A)); %Normalgleichung lösen
x1 = double(x0.' + s0); % x_neu berechnen
F_x1 = subs(F_x,[a,b],x1.'); % F_neu erstellen
F_x0_F_x0_ab_s0= F_x0 + F_x0_ab * s0;
p_m0 = (((F_x0.'*F_x0) - (F_x1.'*F_x1)) / ((F_x0.'*F_x0) - (F_x0_F_x0_ab_s0.'*F_x0_F_x0_ab_s0))); % Rho berechnen
p_m = double(p_m0); 
if x1(1)==x0(1) % Abruchbedigung (wenn es sich nicht mehr stark verändert)
    n=1;
end
if p_m<=0.2 % Auswahl Kriterium
    z = z*2;
    iteration = -1;
elseif p_m>0.2 && p_m>0.8
    x0=x1';
    z= z/2;
    iteration = iteration +1;
elseif p_m>0.2 
    x0=x1';
    %z= z-1;
    iteration = iteration +1;
end
ks=ks+1; 
x_x_k(:,ks) = [x1;p_m];
fprintf('0  |   0    |    0     |   %d\n',x1(1)); %Ausgabe
fprintf('%d| %d |%d |%d\n\n',iteration,p_m, z,x1(2)); %Ausgabe
end
a_min = x1(1); b_min = x1(2);
syms x y;
MM = (x-a).^2 + (exp(b.*(x.^2+y.^2)))-5;
y_lev = solve(MM==0,y);
yy_lev= (subs(y_lev(1,1),[a,b],[a_min,b_min]));
y_Levenberg = real(double(subs(yy_lev,x,xx)))
plot(xx,y_Levenberg,xx,yy)
legend('Levenberg','Eingangssignal');