%% -------------------------------------------------------------------
% Norwegian University of Science and Technology
% Evelyn Paiz
% Specialisation in Colour Imaging
% Project:  Translucency Modeling and Analysis
% Instructors: Jon Y. Hardeberg
% Supervisors: Jean-Baptiste Thomas & Ivar Farup
% Description: the bssrdf model.
%% -------------------------------------------------------------------

function Rd = bssrdf(r, sigmaA, sigmaSPrime)

    sigmaTPrime = sigmaA + sigmaSPrime;
    sigmaTr= sqrt(3*sigmaA*sigmaTPrime);

    eta = 1.3;
    fdr = Fdr(eta);
    A = (1.0 + fdr)/(1.0 - fdr);
    zr = 1./sigmaTPrime; dr = sqrt(zr.^2 + r.^2);
    zv = zr*(1+((4*A)/3)); dv = sqrt(zv.^2 + r.^2);

    alphaPrime = sigmaSPrime/sigmaTPrime;
    sTrDr = sigmaTr * dr;
    sTrDv = sigmaTr * dv;

    Rd = (0.25.*inv(pi)*alphaPrime)*( ...
            ((zr.*(1+sTrDr).*exp(-sTrDr))./(dr.^3)) + ...
            ((zv.*(1+sTrDv).*exp(-sTrDv))./(dv.^3)));
end