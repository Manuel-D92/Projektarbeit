training_sim = 0; %%training =0; simulieren =1;
if(training_sim==0)
clc; clear all; close all;
end
training_sim = 0;
%% on/off switch (Auswahl zwischen 60 verschieden Signale)
training_mit_Uebertragungsfunktion =1; % 1= NN training ohne reellen Motordaten
Anfangswert=1;  zufall_gewichte=0;
% Anfangswert=1 -> Anfangswertinitalisierung werden auf rng(0) (immer der gleich Random satz) gesetzt; 
% Anfangswert=0 -> Anfangswertinitalisierung wird immer neu generiert


abtastzeit_0_001=0; %
abtastzeit_0_029=1; %Nur eins von dreien Auswählen
abtastzeit_0_0029=0;%

Begrenzung = 0; % Mit Sättigung (bis 9V) = 1; Begrenzung (max 5V) = 0;

Noise = 0; %(Rauschen =1 an, Rauschen =0 aus) nur 0.001!!!

Eingangssignal_Rauschen=0;         %
Ausgangssignal_Rauschen=1;         %Nur eins von dreien Auswählen
Ein_und_Ausgangssignal_Rauschen=0; %

N10_db=1; %
N20_db=0; %Nur eins von dreien Auswählen
N40_db=0; %

Vergleich_mit_Uebertragungsfunktion=0; % Vergelich mit einer bereits vorhandender Übertragungsfunktion = 1;

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
        H = tf(c2d(G, t_abt));
        Ausgangssignal = lsim(H, Eingangssignal_orginal, T);
        rauschen =0;
        if(N10_db==1) rauschen =10;elseif(N20_db==1) rauschen = 20;elseif(N40_db==1) rauschen = 40; end
        if(Eingangssignal_Rauschen==1) Ausgangssignal_orginal=Ausgangssignal; Eingangssignal =  addGaussianNoise([Eingangssignal_orginal],rauschen); elseif(Ausgangssignal_Rauschen==1) Ausgangssignal_orginal=Ausgangssignal; Ausgangssignal =  addGaussianNoise([Ausgangssignal],rauschen); elseif(Ein_und_Ausgangssignal_Rauschen==1) Ausgangssignal_orginal=Ausgangssignal; Eingangssignal =  addGaussianNoise([Eingangssignal_orginal],rauschen);Ausgangssignal =  addGaussianNoise([Ausgangssignal],rauschen) ;end
    end
end
figure(10)
plot([1:length(Eingangssignal)],Eingangssignal,[1:length(Ausgangssignal)],Ausgangssignal);

Eingangssignal_cell = con2seq(Eingangssignal');
Ausgangssignal_cell = con2seq(Ausgangssignal'); 
 
 
%% Prepare Predictors and Responses
XTrain = Eingangssignal';
YTrain = Ausgangssignal';

XValidationdata = Eingangssignal(ceil(length(Eingangssignal)*0.7):ceil((length(Eingangssignal)*0.85)))';
YValidationdata = Ausgangssignal(ceil(length(Ausgangssignal)*0.7):ceil((length(Ausgangssignal)*0.85)))';
%% Define LSTM Network Architecture 
%Layers
numFeatures = 2;
numResponses = 1;
numHiddenUnits = 50;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits,'StateActivationFunction','tanh','GateActivationFunction','sigmoid'); 
    dropoutLayer(0.2);
    %(StateActivationFunction) softsign = x/(1 + |x|) oder tanh
    %%(GateActivationFunction) sigmoid oder hard-sigmoid
   
    fullyConnectedLayer(1)
    regressionLayer];

%% Options
options = trainingOptions('adam', ...  %rmsprop sgdm adam
    'MaxEpochs',1000, ... %'ValidationData',{XValidationdata,YValidationdata}, ...
    'ValidationFrequency',50, ... %% wann immer eine Validation durchgeführt wird
    'ValidationPatience',Inf, ...  %% Validationanzahl /abruch ein/aus
    'GradientThreshold',1, ...
    'MiniBatchSize',1, ...
    'SequenceLength','longest', ...
    'InitialLearnRate',0.029, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

%% Train LSTM Network

[net,info] = trainNetwork([XTrain(1:length(XTrain)-1);YTrain(2:length(YTrain))],YTrain(1:length(YTrain)-1),layers,options);

%% simulieren

YPred = predict(net,[Eingangssignal(1:length(Eingangssignal)-1)';Ausgangssignal(2:length(Ausgangssignal))']);
figure(1)
plot([1:length(YPred)],YPred,[1:length(YPred)],Ausgangssignal(1:length(Ausgangssignal)-1)');
legend('NN','Orginal Ausgangssignal');

e_lstm = (YPred)-(Ausgangssignal(1:length(Ausgangssignal)-1)');% Fehler zwischen NN-Ausgang und Targets
figure(2)
plot(e_lstm);
clear var
m_s_e = mse(e_lstm);
var = var(e_lstm);
e_ari = mean(e_lstm);
standardabweichung = std(e_lstm);%rmse = sqrt(mean((e).^2))
info.TrainingLoss(length(info.TrainingLoss))
info.TrainingRMSE(length(info.TrainingRMSE))
minRMSE = min(info.TrainingRMSE)
minLoss = min(info.TrainingLoss)

save LSTM m_s_e minRMSE minLoss e_ari var standardabweichung e_lstm net info; 

% 
% %% Forecast Future Time Steps
% 
% % dataTestStandardized = (dataTest - mu) / sig;
% % XTest = dataTestStandardized(1:end-1);
% % 
% % net = predictAndUpdateState(net,XTrain);
% % [net,YPred] = predictAndUpdateState(net,YTrain(end));
% % 
% % 
% % net = predictAndUpdateState(net,XTrain);
% % [net,YPred] = predictAndUpdateState(net,YTrain(end));
% % 
% % numTimeStepsTest = numel(XTest);
% % for i = 2:numTimeStepsTest
% %     [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
% % end
% % 
% % 
% % YPred = sig*YPred + mu;
% % 
% % YTest = dataTest(2:end);
% % rmse = sqrt(mean((YPred-YTest).^2))
% % 
% % figure
% % plot(dataTrain(1:end-1))
% % hold on
% % idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
% % plot(idx,[data(numTimeStepsTrain) YPred],'.-')
% % hold off
% % xlabel("Month")
% % ylabel("Cases")
% % title("Forecast")
% % legend(["Observed" "Forecast"])
% % 
% % figure
% % subplot(2,1,1)
% % plot(YTest)
% % hold on
% % plot(YPred,'.-')
% % hold off
% % legend(["Observed" "Forecast"])
% % ylabel("Cases")
% % title("Forecast")
% % 
% % subplot(2,1,2)
% % stem(YPred - YTest)
% % xlabel("Month")
% % ylabel("Error")
% % title("RMSE = " + rmse)
