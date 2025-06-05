function [allU, allV, dU_dx, dV_dy] = vectorValidation(U_filtered, V_filtered)

    % Delate high velocity gradients (spurios)
    distances = sqrt(diff(U_filtered,1,2).^2 + diff(V_filtered,1,2).^2);
    [dU_dx, dU_dy] = gradient(U_filtered);
    [dV_dx, dV_dy] = gradient(V_filtered);
    velocity_gradient = sqrt(dU_dx.^2 + dU_dy.^2 + dV_dx.^2 + dV_dy.^2);
    threshold =  mean(velocity_gradient(:))+ 3 * std(velocity_gradient(:));
    anomalous = velocity_gradient > threshold;
    U_filtered(anomalous) = NaN;
    V_filtered(anomalous) = NaN;
    
    % Remove outlayers
    threshold = mean(distances(:)) +3 * std(distances(:));
    U_filtered(distances > threshold) = NaN;
    V_filtered(distances > threshold) = NaN;

    % Remove too high velocities
    max_velocity = 20; % m/s (in this case)
    speed = sqrt(U_filtered.^2 + V_filtered.^2);
    anomalous = speed > max_velocity;
    U_filtered(anomalous) = NaN;
    V_filtered(anomalous) = NaN;
    
    allU = U_filtered;
    allV = V_filtered;
end