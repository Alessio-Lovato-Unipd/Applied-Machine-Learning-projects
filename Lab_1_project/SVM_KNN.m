% Classification using Support Vector Machine for polymer sorter

    % Clear workspace
        clear;
    
    
    % SELECT IF DATASET HAS TO BE SHRUNK
      shrink = true;
    
      
    % Read and shuffle data
    load dataVectors.mat;
    
    if shrink
        % Selection of specified wavelenghts (1090 - 1350 -1550 mm)
        scale(:, 161 : 199) = [];
        scale(:, 103 : 156) = [];
        scale(:, 29 : 98) = [];
        scale(:, 1 : 24) = [];
        
        vectors(:, 161 : 199) = [];
        vectors(:, 103 : 156) = [];
        vectors(:, 29 : 98) = [];
        vectors(:, 1 : 24) = [];
    end
    
    % Insert primary key of the set in the first column
    data_to_shuffle = cat(2, labels, vectors);


    % shuffling
    shuffled = data_to_shuffle(randperm(size(data_to_shuffle, 1)), :);

    % splitting
    trainSet = shuffled(1 : 0.8*size(shuffled,1),:);
    testSet = shuffled((0.8*size(shuffled,1)) + 1 : size (shuffled, 1),:);

    % Remove primary key from dataset
    testLabels = testSet(:, 1);
    testSet(:, 1) = [];
    trainLabels = trainSet(:, 1);
    trainSet(:, 1) = [];
    
    % SVM
     SVMACHINE = templateSVM('Standardize',1,'KernelFunction','rbf');
     Mdl = fitcecoc(trainSet,trainLabels,'Learners',SVMACHINE,'Verbose',2);
     cl = Mdl.predict(testSet);

    % K-Nearest Neighbors
     Mdl_K = fitcknn(trainSet,trainLabels,'NumNeighbors',3,'Standardize',1);
     cl_K = Mdl_K.predict(testSet);

    % Validation
    for i = 1 : 7
     ind = find(testLabels == i);
     eval(['[result' num2str(i) ',EDGES] = histcounts(cl(ind), [1 2 3 4 5 6 7 8] );']);
    end
    svm_chart = figure(Name="SVM Confusion Chart");
    svm_chart = confusionchart(testLabels,cl);

    % Validation K-Nearest Neighbors
    for i = 1 : 7
     ind = find(testLabels == i);
     eval(['[result_K' num2str(i) ',EDGES] = histcounts(cl_K(ind), [1 2 3 4 5 6 7 8] );']);
    end
    k_chart = figure(Name="K-Neighbors Confusion Chart");
    k_chart = confusionchart(testLabels,cl_K);