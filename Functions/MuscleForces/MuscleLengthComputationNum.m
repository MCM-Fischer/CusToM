function [L] = MuscleLengthComputationNum(BiomechanicalModel,q)
% Computation of the moment arms matrix (numerical version)
%
%   INPUT
%   - Biomechanical model: osteo-articular model (see the Documentation for the structure)
%   - q : current coordinates of the model
%   OUTPUT
%   - L: muscle lengths vector at the current frame
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
Human_model=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;
idxm=find([Muscles.exist]);
nmr=numel(idxm);
%% Compute muscle lengths at current frame
% The current muscle lengths are important for the muscle force computation
L = zeros(nmr,1);
for j=1:nmr % for each muscle
    % compute the length of the muscle
    L(j) = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q);
end
end