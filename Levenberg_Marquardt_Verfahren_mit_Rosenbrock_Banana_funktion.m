clc; 
clear all;
close all;

load Eingangssignal.sim
load Ausgangssignal.sim

%Eingangssignal(2901,2);
%Ausgangssignal(2901,2);

%xx = [Eingangssignal(2901,2);Eingangssignal(1401,2);Eingangssignal(2401,2);Eingangssignal(400,2);Eingangssignal(901,2);Eingangssignal(1901,2)];
%yy = [Ausgangssignal(2901,2);Ausgangssignal(1401,2);Ausgangssignal(2401,2);Ausgangssignal(400,2),;Ausgangssignal(901,2);Ausgangssignal(1901,2)];

%%xx = [Eingangssignal(1201,2);Eingangssignal(2201,2);Eingangssignal(200,2);Eingangssignal(5701,2);Eingangssignal(701,2);Eingangssignal(1701,2)];
%%yy = [Ausgangssignal(1201,2);Ausgangssignal(2201,2);Ausgangssignal(200,2);Ausgangssignal(5701,2);Ausgangssignal(701,2);Ausgangssignal(1701,2)];


xx= [1.5;2;2.5;3;3;4];
yy= [5;4.001;3.89;2;2.1;0];

syms a;
syms b;
x = sym ('x',[length(xx) 1]);
y = sym ('y',[length(yy) 1]);
syms ym;
x0= [1,100];
iteration = 0;
z=0;

n=0;
k=0;
x_x_k=[];
%for k=0:20
while(n==0)
%x0= x1';
%Modell
M = (a-x).^2 + b.*(y-x.^2).^2;

F_x = subs(M,[x,y],[xx,yy]);

F_x_ab = [diff(F_x,a) diff(F_x,b)];

F_x0 = subs(F_x,[a,b],x0);

F_x0_ab = subs(F_x_ab,[a,b],x0); % F'(x^0)

%lineare Ausgleichsproblem
syms s0;

J = subs([F_x0_ab;ym*eye(length(x0))],ym,(2^z));% jakoby_matrix erstellen
A = [F_x0;zeros(length(x0),1)]; % A_matrix erstellen

s0 = (J'*J) \ (J'*(-A)); %lineare Ausgleichsproblem lösen

x1 = double(x0' + s0)% x1 erstellen

F_x1 = subs(F_x,[a,b],x1');

F_x0_F_x0_ab_s0= F_x0 + F_x0_ab * s0;

p_m0 = (((F_x0'*F_x0) - (F_x1'*F_x1)) / ((F_x0'*F_x0) - (F_x0_F_x0_ab_s0'*F_x0_F_x0_ab_s0)));
2^z
p_m = double(p_m0)

if x1(1)==x0(1)
    n=1;
end

if p_m<=0.2
    z = z+1;
elseif p_m>0.2
    x0=x1';
    z= z-1;
    iteration = iteration +1;
end
k=k+1
x_x_k(:,k) = [x1;p_m];


end

a_min = x1(1);
b_min = x1(2);

%a_min = 3.915042527;
%b_min = 0.102917979;

syms x;
syms y;

MM = (a-x).^2 + b.*(y-x.^2).^2;
y_lev = solve(MM==0,y);
yy_lev= (subs(y_lev(1,1),[a,b],[a_min,b_min]));
y_Levenberg = real(double(subs(yy_lev,x,xx)))

%plot([1:length(y_Levenberg)],y_Levenberg,[1:length(y_Levenberg)],yy);
plot(xx,y_Levenberg,xx,yy)
legend('Levenberg','Eingangssignal');
