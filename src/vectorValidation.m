function [allU, allV, dU_dx, dV_dy] = vectorValidation(U_filtered, V_filtered)
    % vectorValidation - Post-processes a PIV velocity field to remove spurious vectors.
    %
    % Syntax:
    %   [allU, allV, dU_dx, dV_dy] = vectorValidation(U_filtered, V_filtered)
    %
    % Inputs:
    %   U_filtered - 2D matrix of x-component velocity (pre-filtered)
    %   V_filtered - 2D matrix of y-component velocity (pre-filtered)
    %
    % Outputs:
    %   allU      - Cleaned x-component velocity field
    %   allV      - Cleaned y-component velocity field
    %   dU_dx     - Gradient of U in the x-direction
    %   dV_dy     - Gradient of V in the y-direction
    %
    % Description:
    %   This function performs post-processing validation of PIV results by:
    %   1. Removing vectors with high velocity gradients (possible spurious vectors).
    %   2. Eliminating vector outliers based on local displacement magnitude.
    %   3. Removing velocities above a defined physical threshold.

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