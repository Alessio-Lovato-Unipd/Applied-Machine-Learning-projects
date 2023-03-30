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
   plot_reflectance = plot(scale,data);
   xlabel("Wavelenght [mm]");
   ylabel("Relative reflectance");
   legend('PETE', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'BACKGROUND');

 % Using PCA Analysis
   [coeff, score, latent, tsqared, exp] = pca(vectors, 'Centered', 'on', 'VariableWeights', 'variance');

 % Plot PCA Analysis
    plot_PCA = figure(Name="PCA Components");
    plot_PCA = plot3(score(:, 1), score(:, 2), score(:, 3), 'o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',4);
    figure(1);
    hold;
    plot(scale, coeff(1:4, :));
    legend('PETE', 'HDPE', 'PVC', 'LDPE', 'PP', 'PS', 'BACKGROUND', 'PCA COMPONENT 1', 'PCA COMPONENT 2', 'PCA COMPONENT 3', 'PCA COMPONENT 4');

  