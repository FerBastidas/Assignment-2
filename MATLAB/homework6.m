% Puntos de la triangulación (P)
P = [0, 0; 1, 0; 0.5, 0.866; 1.5, 0.866; 0.5, -0.5; 2, 0.5]; % 6 puntos en 2D

% Triángulos de la triangulación 
T = [1, 2, 3; 2, 4, 3; 1, 2, 5; 2, 4, 6]; % 4 triángulos, índices de puntos

% Llamar a las funciones de graficado
graph_triangulation(T, P);  % Graficar toda la triangulación
graph_neighbors(T, P, 1);   % Graficar los vecinos del triángulo 1
graph_adjacent_triangles(T, P, 2); % Graficar los triángulos adyacentes al punto 2

% Función para graficar la triangulación
function graph_triangulation(T, P)
    figure; hold on;
    for i = 1:size(T, 1)
        % Extraer puntos de cada triángulo
        tri_points = P(T(i, :), :);
        tri_points = [tri_points; tri_points(1, :)];  % Cerrar el triángulo
        plot(tri_points(:, 1), tri_points(:, 2), 'b-', 'LineWidth', 1.5);
        centroid = mean(tri_points(1:end-1, :), 1);  % Calcular el centroide
        text(centroid(1), centroid(2), sprintf('T%d', i), 'Color', 'blue');
    end
    for i = 1:size(P, 1)
        text(P(i, 1), P(i, 2), sprintf('P%d', i), 'Color', 'red');
    end
    title('Triangulation');
    axis equal;
    hold off;
end

% Función para encontrar los vecinos de un triángulo
function neighbors = find_neighbors(T, tri_index)
    neighbors = [];
    target_edges = sort([T(tri_index, [1, 2]); T(tri_index, [2, 3]); T(tri_index, [3, 1])], 2);
    for i = 1:size(T, 1)
        if i == tri_index, continue; end
        edges = sort([T(i, [1, 2]); T(i, [2, 3]); T(i, [3, 1])], 2);
        if ~isempty(intersect(target_edges, edges, 'rows'))
            neighbors = [neighbors; i];
        end
    end
end

% Función para graficar los vecinos de un triángulo
function graph_neighbors(T, P, tri_index)
    neighbors = find_neighbors(T, tri_index);
    figure; hold on;
    for i = 1:size(T, 1)
        tri_points = P(T(i, :), :);
        tri_points = [tri_points; tri_points(1, :)];
        if ismember(i, neighbors)
            plot(tri_points(:, 1), tri_points(:, 2), 'g-', 'LineWidth', 1.5);
        else
            plot(tri_points(:, 1), tri_points(:, 2), 'b-', 'LineWidth', 1.5);
        end
        centroid = mean(tri_points(1:end-1, :), 1);
        text(centroid(1), centroid(2), sprintf('T%d', i), 'Color', 'blue');
    end
    for i = 1:size(P, 1)
        text(P(i, 1), P(i, 2), sprintf('P%d', i), 'Color', 'red');
    end
    title(sprintf('Neighbors of Triangle T%d', tri_index));
    axis equal;
    hold off;
end

% Función para encontrar los triángulos adyacentes a un punto
function adjacent = find_adjacent_triangles(T, point_index)
    adjacent = find(any(T == point_index, 2));
end

% Función para graficar los triángulos adyacentes a un punto
function graph_adjacent_triangles(T, P, point_index)
    adjacent = find_adjacent_triangles(T, point_index);
    figure; hold on;
    for i = 1:size(T, 1)
        tri_points = P(T(i, :), :);
        tri_points = [tri_points; tri_points(1, :)];
        if ismember(i, adjacent)
            plot(tri_points(:, 1), tri_points(:, 2), 'g-', 'LineWidth', 1.5);
        else
            plot(tri_points(:, 1), tri_points(:, 2), 'b-', 'LineWidth', 1.5);
        end
        centroid = mean(tri_points(1:end-1, :), 1);
        text(centroid(1), centroid(2), sprintf('T%d', i), 'Color', 'blue');
    end
    for i = 1:size(P, 1)
        text(P(i, 1), P(i, 2), sprintf('P%d', i), 'Color', 'red');
    end
    title(sprintf('Triangles Adjacent to Point P%d', point_index));
    axis equal;
    hold off;
end
