function [Human_model]=XSens_ForwardKinematicsAnimation8(...
    Human_model,q,j,...
    seg_anim)
% Computation of a forward kinematics step for the animation8
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Markers_set: set of markers (see the Documentation for the structure)
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - q: vector of joint coordinates
%   - j: current solid
%   - muscles_anim: representation of the muscles (0 or 1)
%   - mod_marker_anim: representation of the model markers (0 or 1)
%   - solid_inertia_anim: representation of the stadium solids (0 or 1)
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - Markers_set: set of markers (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if j == 0 
    return;
end

i=Human_model(j).mother; % number (ident) of mother
if i == 0
    Human_model(j).pos_pts_anim=[]; % initialization of a new domain
else
    if Human_model(j).joint == 1     % hinge          
        Human_model(j).p = Human_model(i).R * Human_model(j).b + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).a,q(j)) * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
    if Human_model(j).joint == 2    % slider
        Human_model(j).p = Human_model(i).R * (Human_model(j).b + q(j)*Human_model(j).a) + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
end
Human_model(j).pc = Human_model(j).p + Human_model(j).R*Human_model(j).c;
Human_model(j).Tc_R0_Ri=[Human_model(j).R, Human_model(j).pc ; [0 0 0 1]];

% Computation of the location for each point
if seg_anim
    if Human_model(j).Visual == 1
        for m = 1:size(Human_model(j).anat_position,1)
            Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim ... 
                (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{m,2}) + Human_model(j).p)]; % calcul de la position de chaque point
        end
    end
end

[Human_model]=ForwardKinematicsAnimation8(Human_model,q,Human_model(j).sister,seg_anim);
[Human_model]=ForwardKinematicsAnimation8(Human_model,q,Human_model(j).child,seg_anim);

end
