function [img_filtered] = filter_image(file, values)
    % filter_image - Reads and filters a raw 16-bit PCO image.
    %
    % Syntax:
    %   img_filtered = filter_image(file, values)
    %
    % Inputs:
    %   file   - Path to the .b16 image file (string or char)
    %   values - Two-element vector [low high] specifying intensity range for contrast adjustment
    %
    % Outputs:
    %   img_filtered - Filtered grayscale image (normalized double precision)
    %
    % Description:
    %   This function performs a sequence of pre-processing steps on a raw 16-bit image:
    %   1. Reads the image using readB16()
    %   2. Normalizes intensity to [0,1]
    %   3. Adjusts contrast based on user-defined thresholds
    %   4. Applies Gaussian blur to reduce noise
    %   5. Applies a 2D average filter for further smoothing

    imag = readB16(file);

    % Convert in gray scale for later
    imag_normalized = mat2gray(imag); 
    
    imag_cont = imadjust(imag_normalized,values,[0 1]);
    
    % Gaussian filter
    imag_filtered_gauss = imgaussfilt(imag_cont); 
    % Create 2D filter
    h = fspecial('average', [3 3]); 
    img_filtered = imfilter(imag_filtered_gauss, h);

end