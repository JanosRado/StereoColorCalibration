function [DataMX] = MakeDataMatrix( Type, ImageSize, PatternSize, Colors)
% 
%
% This function calculates the data of the test bitmap.
%
%
% INPUT
%	- Type: Type of display technique ('Anaglyph' or 'Polar') where the
%	picture will be tested.
%	- ImageSize: The image size [x,y] (in pixels)
%	- PatternSize: width or height of the stripe (in pixels)
%	- Colors: 8-element vector containing the integer digital video values
%
% OUTPUT
%	-DataMX: A 3D matrix with the RGB values of the picture.


% Initialize color map
colorMap = GetColorMap( Type, Colors);

% calculated square numbers
sizeOfTable = [ ImageSize(1), ImageSize(2)] ./ [PatternSize PatternSize];

% rounde up square numbers
FixSizeOfTable(1) = round((sizeOfTable(2)+1)/2)*2;
FixSizeOfTable(2) = round((sizeOfTable(1)+1)/2)*2;

% Calculated image size
iHeight = FixSizeOfTable(1)*PatternSize;
iWidth = FixSizeOfTable(2)*PatternSize;

if strcmp( Type, 'Anaglyph')
    % Create base data image
    imgData =[1,2;3,4];
    imgData = repmat(imgData,FixSizeOfTable/2);
    imgData = imresize(imgData, [iHeight,  iWidth], 'nearest');
    
    % Create DataMX, coloring the base data image
    DataMX(:, : ,:) =  ind2rgb(imgData, colorMap );
end
if strcmp( Type, 'Polar')
    
    % Create left data image
    imgLeft =[1;0];
    imgLeft = repmat(imgLeft,[FixSizeOfTable(1)/2 1]);
    imgLeft = imresize(imgLeft, [iHeight/2,  iWidth], 'nearest');
    
    % Create right data image
    imgRight =[1,0];
    imgRight = repmat(imgRight,[1 FixSizeOfTable(2)/2]);
    imgRight = imresize(imgRight, [iHeight/2,  iWidth], 'nearest');
    
    %  Calculate frame indexer
    frameIndexer = 2*imgRight(:,:) + imgLeft(:,:) + 1; % pixel values 1..4
    
    % Create DataMX, coloring the base data image
    DataMX = NaN([2*size(imgLeft,1) size(imgLeft,2) 3]);  % allocating
    Left = ind2rgb(frameIndexer, colorMap.Left ); % left data
    Right = ind2rgb(frameIndexer, colorMap.Right ); % right data
    SizeY = size(Left,1);
    for ix = 1:SizeY
        DataMX(ix*2-1,:, :) = Left(ix,:,:);
        DataMX(ix*2,:, :) = Right(ix,:,:);
    end
end
VerticalFrom = (size(DataMX,1)-ImageSize(2))/2+1;
VerticalTo = (size(DataMX,1)-VerticalFrom)+1;
HorizontalFrom = (size(DataMX,2)-ImageSize(1))/2+1;
HorizontalTo = (size(DataMX,2)-HorizontalFrom)+1;
DataMX =  DataMX( VerticalFrom:VerticalTo , HorizontalFrom:HorizontalTo,:,:)/255;
end

