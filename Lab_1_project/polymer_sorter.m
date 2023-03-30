 % Polymer sorter algorithm

 % clear workspace 
   clear;

 % Import data from data workspace
   load('dataVectors.mat');
   NUM_CLASSES = max(labels);

 % Find mean reflectance curve of each polymer
    data = zeros(NUM_CLASSES, size(vectors,2));
    %cycle each polymer
    for i = 1 : NUM_CLASSES
        sub_matrix = vectors(labels == i, :);
        array_means = mean(sub_matrix);
        data(i, :) = array_means;
    end

    clear sub_matrix array_means;

 % Plot curves
   graphic = plot(scale,data);
   xlabel("Wavelenght [mm]");
   ylabel("Relative reflectance");
   legend('PETE', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'BACKGROUND');