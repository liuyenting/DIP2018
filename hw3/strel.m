function se = strel(varargin)
%STREL Create morphoglogical structuring element.
%   Detailed explanation goes here

type = varargin{1};
params = varargin(2:end);
n_params = numel(params);

switch type
    case 'square'
       if (n_params < 1)
           error(generatemsgid('TooFewInputs'));
       elseif (n_params > 1)
           error(generatemsgid('TooManyInputs'));
       end
       
       M = params{1};
       se = strelsquare(M);
       
    case 'disk'
        if (n_params < 1)
            error(generatemsgid('TooFewInputs'));
        elseif (n_params > 1)
            error(generatemsgid('TooManyInputs'));
        end
        
        r = params{1};
        se = streldisk(r);
        
    otherwise
        error(generatemsgid('UnrecognizedStrelType'), ...
              'Unknown type of structuring elemennt');
end

end

function se = strelsquare(m)

se = true(m, m);

end

function se = streldisk(r)

[xx, yy] = meshgrid(-r:r);
se = xx.^2 + yy.^2 <= r^2;

end
