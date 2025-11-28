function [R G B] = colorme(Result,transitionpt)
if Result <= transitionpt
    R = Result/transitionpt;   % R value
    G = 1-Result;              % G value
    B = 0;                           % B value
elseif Result > transitionpt
    R = 1;               % R value
    G = 1-Result;  % G value
    B = 0;               % B value
end
end