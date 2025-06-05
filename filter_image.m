function [img_filtered] = filter_image(file, values)

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