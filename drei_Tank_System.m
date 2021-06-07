training_sim = 0; %%training =0; simulieren =1;
if(training_sim==0)
    clc; clear all; close all;
end
training_sim = 0;
%%
Anfangswert=1;                      Auto_FD= 0;% Autocorellations berechnung für Feedback Delays
Narx_closed=1;

abgegrenzte_Signale = 0; %% 0 = ohne NULL Signal abgrenzung, 1 = Mit einem Null Signal zwischen jedem Singalsequentz abgegrenzt
saett = 0; % 0 ohne sättigung 

if(training_sim==0)
    %% Trainingsdaten
    if(abgegrenzte_Signale==0&&saett==0)
        load nichtlinear_X1_X2_X3_Y1_Y2_lang_3 %%ohne 0 Signal abgrenzung
    elseif(abgegrenzte_Signale==1&&saett==0)
        load nichtlinear_X1_X2_X3_Y1_Y2_lang_4 %%Mit einem 0 Signal zwischen jedem Singalsequentz abgegrenzt
    elseif(abgegrenzte_Signale==0&&saett==1)
        load nichtlinear_X1_X2_X3_Y1_Y2_lang_3_saett %%ohne 0 Signal abgrenzung
    elseif(abgegrenzte_Signale==1&&saett==1)
        load nichtlinear_X1_X2_X3_Y1_Y2_lang_4_saett %%Mit einem 0 Signal zwischen jedem Singalsequentz abgegrenzt
    end
    
else
    %% Testdaten
    if(saett==0)
        load nichtlinear_X1_X2_X3_Y1_Y2
    else
        load nichtlinear_X1_X2_X3_Y1_Y2_saett
    end
