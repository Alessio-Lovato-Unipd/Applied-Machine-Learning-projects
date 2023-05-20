clear all
close all
clc

%% Prepare data

load 'dataset'

cut_date_month=DateMeasure2(:).Month;
deliver_date_month=DateMeasure1(:).Month;

cut_date_day=DateMeasure2(:).Day;
deliver_date_day=DateMeasure1(:).Day;
store_days=deliver_date_day-cut_date_day;

for i=1:size(store_days)
if (store_days(i)<0)
    store_days(i)=store_days(i)+30;
end
end

logs=Numlogs;
[GN, ~, Assortment_n] = unique(Assortment);
a=Weigth./Diameter;

% Example of input parameters
% ##########################################################################
 input=[cut_date_month store_days Assortment_n  Weigth];
% ##########################################################################
% Possible finished input parameters:
% cut_date_month           The month that the tree logs were harvested
% cut_date_day             The day that the tree logs were harvested
% deliver_date_month       The month that the tree logs were delivered
% deliver_date_day         The day that the tree logs were delivered
% store_days               The number of days between harvest and delivery
% logs                     The number of logs in one pile
% Assortment_n             The type of trees (species) in one pile
% Diameter                 The mean diameter in one pile (from harvester)
% Weigth                   The weight of one pile


reference=Grossvolmeasure2;
reference_SDC=Grossvolmeasure1;
 
er=mean(100*abs((reference_SDC-reference)./reference));

sumreference = 0;
for i=1:numel(reference)
    sumreference=sumreference+reference(i);
end

sumreference_SDC = 0;
for i=1:numel(reference_SDC)
    sumreference_SDC=sumreference_SDC+reference_SDC(i);
end

k= sumreference_SDC/sumreference;

temp=((reference_SDC-k*reference).*(reference_SDC-k*reference));

sumtemp = 0;
for i=1:numel(temp)
    sumtemp=sumtemp+temp(i);
end

esdc_p=sumtemp/(numel(reference)-1);
esdc=100*(sqrt(esdc_p))/mean(reference)

%% Statistics

    cut_date_month_m=mean(cut_date_month); 
    store_days_m=mean(store_days); 
    logs_m=mean(logs);
    Weigth_m=mean(Weigth); 
    Assortment_n_m=mean(Assortment_n); 
    Weigth_m=mean(Weigth); 
    Diameter_m=mean(Diameter); 
    Length_m=mean(Length);
    
    cut_date_month_std=std(cut_date_month); 
    store_days_std=std(store_days); 
    logs_std=std(logs);
    Weigth_std=std(Weigth); 
    Assortment_n_std=std(Assortment_n); 
    Weigth_std=std(Weigth); 
    Diameter_std=std(Diameter); 
    Length_std=std(Length);
    

%% Neural network

x = input';
t = reference';

trainFcn = 'trainbr';  
hiddenLayerSize = 30;
net = fitnet(hiddenLayerSize,trainFcn);

net.input.processFcns = {'mapstd'};
net.output.processFcns = {'mapstd'};

net.divideFcn = 'dividerand';  
net.divideMode = 'sample';  
net.divideParam.trainRatio =50/100;
net.divideParam.valRatio = 25/100;
net.divideParam.testRatio = 25/100;

net.performFcn = 'mse';  
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

[net,tr] = train(net,x,t);

%% Test 

output1 = net(x)';
 
sumreference = 0;
for i=1:numel(reference)
    sumreference=sumreference+reference(i);
end

sumreference_output1 = 0;
for i=1:numel(output1)
    sumreference_output1=sumreference_output1+output1(i);
end


k1= sumreference_output1/sumreference;

temp=((output1-k1*reference).*(output1-k1*reference));
temp1=temp;

sumtemp = 0;
for i=1:numel(temp)
    sumtemp=sumtemp+temp(i);
end

ep=sumtemp/(numel(reference)-1);
epf=100*(sqrt(ep))/mean(reference)

