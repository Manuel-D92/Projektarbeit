clc; clear all; close all;
%% on/off switch (Auswahl zwischen 60 verschieden Signale)
training_mit_Uebertragungsfunktion =0; % 1= NN training ohne reellen Motordaten
Anfangswert=1;                      Auto_FD= 0;% Autocorellations berechnung für Feedback Delays
% Anfangswert=1 -> Anfangswertinitalisierung werden auf rng(0) (immer der gleich Random satz) gesetzt; 
% Anfangswert=0 -> Anfangswertinitalisierung wird immer neu generiert

abtastzeit_0_001=1; %
abtastzeit_0_029=0; %Nur eins von dreien Auswählen
abtastzeit_0_0029=0;%

Begrenzung =0; % Mit Sättigung (bis 9V) = 1; Begrenzung (max 5V) = 0;

Noise = 0; %(Rauschen =1 an, Rauschen =0 aus) nur 0.001!!!

Eingangssignal_Rauschen=0;         %
Ausgangssignal_Rauschen=1;         %Nur eins von dreien Auswählen
Ein_und_Ausgangssignal_Rauschen=0; %

N10_db=0; %
N20_db=0; %Nur eins von dreien Auswählen
N40_db=1; %

Narx_closed = 1; %(0 ohne Multi-step; 1 mit Multi-step)

Vergleich_mit_Uebertragungsfunktion=0; % Vergelich mit einer bereits vorhandender Übertragungsfunktion = 1;

aufloesung=0.1;%%Auflösung für divideFcn Schrittwieite zum B. bei 0.1 -> 0.9, 0.8, 0.7 ....0 
%%
if(abtastzeit_0_029) % sample time 0.001
    t_abt = 0.029;
elseif(abtastzeit_0_0029)
    t_abt = 0.0029;
elseif(abtastzeit_0_001)
    t_abt = 0.001;
end

[Eingangssignal Ausgangssignal] = Ein_Ausgangssignal_erstellen(abtastzeit_0_001,abtastzeit_0_029,abtastzeit_0_0029,Noise,Eingangssignal_Rauschen,Ausgangssignal_Rauschen,Ein_und_Ausgangssignal_Rauschen,N10_db,N20_db,N40_db,Begrenzung);
if(Noise==1)
[Eingangssignal_orginal Ausgangssignal_orginal] = Ein_Ausgangssignal_erstellen(abtastzeit_0_001,abtastzeit_0_029,abtastzeit_0_0029,0,Eingangssignal_Rauschen,Ausgangssignal_Rauschen,Ein_und_Ausgangssignal_Rauschen,N10_db,N20_db,N40_db,Begrenzung);
end

% load Stufensignal;
% Eingangssignal =y;
%  Eingangssignal= 7 * sin((0:0.0029:0.552)*2*pi*4)';  %%sinus erzeugen
if(training_mit_Uebertragungsfunktion==1)
    bis = t_abt*length(Eingangssignal)-t_abt;
    T =  (0:t_abt:bis)';
    G = tf([3.5855469499, 697.5768941], [1, 20.13605626, 1154.691589]);
    H = tf(c2d(G, t_abt));
    Ausgangssignal = lsim(H, Eingangssignal, T);
    if(Noise==1)
        bis = t_abt*length(Eingangssignal_orginal)-t_abt;
        T =  (0:t_abt:bis)';
        G = tf([3.5855469499, 697.5768941], [1, 20.13605626, 1154.691589]);
        G1= tf([-2.54025419500000E+0016, -9.75890334000000E+0014,-2.64484230000000E+0013, 4.66886403800000E+0011,-7.14950006000000E+0009, 1.75134017476469E+0009, 2.29252968538055E+0006, 4.90478337339292E+0005, 1.15755891560068E+0003, 2.35393359430539E+0001, 3.26729222581577E-0002],[-4.70659314300000E+0016,-2.27397600800000E+0015,-6.85738494300000E+0013,-1.78936974900000E+0012, 6.55273176700000E+0010,6.74146626562733E+0008, 1.13866264852561E+0008, 4.01974334315503E+0005, 2.80752936591187E+0004,5.38371419173595E+0001, 1]);
        H = tf(c2d(G, t_abt));
        Ausgangssignal = lsim(H, Eingangssignal_orginal, T);
        rauschen =0;
        if(N10_db==1) rauschen =10;elseif(N20_db==1) rauschen = 20;elseif(N40_db==1) rauschen = 40; end
        if(Eingangssignal_Rauschen==1) Ausgangssignal_orginal=Ausgangssignal; Eingangssignal =  addGaussianNoise([Eingangssignal_orginal],rauschen); elseif(Ausgangssignal_Rauschen==1) Ausgangssignal_orginal=Ausgangssignal; Ausgangssignal =  addGaussianNoise([Ausgangssignal],rauschen); elseif(Ein_und_Ausgangssignal_Rauschen==1) Ausgangssignal_orginal=Ausgangssignal; Eingangssignal =  addGaussianNoise([Eingangssignal_orginal],rauschen);Ausgangssignal =  addGaussianNoise([Ausgangssignal],rauschen) ;end
    end
