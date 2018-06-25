%% -------------------------------------------------------------------
% Norwegian University of Science and Technology
% Evelyn Paiz
% Specialisation in Colour Imaging
% Project:  Translucency Modeling and Analysis
% Instructors: Jon Y. Hardeberg
% Supervisors: Jean-Baptiste Thomas & Ivar Farup
% Description: the internal Fresnel reflectivity approximated with a simple
%              polynomial expansion.
% Inputs: refraction index.
%   - eta: the input path for the data to be loaded.
% Outputs: 
%   - fdr: Fresnel reflectivity approximation.
%% -------------------------------------------------------------------
 
function result = Fdr(eta)
    if (eta < 1.0)
        result = ((-0.4399+0.7099)/eta) - (0.3319/(eta * eta)) + (0.0636/(eta*eta*eta))
    else
        result = (-1.4399/(eta*eta)) + (0.7099/eta) + 0.6681 + (0.0636*eta);
    end
end