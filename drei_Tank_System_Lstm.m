training_sim = 0; %%training =0; simulieren =1;
if(training_sim==0)
clc; clear all; close all;
end
training_sim = 0;
%% on/off switch (Auswahl zwischen 60 verschieden Signale)
training_mit_Uebertragungsfunktion =0; % 1= NN training ohne reellen Motordaten
Anfangswert=1;  zufall_gewichte=0;

%% Signal
Anfangswert=0;                      Auto_FD= 0;% Autocorellations berechnung für Feedback Delays
Noise =0;
Begrenzung=0;
Vergleich_mit_Uebertragungsfunktion=0;
Narx_closed=1;

abgegrenzte_Signale = 0;
saett = 0;

if(training_sim==2)
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

Shelf_Look_up_tables = readtable ('C:\Users\User\Desktop\Master Studium\Semester_3\Masterabeit\Simulationstool_Look_up_tables\holzRegal_119KHz.csv');


Eingangssignal=[table2array(Shelf_Look_up_tables(:,10:25))];
Ausgangssignal=[table2array(Shelf_Look_up_tables(:,[1:3]))]; %,7:9
Eingangssignal_cell = con2seq(Eingangssignal');
Ausgangssignal_cell = con2seq(Ausgangssignal');

%% Datenvorbereitung

%Eingangssignal=[y_vektor1(:,2),y_vektor2(:,2)];
%Ausgangssignal=[x1,x2,x3];
%Eingangssignal_cell = con2seq(Eingangssignal');
%Ausgangssignal_cell = con2seq(Ausgangssignal');  
figure(5)
plot(Eingangssignal);hold on; plot(Ausgangssignal);
%%
if(zufall_gewichte==1)
    test =  [Eingangssignal';Ausgangssignal'];
    [trainInd,valInd, testInd] = dividerand (test,0.75,0.15,0.15);
    %[trainInd, valInd, testInd] = divideint (Eingangssignal',0.7,0.15,0.15);
    
    %XTrain_ = mapminmax()
    
    XTrain =  trainInd(1,:);
    YTrain =  trainInd(2,:);

    XTest =  testInd(1,:);
    YTest =  testInd(2,:);

    XValidationdata = mapminmax(valInd(1,:),-1,1);
    YValidationdata = mapminmax(valInd(2,:),-1,1); 
    elseif(zufall_gewichte==0)
  
    XTrain =  Eingangssignal(1:ceil((length(Eingangssignal)*0.7)),:)';
    YTrain =  Ausgangssignal(1:ceil((length(Ausgangssignal)*0.7)),:)';

    XTest =  Eingangssignal(ceil(length(Eingangssignal)*0.7):ceil((length(Eingangssignal)*0.85)),:)';
    YTest =  Ausgangssignal(ceil(length(Ausgangssignal)*0.7):ceil((length(Ausgangssignal)*0.85)),:)';

    XValidationdata = Eingangssignal(ceil(length(Eingangssignal)*0.85):ceil((length(Eingangssignal)*1)),:)';
    YValidationdata = Ausgangssignal(ceil(length(Ausgangssignal)*0.85):ceil((length(Ausgangssignal)*1)),:)';   
    else
        
    XTrain =  Eingangssignal(1:ceil((length(Eingangssignal)*0.85)))';
    YTrain =  Ausgangssignal(1:ceil((length(Ausgangssignal)*0.85)))'; 
    
    XValidationdata = mapminmax(Eingangssignal(ceil(length(Eingangssignal)*0.85):ceil((length(Eingangssignal)*1)))',-1,1);
    YValidationdata = mapminmax(Ausgangssignal(ceil(length(Ausgangssignal)*0.85):ceil((length(Ausgangssignal)*1)))',-1,1); 
    
%     XTrain =  Eingangssignal';
%     YTrain =  Ausgangssignal';
%     
%     XValidationdata = Eingangssignal(ceil(length(Eingangssignal)*0.7):ceil((length(Eingangssignal)*0.85)))';
%     YValidationdata = Ausgangssignal(ceil(length(Ausgangssignal)*0.7):ceil((length(Ausgangssignal)*0.85)))';  
end

%% Define LSTM Network Architecture 
%Layers
numFeatures = 16;
numResponses = 3;
numHiddenUnits =120;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    dropoutLayer(0.3)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    dropoutLayer(0.3)
    fullyConnectedLayer(numResponses)
    regressionLayer()];

pr_XTrain = XTrain;
pr_YTrain = YTrain;

if(training_sim==0)
    [XTrain,ps] = mapminmax(XTrain,-1,1);
    [YTrain,ts] = mapminmax(YTrain,-1,1);
elseif(training_sim==1)
    XTrain = mapminmax('apply',XTrain,ps);
    YTrain = mapminmax('apply',YTrain,ts);
end

pr_XTest = XTest;
pr_YTest = YTest;

XValidationdata = mapminmax('apply',XValidationdata,ps);
YValidationdata = mapminmax('apply',YValidationdata,ts);

options = trainingOptions('adam', ...  %rmsprop sgdm adam
    'MaxEpochs',1000, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.03448, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',128, ...
    'ValidationData',{XValidationdata,YValidationdata}, ...
    'ValidationFrequency',25, ... %% wann immer eine Validation durchgeführt wird
    'ValidationPatience',6, ...  %% Validationanzahl /abruch ein/aus 
    'MiniBatchSize',32, ...
    'Verbose',0, ...
    'Plots','training-progress');

if(training_sim==0)
time_data_1 = datetime;

[net,info] = trainNetwork(XTrain,YTrain,layers,options);
time_data_2 = datetime;
time_data_3 = between(time_data_1,time_data_2);
end
%% simulieren
XTest = mapminmax('apply',XTest,ps);
YTest = mapminmax('apply',YTest,ts);
YPred_Train = predict(net,XTrain);
%YPred_Train = sig_y*YPred_Train +mu_y;
%m_s_e_train = mse(YTrain*sig_y+ mu_y-YPred_Train);
YPred_Train = mapminmax('reverse',YPred_Train,ts);
m_s_e_train = mse(pr_YTrain(5:length(pr_YTrain))-YPred_Train(5:length(YPred_Train)));

Eingangssignal_ap = mapminmax('apply',Eingangssignal',ps);

YPred = predict(net,Eingangssignal_ap);

%YPred = sig_y*YPred +mu_y;
YPred = mapminmax('reverse',YPred,ts);
YPred = YPred';
%YPred = [predict(net,XTrain) predict(net,XTest)];
YPred_Test = predict(net,XTest);
YPred_Test = mapminmax('reverse',YPred_Test,ts);
plot([1:length(YPred_Test)],YPred_Test,[1:length(pr_YTest)],pr_YTest);
m_s_e_test = mse((pr_YTest(1:length(YTest)))-YPred_Test(1:length(YTest)));
%YPred_Test = sig_y*YPred_Test +mu_y;
%m_s_e_test = mse((YTest(8:length(YTest)))-YPred_Test(8:length(YTest)));

figure(1)
title('LSTM NN Signal')
subplot(3,1,1)
    plot([1:(length(YPred))],YPred(:,1));hold on; plot(Ausgangssignal([1:length(Ausgangssignal)],1),'g .')
    legend('LSTM-Ausgangssignal','Ausgangssignal');
    subplot(3,1,2)
    plot([1:(length(YPred))],YPred(:,2));hold on; plot(Ausgangssignal([1:length(Ausgangssignal)],2),'g .')
    legend('LSTM-Ausgangssignal','Ausgangssignal');
    subplot(3,1,3)
    plot([1:(length(YPred))],YPred(:,3));hold on; plot(Ausgangssignal([1:length(Ausgangssignal)],3),'g .')
    legend('LSTM-Ausgangssignal','Ausgangssignal');
%plot([1:length(YPred)],YPred,[1:length(YPred)],Ausgangssignal(1:length(YPred),:)','o g');
%legend('LSTM','Orginal Ausgangssignal');

e_lstm = (YPred')-(Ausgangssignal');% Fehler zwischen NN-Ausgang und Targets
figure(2)
plot(e_lstm');
clear var
m_s_e_01 = mse(e_lstm(1:length(e_lstm')));
var = var(e_lstm);
e_ari = mean(e_lstm);
standardabweichung = std(e_lstm);%rmse = sqrt(mean((e).^2))
info.TrainingLoss(length(info.TrainingLoss))
info.TrainingRMSE(length(info.TrainingRMSE))
minRMSE = min(info.TrainingRMSE)
minLoss = min(info.TrainingLoss)

if(training_sim==0)
    save LSTM_drei_Tank_training m_s_e_01 minRMSE minLoss ts ps e_ari var standardabweichung e_lstm net info time_data_3; 
else
    save LSTM_drei_Tank_simuliert m_s_e_01 minRMSE minLoss ts ps e_ari var standardabweichung e_lstm net info time_data_3; 
end