function image = readB16(filePath)
    % readB16 - Reads 16-bit grayscale images in PCO proprietary B16 format.
    %
    % Syntax:
    %   image = readB16(filePath)
    %
    % Inputs:
    %   filePath - Full path to the .b16 image file
    %
    % Outputs:
    %   image    - 2D array (uint16) containing the grayscale image
    %
    % Description:
    %   This function reads a 16-bit grayscale image stored in the proprietary
    %   PCO camera format (.b16). It validates the file header, extracts the
    %   image dimensions, and loads the raw pixel data. The image is rotated
    %   and flipped to correct its orientation.
    %
    % Notes:
    %   - Only grayscale (monochrome) images are supported.
    %   - The function throws an error if the file is not a valid PCO file
    %     or if a color image is detected.
    
    % Open the file
    fd = fopen(filePath,'r');
    if(fd < 0)
      error('Could not open file: %s',filePath)
    end
    % Check that it is a PCO file
    filetype = fread(fd, 4, 'char');
    if(char(filetype') ~= 'PCO-')
      error('Wrong filetype: %s',char(filetype'))
    end
    % Get the image dimensions:
    fileSize   = fread(fd, 1, 'int32');  % not used
    headLength = fread(fd, 1, 'int32');  % offset for image data
    imgWidth   = fread(fd, 1, 'int32');  %
    imgHeight  = fread(fd, 1, 'int32');  %
    % look into the extended header, and thow error if color image
    extHeader  = fread(fd, 1, 'int32');
    if(extHeader == -1)
      colorMode  = fread(fd, 1, 'int32');
      if(colorMode ~= 0)
        error('Color image detected. Only b/w images have been tested with this function')
      end
    end
    % Get the image
    fseek(fd, headLength, 'bof');
    image = fread(fd, [imgWidth,imgHeight], 'uint16');
    % rotate and flip image to suit user
    image = flipud(image');  
end