end
figure(10)
plot([1:length(Eingangssignal)],Eingangssignal,[1:length(Ausgangssignal)],Ausgangssignal);

%%Eingangssignal = [Eingangssignal Ausgangssignal];
Eingangssignal_cell = con2seq(Eingangssignal');
Ausgangssignal_cell = con2seq(Ausgangssignal');  
%noise = [Eingangssignal addGaussianNoise([ Ausgangssignal],10)]; 
%save noise_10db noise;

%% Übertragungsfunktion anzeigen
if(1==Vergleich_mit_Uebertragungsfunktion && Begrenzung==0)
    %t_abt= 0.029
    bis = t_abt*length(Eingangssignal)-t_abt;
    T =  (0:t_abt:bis)';
    G = tf([3.5855469499, 697.5768941], [1, 20.13605626, 1154.691589]);
    H = tf(c2d(G, t_abt));
    Ausgangssignal_ue = lsim(H, Eingangssignal, T);
end
%% AutoKorrelation für Feedbacks delay (nur ein Vorschlag)

if(Auto_FD==1)
    
 T = Eingangssignal_cell;
 t  = cell2mat(T);
 plt=0;
 whos
 [ O N ] = size(T)           % [ 1 100]
 Neq     = prod(size(T))     % 100
 rng(0)
 for k = 1:100
    n                = randn(1,N);
    autocorrn        = nncorr(n,n,N-1,'biased');
    sortabsautocorrn = sort(abs(autocorrn));
    M                = floor(0.95*(2*N-1))  % 189
    thresh95(k)      = sortabsautocorrn(M);
 end
 sigthresh95 = mean(thresh95)  % 0.2194
 zt          = zscore(t,1);
 autocorrzt  = nncorr(zt,zt,N-1,'biased');
 lags        = 0:N-1;
 siglags     = -1+find(abs(autocorrzt(N:end))>sigthresh95);
 plt = plt+1, figure(plt)     % Fig 1
 hold on
 plot( zeros(1,N), 'k--', 'LineWidth', 2 )
 plot(sigthresh95*ones(1,N), 'r--', 'LineWidth', 2 )
 plot(-sigthresh95*ones(1,N), 'r--', 'LineWidth', 2 )
 plot( lags, autocorrzt(N:end), 'LineWidth', 2 )
 plot( siglags, autocorrzt(N+siglags), 'o', 'LineWidth', 2 )    
    
end

%plot([1:25000],Eingangssignal,[1:25000],Ausgangssignal);

%% Narx- Network anwenden
zweierPotenz=[];
n_sch= 1;%Schrittweite für i*n
ste=1;
for i=1:ste
time_data_1(i,1) = datetime;

d1 = [1:2]; %inputDelays 1:8 | 1:2
d2 = [1:2]; %feedbackDelays 1:8 | 1:2
d3 = 13; %hiddenSizes(i,1) 33 | 27

zweierPotenz(i)=i;
narx_net = narxnet(d1,d2,d3); %narxnet(inputDelays,feedbackDelays,hiddenSizes,feedbackMode, standart openloop z.b trainFcn('closed'))

%%
narx_net.performFcn = 'mse'; % SSE or MSE or (SAE,MAE,crossentropy und msesparse)

%narx_net = fitnet;
%%
%narx_net.trainParam.showWindow(false);
%narx_net.trainParam.showCommandLine(true);

narx_net.trainFcn = 'trainbr';  %change the algorthm 
narx_net.layers{1}.transferFcn = 'purelin'; %change Activation Function
narx_net.layers{2}.transferFcn = 'purelin'; %change Activation Function
narx_net.trainParam.min_grad = 1e-20; % Minimaler Gradient bei purelin linear auf 1e-20 stellen
%%narx_net.performParam.regularization = 0.5; %%Einstellung der
%Regulierungen ohne Bayesian

narx_net.divideFcn = 'dividerand'; % propertys change dividetrain (100% Training, 0%Validation, 0%Test)  dividerand
%[trainInd, valInd, testInd] = divideint (25000,0.7,0.15,0.15);
% trainRatio = (i*aufloesung)
% valRatio = 0.5-(aufloesung/2)*i
% testRatio  = 0.5-(aufloesung/2)*i
narx_net.divideParam.trainRatio = 0.7;   %trainRatio; %dividerand  %divideblock
narx_net.divideParam.valRatio = 0.15;   %valRatio;
narx_net.divideParam.testRatio = 0.15;  %testRatio;

%narx_net.divideParam.trainInd = [300:350 ,500: 800 ];
%narx_net.divideParam.valInd   = [1: 499];
%narx_net.divideParam.testInd  = [801: 863];

%% Statisch Anfangswerte Open loop
if(Anfangswert==1)
rng(957) %%%% Verwendet immer denn ersten Randn satz == ist immer gleich  957
% getwb und setwb
narx_net = init(narx_net);
elseif(Anfangswert==0)
%%narx_net = init(narx_net);
end
%narx_net.trainParam.max_fail = 6;
%narx_net.trainParam.mu_max = 1e10;
%narx_net.trainParam.showWindow =false;
%narx_net.trainParam.showCommandLine=true;
[p,Pi,Ai,t] = preparets(narx_net,Eingangssignal_cell,{},Ausgangssignal_cell); % p = Verschobene Eingänge 

% Pi = 	Anfangszustaende der Eingangsverzögerung Ai = Anfangszustaende der Schichtverzögerung 
% t = Verschobene Ziele (Targets)
%load Narx_net;
[narx_net,tr] = train(narx_net,p,t,Pi,Ai);  % adapt->Inkrementelles Training mit Anpassung, train-> Batch-Modus Training
y = narx_net(p);
[r,m,b] = regression(t,y);% Regressions Information
%save Narx_net narx_net;
yp = sim(narx_net,p,Pi); % simuliert das Narx system
e = cell2mat(yp)-cell2mat(t);% Fehler zwischen NN-Ausgang und Targets

m_s_e_02_zum_unverrauschtem_Signal=0;
if(Noise==1) %% beim Rauschen Fehler berechnen zwischen NN-Ausgang und dem unverrauschten Ausgangssignal 
e_eingang_ohne_rausch = std(cell2mat(yp)-Ausgangssignal_orginal((((length(Ausgangssignal)+1))-length(yp)):(length(Ausgangssignal)))');
m_s_e_02_zum_unverrauschtem_Signal= mse(cell2mat(yp)-Ausgangssignal_orginal((((length(Ausgangssignal)+1))-length(yp)):(length(Ausgangssignal)))');
std_eingang_ohne_rauschen(i,1)=e_eingang_ohne_rausch;
end

clear var
m_s_e_01 = mse(e);
m_s_e_03=0;
if(Noise==1)
m_s_e_03 = mse(Eingangssignal-Eingangssignal_orginal);
end
var = var(e);
e_ari = mean(e);
standardabweichung = std(e);
%figure(3)
%subplot(2,1,1)
%h= plot([1:(length(yp))],cell2mat(yp),'red');
%set(h,'LineWidth',2.8);
%hold on
%plot([1:(length(yp))],Ausgangssignal((25001-length(yp)):25000),'black' ,'LineWidth',0.8)
%%plot([1:(length(yp))],cell2mat(yp),'red ',[1:(length(yp))],Ausgangssignal((25001-length(yp)):25000),'Black .');

if(i==ste)
    figure(2)
    plot([1:(length(yp))],cell2mat(yp),[1:(length(yp))],Ausgangssignal((((length(Ausgangssignal)+1)-length(yp)):(length(Ausgangssignal)))),'g o');
    hold on
    if(1==Vergleich_mit_Uebertragungsfunktion && Begrenzung==0)
        plot([1:(length(yp))],test((((length(Ausgangssignal)+1)-length(yp)):(length(Ausgangssignal)))),'green');
        legend('NN-Ausgangssignal','Ausgangssignal','mit Übertragungsfunktion');
    else
        legend('NN-Ausgangssignal','Ausgangssignal');
    end
    if(Noise==1)
        plot([1:(length(yp))],Ausgangssignal_orginal((length(Ausgangssignal_orginal)-length(yp)+1):length(Ausgangssignal_orginal)))
        legend('NN-Ausgangssignal','Ausgangssignal','Orginal Ausgangssignal');
        hold on
    end
end

%title('Bayesian Regularization')
%xlabel('Abtastwert')
%ylabel('Spannung')
%legend('NN-Ausgangssignal','Ausgangssignal');
%subplot(2,1,2)
%plot(e) %Fehler für die seriell-parallele Implementierung
%legend('Fehler der Implementierung')
% 
time_data_2(i,1) = datetime;
time_data_3(i,1) = between(time_data_1(i),time_data_2(i));

iter(i,1) = tr.best_epoch;
varianz(i,1)= var;
e_max(i,1) = max(e);
e_min(i,1) = min(e);
R_spann(i,1) = max(e)-min(e);
Mittelwert(i,1) =  e_ari;
Standardab(i,1) = standardabweichung;
mean_squared_error_01(i,1) = m_s_e_01;
end

if(Noise==1) 
tre = [tr.mu; tr.perf; tr.time; tr.gradient];
save alles mean_squared_error_01 m_s_e_02_zum_unverrauschtem_Signal Mittelwert Standardab varianz R_spann e_max e_min iter std_eingang_ohne_rauschen time_data_1 time_data_2 time_data_3 narx_net tre; 
else
tre = [ tr.perf; tr.time; tr.gradient]; %%tr.mu;
save alles mean_squared_error_01 Mittelwert Standardab varianz R_spann e_max e_min iter time_data_1 time_data_2 time_data_3 narx_net tre; 
end
%Narx_close

if(Narx_closed==1)
narx_net_closed = closeloop(narx_net); %% eine close loop erzeugen
%view(narx_net);


%save Narx_net_1 narx_net;

y1 = Eingangssignal_cell(1:(length(Eingangssignal)));
u1 = Ausgangssignal_cell(1:(length(Ausgangssignal)));
%%narx_net_closed = narxnet(d1,d2,d3); %narxnet(inputDelays,feedbackDelays,hiddenSizes,feedbackMode,trainFcn)
%%narx_net_closed.divideFcn = ''; % propertys change
%%narx_net_closed.trainParam.min_grad = 1e-5; % Minimaler Gradient
[p1,Pi1,Ai1,t1] = preparets(narx_net_closed,Eingangssignal_cell,{},Ausgangssignal_cell);

yp1 = narx_net_closed(p1,Pi1,Ai1);

closedLoopPerformance = perform(narx_net_closed,t1,yp1);

%[y,xf,af]=narx_net(p,pi,Ai);

[narx_net_closed,tr_closed] = train(narx_net_closed,p1,t1,Pi1,Ai1);

figure(4)
yp11 = sim(narx_net_closed,Eingangssignal_cell); % simuliert das Narx system
aus = Ausgangssignal;
plot([1:(length(yp11))],cell2mat(yp11),[1:(length(yp11))],aus(((length(Eingangssignal))-length(yp11)+1):(length(Eingangssignal))),'g o');
legend('closed-loop NN','orginal Ausgangssignal')
hold on
m_s_e_close_loop_02_zum_unverrauschtem_Signal=0;
if(Noise == 1 && Eingangssignal_Rauschen==0)
    plot(Ausgangssignal_orginal(((length(Eingangssignal))-length(yp11)+1):(length(Eingangssignal))));
    legend('closed-loop NN','Ausgangssignal','orginal Ausgangssignal') 
    m_s_e_close_loop_02_zum_unverrauschtem_Signal= mse(cell2mat(yp11)-Ausgangssignal_orginal');
elseif(Noise == 1 && Eingangssignal_Rauschen==1)
    plot(Eingangssignal)
    legend('closed-loop NN','Ausgangssignal','verrauschtest Eingangssignal') 
    m_s_e_close_loop_02_zum_unverrauschtem_Signal= mse(cell2mat(yp11)-Ausgangssignal_orginal');
end

e_close_loop = cell2mat(yp11(1:length(yp11)))-cell2mat(Ausgangssignal_cell(1:length(yp11)));
clear var
m_s_e_close_loop_01 = mse(e_close_loop);
var_close_loop = var(e_close_loop);
e_ari_close_loop = mean(e_close_loop);
standardabweichung_close_loop = std(e_close_loop);
iter_close_loop(i,1) = tr_closed.best_epoch;
e_max_close_loop(i,1) = max(e_close_loop);
e_min_close_loop(i,1) = min(e_close_loop);

tre_closed = [tr_closed.mu; tr_closed.perf; tr_closed.time; tr_closed.gradient];
save alles_closed m_s_e_close_loop_01 m_s_e_close_loop_02_zum_unverrauschtem_Signal e_ari_close_loop standardabweichung_close_loop var_close_loop e_max_close_loop e_min_close_loop iter_close_loop narx_net_closed tre_closed; 
end

%% simulink_Model erstellen
%[sysName,netName] = gensim(narx_net_closed,'InputMode','Workspace','OutputMode','WorkSpace','SolverMode','Discrete');
%setsiminit(sysName,netName,narx_net_closed,Pi1,Ai1,1);
%x1 = nndata2sim(Eingangssignal_cell,1,1);
%[xi,ai]= getsiminit(sysName,netName,narx_net_closed);

%%
%plot(1:25000,(y1),1:25000,cell2mat(Eingangssignal_cell))

%TS = size(t1,2);
%figure(5)
%plot(1:TS,cell2mat(t1),'b',1:TS,cell2mat(yp1),'r',1:TS,Ausgangssignal((25001-TS):25000)) 

%% simulieren des NN (oben trainiert)

%A_narx_net_p{1}= Eingangssignal(3:25000)';
%A_narx_net_p{2}=Ausgangssignal(3:25000)';
%p_narx_net = con2seq(A_narx_net_p');
%A_narx_net{1}= Eingangssignal(1:2)';
%A_narx_net{2}=Ausgangssignal(1:2)';
%Pi_narx_net = con2seq(A_narx_net')

%plot(cell2mat(sim(narx_net,p_narx_net,Pi_narx_net)))


%% myNeuralNetworkFunction_narx anwenden (statisch)

%vers = myNeuralNetworkFunction_narx(Eingangssignal(1:24999)',Ausgangssignal(2:25000)',[1:2],[1:2]);
    %x=[Eingangssignal(1:24999)];
    %y=Ausgangssignal(2:25000);
%plot([1:24999],Eingangssignal(1:24999),[1:24999],Ausgangssignal(1:24999),[1:24999],vers);
%legend('Eingangssignal','Ausgangssignal','Narx nachgebildet');

%% für simulink model (open_loop)
IW_1_open = [narx_net.IW{1,1}];
IW_2_open = [narx_net.IW{1,2}];

B_1_open = [[narx_net.b{1}]]; %%(0.001*ones(10, 1))
B_2_open = [[narx_net.b{2}]];
%pi_input_1_delayed_2%[narx_net.b{2}]

LW_1_open= [narx_net.LW{1}];
LW_2_open= [narx_net.LW{2}];


if(t_abt==0.001)
Eingangssignal_model = [(0:t_abt:25-t_abt)',Eingangssignal];
Ausgangssignal_w_model =[(0:t_abt:(25-t_abt-t_abt))',Ausgangssignal(1:length(Ausgangssignal)-1)];
Ausgangssignal_model = [(0:t_abt:(25-t_abt-t_abt))',Ausgangssignal(2:length(Ausgangssignal))];
elseif(t_abt==0.029)
Eingangssignal_model = [(0:t_abt:25)',Eingangssignal];
Ausgangssignal_w_model =[(0:t_abt:(25-t_abt))',Ausgangssignal(1:length(Ausgangssignal)-1)];
Ausgangssignal_model = [(0:t_abt:(25-t_abt))',Ausgangssignal(2:length(Ausgangssignal))];
elseif(t_abt==0.0029)
Eingangssignal_model = [(0:t_abt:25)',Eingangssignal];
Ausgangssignal_w_model =[(0:t_abt:(25-t_abt))',Ausgangssignal(1:length(Ausgangssignal)-1)];
Ausgangssignal_model = [(0:t_abt:(25-t_abt))',Ausgangssignal(2:length(Ausgangssignal))];
end
%für simulink model (close_loop)

if(Narx_closed==1)
IW_1_close = [narx_net_closed.IW{1,1}];

B_1_close = [[narx_net_closed.b{1}]]; %%(0.001*ones(10, 1))
B_2_close = [[narx_net_closed.b{2}]];
%pi_input_1_delayed_2%[narx_net.b{2}]

LW_1_2_close= [narx_net_closed.LW{1,2}];
LW_2_1_close= [narx_net_closed.LW{2,1}];
end

if(ste>1)
figure(6)
plot(zweierPotenz,Standardab,'r o-') %%,[1:length(Standardab)]*n_sch    %%für dvidieFcn = [aufloesung:aufloesung:(1-aufloesung)],
hold on
plot(zweierPotenz,e_min,'-') %%für dvidieFcn = [aufloesung:aufloesung:(1-aufloesung)],
hold on
plot(zweierPotenz,e_max,'-.') %%für dvidieFcn = [aufloesung:aufloesung:(1-aufloesung)],
xlabel('Hidden Sizes')
ylabel('Standardabweichung')
%legend('trainlm mit purlin/purlin');

figure(7)
plot(zweierPotenz,split(time_data_3,{'time'}),'b o-')
xlabel('Hidden Sizes')
ylabel('Trainingszeit')
legend('trainlm mit purlin/purlin');

figure(8)
plot(mean_squared_error_01); %%für dvidieFcn = [aufloesung:aufloesung:(1-aufloesung)],
end