end
%% Datenvorbereitung
Eingangssignal=[y_vektor1(:,2),y_vektor2(:,2)];
Ausgangssignal=[x1,x2,x3];
Eingangssignal_cell = con2seq(Eingangssignal');
Ausgangssignal_cell = con2seq(Ausgangssignal');
figure(1)
subplot(2,1,1);
plot([1:length(Eingangssignal)],Eingangssignal);
legend('Eingangssignal Tank 1','Eingangssignal Tank 2');
subplot(2,1,2);
plot([1:length(Ausgangssignal)],Ausgangssignal);
legend('Füllhöhe 1','Füllhöhe 2','Füllhöhe 3');
title('Orginales Signal');
%% Narx- Network anwenden
zweierPotenz=[];
n_sch= 1;%Schrittweite für i*n
ste=1;
for i=1:ste
    time_data_1(i,1) = datetime;
    
    d1 = [1:2]; %inputDelays 1:8 | 1:2
    d2 = [1:2]; %feedbackDelays 1:8 | 1:2
    d3 =13; %hiddenSizes(i,1) 33 | 27
    
    zweierPotenz(i)=i;
    if(training_sim==0)
        narx_net = narxnet(d1,d2,d3); %narxnet(inputDelays,feedbackDelays,hiddenSizes,feedbackMode, standart openloop z.b trainFcn('closed'))
    end
    %%
    narx_net.performFcn = 'mse'; % SSE or MSE or (SAE,MAE,crossentropy und msesparse)
    
    %narx_net = fitnet;
    %%
    %narx_net.trainParam.showWindow(false);
    %narx_net.trainParam.showCommandLine(true);
    
    narx_net.trainFcn = 'trainbr';  %change the algorthm
    narx_net.layers{1}.transferFcn = 'tansig'; %change Activation Function
    narx_net.layers{2}.transferFcn = 'purelin'; %change Activation Function
    narx_net.trainParam.min_grad = 1e-10; % Minimaler Gradient
    %narx_net.performParam.regularization = 0.0001; %%Einstellung der
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
        rng('shuffle','combRecursive') %%%% Verwendet immer denn ersten Randn satz == ist immer gleich  957
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
    if(training_sim==0)
        [narx_net,tr] = train(narx_net,p,t,Pi,Ai);  % adapt->Inkrementelles Training mit Anpassung, train-> Batch-Modus Training
    end
    y = narx_net(p);
    [r,m,b] = regression(t,y);% Regressions Information
    %save Narx_net narx_net;
    yp = sim(narx_net,p,Pi); % simuliert das Narx system
    e = cell2mat(yp)-cell2mat(t);% Fehler zwischen NN-Ausgang und Targets
    
    clear var
    m_s_e_01 = mse(e);
    m_s_e_01_fuellhoehe_1 =mse(e(1,:));
    m_s_e_01_fuellhoehe_2 =mse(e(2,:));
    m_s_e_01_fuellhoehe_3 =mse(e(3,:));
    var = var(e(:,1));
    e_ari = mean(e(:,1));
    standardabweichung = std(e(:,1));
    %figure(3)
    %subplot(2,1,1)
    %h= plot([1:(length(yp))],cell2mat(yp),'red');
    %set(h,'LineWidth',2.8);
    %hold on
    %plot([1:(length(yp))],Ausgangssignal((25001-length(yp)):25000),'black' ,'LineWidth',0.8)
    %%plot([1:(length(yp))],cell2mat(yp),'red ',[1:(length(yp))],Ausgangssignal((25001-length(yp)):25000),'Black .');
    
    if(i==ste)
        
        figure(2)
        plot([1:(length(yp))],cell2mat(yp(1,:)));hold on; plot(Ausgangssignal([3:length(Ausgangssignal)],:),'g .')
        title('One Step Prediction NN Signal')
        legend('simulierte Füllhöhe 1','simulierte Füllhöhe 2','simulierte Füllhöhe 3', 'orginale Fühllhöhen')
        figure(3)
        %plot([1:(length(yp))],cell2mat(yp),[1:(length(yp))],Ausgangssignal((((length(Ausgangssignal)+1)-length(yp)):(length(Ausgangssignal)))),'g o');
        y_narx = cell2mat(yp)';
        subplot(3,1,1)
        plot([1:(length(yp))],y_narx(:,1));hold on; plot(Ausgangssignal([3:length(Ausgangssignal)],1),'g .')
        title('One Step Prediction NN Signal')
        legend('NN-Ausgangssignal','Ausgangssignal');
        subplot(3,1,2)
        plot([1:(length(yp))],y_narx(:,2));hold on; plot(Ausgangssignal([3:length(Ausgangssignal)],2),'g .')
        legend('NN-Ausgangssignal','Ausgangssignal');
        subplot(3,1,3)
        plot([1:(length(yp))],y_narx(:,3));hold on; plot(Ausgangssignal([3:length(Ausgangssignal)],3),'g .')
        legend('NN-Ausgangssignal','Ausgangssignal');
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
    
    if(training_sim==0)
        iter(i,1) = tr.best_epoch;
        varianz(i,1)= var;
        e_max(i,1) = max(e(:,1));
        e_min(i,1) = min(e(:,1));
        R_spann(i,1) = max(e(:,1))-min(e(:,1));
        Mittelwert(i,1) =  e_ari;
        Standardab(i,1) = standardabweichung;
        mean_squared_error_01(i,1) = m_s_e_01;
    end
end


if(training_sim==0)
    tre = [ tr.perf; tr.time; tr.gradient]; %%tr.mu;
    save alles_trainiert mean_squared_error_01 Mittelwert Standardab varianz R_spann e_max e_min iter time_data_1 time_data_2 time_data_3 narx_net tre;
elseif(training_sim==1)
    save alles_simuliert mean_squared_error_01 Mittelwert Standardab varianz R_spann e_max e_min iter time_data_1 time_data_2 time_data_3 narx_net;
end
%Narx_close

if(Narx_closed==1)
    if(training_sim==0)
        narx_net_closed = closeloop(narx_net); %% eine close loop erzeugen
    end
    %view(narx_net);
    
    
    %save Narx_net_1 narx_net;
    
    y1 = Eingangssignal_cell(1:(length(Eingangssignal)));
    u1 = Ausgangssignal_cell(1:(length(Ausgangssignal)));
    %%narx_net_closed = narxnet(d1,d2,d3); %narxnet(inputDelays,feedbackDelays,hiddenSizes,feedbackMode,trainFcn)
    %%narx_net_closed.divideFcn = ''; % propertys change
    %%narx_net_closed.trainParam.min_grad = 1e-5; % Minimaler Gradient
    [p1,Pi1,Ai1,t1] = preparets(narx_net_closed,Eingangssignal_cell,{},Ausgangssignal_cell);
    
    yp11 = narx_net_closed(p1,Pi1,Ai1);
    
    closedLoopPerformance = perform(narx_net_closed,t1,yp11);
    
    %[y,xf,af]=narx_net(p,pi,Ai);
    if(training_sim==0)
        [narx_net_closed,tr_closed] = train(narx_net_closed,p1,t1,Pi1,Ai1);
    end
    
    yp11 = sim(narx_net_closed,Eingangssignal_cell); % simuliert das Narx system

    figure(2)
    plot([1:(length(yp11))],cell2mat(yp11(1,:)));hold on; plot(Ausgangssignal([1:length(Ausgangssignal)],:),'g .')
    title('Multi Step Prediction NN Signal')
    legend('simulierte Füllhöhe 1','simulierte Füllhöhe 2','simulierte Füllhöhe 3', 'orginale Fühllhöhen')
    figure(5)
    aus = Ausgangssignal;
    y_narx_closed = cell2mat(yp11)';
    subplot(3,1,1)
    plot([1:(length(yp11))],y_narx_closed(:,1));hold on; plot(Ausgangssignal([1:length(Ausgangssignal)],1),'g .')
    title('Multi Step Prediction NN Signal')
    legend('NN-Ausgangssignal','Ausgangssignal');
    subplot(3,1,2)
    plot([1:(length(yp11))],y_narx_closed(:,2));hold on; plot(Ausgangssignal([1:length(Ausgangssignal)],2),'g .')
    legend('NN-Ausgangssignal','Ausgangssignal');
    subplot(3,1,3)
    plot([1:(length(yp11))],y_narx_closed(:,3));hold on; plot(Ausgangssignal([1:length(Ausgangssignal)],3),'g .')
    legend('NN-Ausgangssignal','Ausgangssignal');
    
    
    %plot([1:(length(yp11))],cell2mat(yp11),[1:(length(yp11))],aus(((length(Eingangssignal))-length(yp11)+1):(length(Eingangssignal))),'g o');
    legend('closed-loop NN','orginal Ausgangssignal')
    hold on
    
    e_close_loop = cell2mat(yp11)-cell2mat(Ausgangssignal_cell);
    clear var
    m_s_e_close_loop_01 = mse(e_close_loop);
    m_s_e_close_loop_fuellhoehe_01 = mse(e_close_loop(1,:));
    m_s_e_close_loop_fuellhoehe_02 = mse(e_close_loop(2,:));
    m_s_e_close_loop_fuellhoehe_03 = mse(e_close_loop(3,:));
    var_close_loop = var(e_close_loop(:,1));
    e_ari_close_loop = mean(e_close_loop(:,1));
    standardabweichung_close_loop = std(e_close_loop(:,1));
    if(training_sim==0)
    iter_close_loop(i,1) = tr_closed.best_epoch;
    end
    e_max_close_loop(i,1) = max(e_close_loop(:,1));
    e_min_close_loop(i,1) = min(e_close_loop(:,1));
    
    
    if(training_sim==0)
        tre_closed = [tr_closed.mu; tr_closed.perf; tr_closed.time; tr_closed.gradient];
        save alles_closed_training m_s_e_close_loop_01 e_ari_close_loop standardabweichung_close_loop var_close_loop e_max_close_loop e_min_close_loop iter_close_loop narx_net_closed tre_closed;
    elseif(training_sim==1)
        save alles_closed_simuliert m_s_e_close_loop_01 e_ari_close_loop standardabweichung_close_loop var_close_loop e_max_close_loop e_min_close_loop iter_close_loop narx_net_closed;
    end
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