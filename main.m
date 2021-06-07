clear all; close all;

%% Generieren des Eingangssignals
a = randi([-50, 50], 1, 50)/10;
lang = 500;
y= (eingangssignal(a, lang))';
plot(y)

%% Diskretisieren der Übertragungsfunktion

t = 0.001; % sample time 0.01
G = idtf([3.5855469499, 697.5768941], [1, 20.13605626, 1154.691589]);
H = idtf(c2d(G, t)); 

T =  (0:0.001:24.9999)';

v = zeros(size(y));
v = sim(H, y);
lsim(H, y, T);


%for k=0:49
%        y_y(1+k) = y(1+k*lang);
%end
    
               %%%(0:0.5:24.9999)' für 0.5 Sekunden       (1:50)' für 1 Sekunde
%save '-ascii' Eingangssignal.SIM data_Eingangssignal   

%% Rauschen

v_n = awgn(v, 20, 'measured');

%data_Eingangssignal_noise  = [T,v_n];  
%save '-ascii' Eingangssignal_noise.sim data_Eingangssignal_noise   

%% System Identifikation (Nachbildung system identification toolbox)

NN = struc(1:10,1:10,1:10);
data = iddata(v,y,t);
V = arxstruc(data(1:12500),data(12501:25000),NN);
order = selstruc(V,0);
H_est = arx(data,order);
%H_est = idtf(H_est.B, H_est.A);
G_est = idtf(d2c(H_est))
v_est = sim(H_est, y);
hold on;
lsim(H_est, y, T, 'red');
%noise_model = noise2meas(sys);
legend('Eingang','H','H_est')
fehler = v-v_est;
plot(fehler);

%% Eingangs-Ausgangssignal Laden und richtig zuschneiden!!
load Eingangssignal.sim
load Ausgangssignal.sim
%Eingangssignal = Eingangssignal(:,2);
%Ausgangssignal = Ausgangssignal([2:25001],2);
Eingangssignal_cell = con2seq(Eingangssignal');
Ausgangssignal_cell = con2seq(Ausgangssignal');

figure(2);
subplot(1,1,1)
plot([1:25000],Eingangssignal,[1:25000],Ausgangssignal);

%% System Identifikation (Mit aufgenommenen Messdaten)

NN = struc(1:8,1:8,1:10);
data = iddata(Ausgangssignal,Eingangssignal,t);
V = arxstruc(data(1:12500),data(12501:25000),NN);
order_aufg = selstruc(V,0);
H_est_aufg = arx(data,order_aufg)
lsim(H_est_aufg, Eingangssignal, T);
%H_est = idtf(H_est.B, H_est.A);
G_est_aufg = idtf(d2c(H_est_aufg, 'tustin'))

Aus_test = sim(H_est_aufg, Eingangssignal);
plot([1:25000],Eingangssignal,[1:25000],Aus_test,[1:25000],Ausgangssignal)
legend('Eingang','Berechnet','Ausgang');

%% Narx- Network anwenden

d1 = [1:2]; %inputDelays
d2 = [1:2]; %feedbackDelays
d3 = 10; %hiddenSizes
narx_net = narxnet(d1,d2,d3); %narxnet(inputDelays,feedbackDelays,hiddenSizes,feedbackMode,trainFcn)
narx_net.divideFcn = ''; % propertys change
narx_net.trainParam.min_grad = 1e-7; % Minimaler Gradient
[p,Pi,Ai,t] = preparets(narx_net,Eingangssignal_cell,{},Ausgangssignal_cell);
narx_net = train(narx_net,p,t,Pi);

yp = sim(narx_net,p,Pi);
e = cell2mat(yp)-cell2mat(t);
figure(3)
subplot(2,1,1)
plot([1:(length(yp))],cell2mat(yp),[1:(length(yp))],Ausgangssignal((25001-length(yp)):25000));
subplot(2,1,2)
plot(e) %Fehler für die seriell-parallele Implementierung
legend('Fehler der Implementierung')

narx_net_closed = closeloop(narx_net); %% eine close loop erzeugen

y1 = Eingangssignal_cell(1:25000);
u1 = Ausgangssignal_cell(1:25000);
[p1,Pi1,Ai1,t1] = preparets(narx_net_closed,u1,{},y1);
yp1 = narx_net_closed(p1,Pi1,Ai1);
TS = size(t1,2);
figure(4)
plot(1:TS,cell2mat(t1),'b',1:TS,cell2mat(yp1),'r',1:TS,Ausgangssignal(1:24998)) 



%% myNeuralNetworkFunction_narx anwenden

vers = myNeuralNetworkFunction_narx(Eingangssignal(1:24999)',Ausgangssignal(2:25000)',[1:2],[1:2]);
plot([1:24999],Eingangssignal(1:24999),[1:24999],Ausgangssignal(1:24999),[1:24999],vers);
legend('Eingangssignal','Ausgangssignal','Narx nachgebildet');

%% test 

%G_IDA = idtf([1.15755891560068E+0003,4.90478337339292E+0005,2.29252968538055E+0006,1.75134017476469E+0009,-7.14950006000000E+0009,4.66886403800000E+0011,-2.64484230000000E+0013,-9.75890334000000E+0014,-2.54025419500000E+0016], [2.80752936591187E+0004,4.01974334315503E+0005,1.13866264852561E+0008,6.74146626562733E+0008,6.55273176700000E+0010,-1.78936974900000E+0012,-6.85738494300000E+0013,-2.27397600800000E+0015,-4.70659314300000E+0016]);

%H_IDA = idtf(c2d(G_IDA, t)); 

%v_IDA = zeros(size(y));
%v_IDA = sim(H_IDA, y);
%lsim(H_IDA, y, T);