% Classification using Support Vector Machine for polymer sorter

    % Clear workspace
    clear;

    % Read and shuffle data
    load dataVectors.mat;

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

    % Validation
    for i = 1 : 7
     ind = find(testLabels == i);
     eval(['[result' num2str(i) ',EDGES] = histcounts(cl(ind), [1 2 3 4 5 6 7 8] );']);
    end
