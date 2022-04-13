clc
clear
close all

%% define dataset
f = @(x) x.*sin(x);

train_input_data = 3*pi*rand(100,1);
train_output_data = f(train_input_data);
train_Dataset = [train_input_data train_output_data];

test_input_data = (0:0.01:3*pi)';
test_output_data = f(test_input_data);
test_Dataset = [test_input_data test_output_data];

%% generate fis
genfis_option = genfisOptions('GridPartition');
genfis_option.NumMembershipFunctions = 5;
genfis_option.InputMembershipFunctionType = 'gaussmf';
fis = genfis(train_input_data, train_output_data, genfis_option);

%% train fis
anfis_option = anfisOptions('InitialFIS',fis);
anfis_option.DisplayANFISInformation = 1;
anfis_option.DisplayErrorValues = 0;
anfis_option.DisplayStepSize = 0;
anfis_option.DisplayFinalResults = 1;

fis = anfis(train_Dataset,anfis_option);

showrule(fis);

%% evalute fis
warning off;
anfis_output = evalfis(fis, test_input_data);
warning on;

figure(1);
subplot(2,1,1);
plotmf(fis,'input',1);

subplot(2,1,2);
hold on;
plot(train_input_data, train_output_data, '*b');
plot(test_input_data, anfis_output, 'r');
legend('Training Data','Evaluation of test dta');

