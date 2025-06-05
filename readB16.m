function image = readB16(filePath)
%% b16 Header byte Structure
% 
% Bytes    Type      Description
% 4        chars     "PCO-" 
% 4        int32     File size in byte       
% 4        int32     file size in byte 
% 4        int32     header size + comment filed in byte
% 4        int32     image width in pixel 
% 4        int32     image height in pixel 
% 4        int32     -1 (true), extended header follow
% 4        int32     0 = black/with camera, 1 = color camer
% 4        int32     black/white LUT-setting, minimum value 
% 4        int32     black/white LUT-setting, maximum value 
% 4        int32     black/white LUT-setting, 0 = linear, 1 = logarithmic 
% 4        int32     red LUT-setting, minimum value 
% 4        int32     red LUT-setting, maximum value 
% 4        int32     green LUT-setting, minimum value 
% 4        int32     green LUT-setting, maximum value 
% 4        int32     blue LUT-setting, minimum value 
% 4        int32     blue LUT-setting, maximum value 
% 4        int32     color LUT-setting, 0 = linear, 1 = logarithmic 
% ?        int32     internal use
% ?        chars     Comment file in ASCII characters with variable length of 0...XX. 
%                              The length of the comment filed must be documented in the �header length� field. 
%          uint16    16 bit pixel data, starting at offset given by the 'header size' int32
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
