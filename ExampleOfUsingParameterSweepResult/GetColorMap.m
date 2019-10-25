function [colorMap] = GetColorMap( type, colors )
%
%
%This function convert the colors data (8-element vector) into a colormap
%
% INPUT
%	- Type: Type of display technique ('Anaglyph' or 'Polar') where the
%	picture will be tested.
%	- Colors: 8-element vector containing the integer digital video values.
%
% OUTPUT
%	- ColorMap: if the input parameter of Type is 'Anaglyph' it is a matrix
%	has 5 row. The first 4 contain the digital video value of anaglyph
%	logical colors in the next sort: Black, Red, Green Yellow. And the last
%	is a average. It is unused in this project.
%	- ColorMap: if the input parameter of Type is 'Polar' these are two matrixes. These has 5 row. The first 4 contain the digital video value of polar colors of the stimuli area and the last is a average. It is unused in this project.
            
    if strcmp( type, 'Anaglyph')
        colorMap = [
            [colors([5,6]), 0]; % Black 
            [colors([1,2]), 0]; % Red
            [colors([4,3]), 0]; % Green
            [colors([7,8]), 0]; % Yellow
            [fix(mean(colors([1 5 4 7]))), fix(mean(colors([2 3 6 8]))), 0] % Background
        ];
    else % polar
        % left colors
        colorMap.Left = [ 
            ones(1,3) * colors(5);
            ones(1,3) * colors(4);
            ones(1,3) * colors(1);
            ones(1,3) * colors(7);
            ones(1,3) * fix(mean(colors([5 4 1 7])))
        ];

        % right colors
        colorMap.Right = [
            ones(1,3) * colors(6);
            ones(1,3) * colors(2);
            ones(1,3) * colors(3);
            ones(1,3) * colors(8);
            ones(1,3) * fix(mean(colors([6 2 3 8])))
        ];
    end
end