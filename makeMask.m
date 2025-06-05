function makeMask(name_save)
    
    % Import two sample images
    img1 = "12ms\Cam1\Cam1_0001A.b16";
    img2 = "12ms\Cam2\Cam2_0001A.b16";

    img1_filtered = filter_image(img1, [0.001 0.05]);
    img2_filtered = filter_image(img2, [0.01 0.45]);

    % Reconstruct the entire image
    img12 = [img2_filtered, img1_filtered];
    
    imshow(img12,[]);
    title('Create your mask');
    
    % Initialize empty mask
    combined_mask = false(size(img12, 1), size(img12, 2));
    
    % Loop for select multiple polygons
    while true
        
        % Create your polygon
        h = impoly; 
        position = wait(h); 
        
        % Create a mask for the selected polygon
        BW = createMask(h);
        
        combined_mask = combined_mask | BW;
        
        % When the user click ESC ask if to add another polygon
        answer = questdlg('Do you want to select another mask?', ...
            'Make Mask', 'Yes', 'No', 'Yes');
        
        if strcmp(answer, 'No')
            break
        end
    end
    
    % Visualize the mask on the image
    img_selected = img12;
    img_selected(combined_mask) = 0;
    figure;
    imshow(img_selected);
    title('Masked image');
    
    answer = questdlg('This is your mask: do you want to save it?', ...
            'Make Mask', 'Yes', 'No', 'Yes');
        
    if strcmp(answer, 'Yes')
        save(name_save,"combined_mask","-mat")
        disp("Mask saved!!")
    else
        disp("Mask NOT saved!!")
        return
    end
end

