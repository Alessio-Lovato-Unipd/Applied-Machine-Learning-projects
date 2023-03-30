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
   plot_reflectance = figure(Name="Reflectance");
   hold on;
   plot(scale,data);
   xlabel("Wavelenght [mm]");
   ylabel("Relative reflectance");
   legend('PETE', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'BACKGROUND');
   hold off;

 % Using PCA Analysis
   [coeff, score, latent, tsqared, exp] = pca(vectors, 'Centered', 'on', 'VariableWeights', 'variance');

 % Plot PCA Analysis
    figure(Name="PCA Components");
    hold on;
    color = ['b', 'r', 'g', 'c', 'm', 'y', 'k'];
        
    for i = 1 : NUM_CLASSES
       sub_matrix = score(labels == i, 1:3);
       plot3(sub_matrix(:, 1), sub_matrix(:, 2), sub_matrix(:, 3), 'o','MarkerEdgeColor',color(i),'MarkerFaceColor',color(i),'MarkerSize',4);
    end
    legend('PETE', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'BACKGROUND');
    hold off;
    clear sub_matrix;

    %Plot pca coefficients
    figure(1);
    hold on;
    plot(scale, coeff(1:4, :));
    legend('PETE', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'BACKGROUND', 'PCA COMPONENT 1', 'PCA COMPONENT 2', 'PCA COMPONENT 3', 'PCA COMPONENT 4');

  