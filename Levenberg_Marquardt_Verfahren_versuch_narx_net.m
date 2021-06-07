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


xx= [2;3;4];
yy= [0;2;0];

syms a IW LW_1 LW_2;
syms b b1 b2;
x = sym ('x',[length(xx) 1]);
y = sym ('y',[length(yy) 1]);
syms ym;
x0= [4,1,1,1,1];
iteration = 0;
z=1;

n=0;
k=0;
x_x_k=[];
for k=0:20
%while(n==0)
%x0= x1';
%Modell
%M = (x-a).^2 + (exp(b.*(x.^2+y.^2)))-5;
M = (((2/1+exp(-2*(IW.*x+b1+y.*LW_1)))-1).*(LW_2))+b2;

F_x = subs(M,[x,y],[xx,yy]);

F_x_ab = [diff(F_x,b1) diff(F_x,b2) diff(F_x,IW) diff(F_x,LW_1) diff(F_x,LW_2)];

F_x0 = subs(F_x,[b1,b2,IW,LW_1,LW_2],x0);

F_x0_ab = subs(F_x_ab,[b1,b2,IW,LW_1,LW_2],x0); % F'(x^0)

%lineare Ausgleichsproblem
syms s0;

J = subs([F_x0_ab;ym*eye(length(x0))],ym,(z));
A = [F_x0;zeros(length(x0),1)];

s0 = (J'*J) \ (J'*(-A)); % lineare Ausgleichsproblem

x1 = double(x0' + s0);

F_x1 = subs(F_x,[b1,b2,IW,LW_1,LW_2],x1');

F_x0_F_x0_ab_s0= F_x0 + F_x0_ab * s0;

p_m0 = (((F_x0'*F_x0) - (F_x1'*F_x1)) / ((F_x0'*F_x0) - (F_x0_F_x0_ab_s0'*F_x0_F_x0_ab_s0)));

p_m = double(p_m0);

if x1(1)==x0(1)
    n=1;
end

if p_m<=0.2
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
k=k+1
x_x_k(:,k) = [x1;p_m];

%{'Iterationen','   p_uk   ','  ym  ','  x1  '}
[0 0 0 x1(1);iteration p_m z x1(2)]
end

b1_min = x1(1);
b2_min = x1(2);
IW_min = x1(3);
LW_1_min = x1(4);
LW_2_min = x1(5);

%a_min = 3.915042527;
%b_min = 0.102917979;

syms x;
syms y;

MM = (((2/1+exp(-2*(IW.*x+b1+y.*LW_1)))-1).*(LW_2))+b2;
y_lev = solve(MM==0,y);
%yy_lev= (subs(y_lev(1,1),[b1,b2,IW,LW_1,LW_2],[b1_min,b2_min,IW_min,LW_1_min,LW_2_min]));
%y_Levenberg = real(double(subs(yy_lev,x,xx)))

%plot([1:length(y_Levenberg)],y_Levenberg,[1:length(y_Levenberg)],yy);
%plot(xx,y_Levenberg,xx,yy)
%legend('Levenberg','Eingangssignal');
