classdef decToPixelChange < handle
        properties (SetAccess = public)
        end
        methods
            function this = decToPixelChange()
                
                inputVector = [.72 .21 .27 .67]

                pixelVector = [];

                pixelVector(1) = inputVector(1) * 960;
                pixelVector(2) = inputVector(2) * 540;
                pixelVector(3) = inputVector(3) * 960;
                pixelVector(4) = inputVector(4) * 540;
                
                pixelVector(1) = round(pixelVector(1));
                pixelVector(2) = round(pixelVector(2));
                pixelVector(3) = round(pixelVector(3));
                pixelVector(4) = round(pixelVector(4));

                pixelVectorString = strcat('[', num2str(pixelVector(1)), ...
                                           {' '}, num2str(pixelVector(2)), ...
                                           {' '}, num2str(pixelVector(3)), ...
                                           {' '}, num2str(pixelVector(4)), ']') 
            end
        end
end