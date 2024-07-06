function optimal_classification()
    % Get user inputs
    rows = input('Enter the number of rows: ');
    cols = input('Enter the number of columns: ');
    num_matrices = input('Enter the number of matrices: ');
    initial_D = input('Enter the initial difference parameter D: ');
    
    % Initialize matrices
    matrices = cell(1, num_matrices);
    for i = 1:num_matrices
        fprintf('Enter elements for matrix %d:\n', i);
        matrices{i} = zeros(rows, cols);
        for r = 1:rows
            for c = 1:cols
                matrices{i}(r,c) = input(sprintf('Element (%d,%d): ', r, c));
            end
        end
    end
    
    % Optimization algorithm to find the best D and number of matrices
    optimal_D = initial_D;
    optimal_num_matrices = num_matrices;
    min_variation = inf;
    
    for D = initial_D - 10:0.5:initial_D + 10
        for n = 1:num_matrices
            classes = classify_elements(matrices(1:n), D);
            variation = calculate_class_variation(classes);
            if variation < min_variation
                min_variation = variation;
                optimal_D = D;
                optimal_num_matrices = n;
            end
        end
    end
    
    fprintf('Optimal D: %.2f\n', optimal_D);
    fprintf('Optimal number of matrices: %d\n', optimal_num_matrices);
    
    % Final classification with optimal values
    final_classes = classify_elements(matrices(1:optimal_num_matrices), optimal_D);
    disp('Final Classes:');
    disp(final_classes);
end

function classes = classify_elements(matrices, D)
    elements = [];
    for i = 1:length(matrices)
        elements = [elements; matrices{i}(:)];
    end
    
    num_elements = length(elements);
    classes = zeros(num_elements, 1);
    class_id = 1;
    
    for i = 1:num_elements
        if classes(i) == 0
            classes(i) = class_id;
            for j = i+1:num_elements
                if classes(j) == 0 && abs(elements(i) - elements(j)) < D
                    classes(j) = class_id;
                end
            end
            class_id = class_id + 1;
        end
    end
end

function variation = calculate_class_variation(classes)
    unique_classes = unique(classes);
    class_counts = histc(classes, unique_classes);
    variation = std(class_counts);
end
