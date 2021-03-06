function [] = BaseOfSupport(AnalysisParameters)
% Computation of the base of support
%
%   INPUT
%   - AnalysisParameters: parameters of the musculoskeletal analysis,
%   automatically generated by the graphic interface 'Analysis'.
%   OUTPUT
%   The data related to the base of support are automatically saved on the
%   folder associated to each motion capture in variables
%   'InverseKinematicsResults'
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% 
% Thresholds

PositionThreshold = AnalysisParameters.Prediction.PositionThreshold;
VelocityThreshold = AnalysisParameters.Prediction.VelocityThreshold;

for num_f = 1:numel(AnalysisParameters.filename) % for each file
    %% Loading data
    filename = AnalysisParameters.filename{num_f}(1:end-(numel(AnalysisParameters.General.Extension)-1));
    load('BiomechanicalModel.mat') %#ok<LOAD>
    Human_model = BiomechanicalModel.OsteoArticularModel;
    load([filename '/InverseKinematicsResults.mat']); %#ok<LOAD>
    q = InverseKinematicsResults.JointCoordinates';
    if isfield(InverseKinematicsResults,'FreeJointCoordinates')
        q6dof = InverseKinematicsResults.FreeJointCoordinates';
    else
        PelvisPosition = InverseKinematicsResults.PelvisPosition;
        PelvisOrientation = InverseKinematicsResults.PelvisOrientation;
    end        
    load([filename '/ExperimentalData.mat']); %#ok<LOAD>
    time = ExperimentalData.Time;
    dt=time(2);

    %% Base of support
    % Creation of contact points (all anatomical points of the model)
    ContactPoint = cell(0);
    for m=1:numel(Human_model)
        if numel(Human_model(m).anat_position)
            ContactPoint = [ContactPoint; Human_model(m).anat_position(:,1)]; %#ok<AGROW>
        end
    end
    NbPointsPrediction = numel(ContactPoint); % Number of ground contact points
    for l=1:NbPointsPrediction
        Prediction(l).points_prediction_efforts = ContactPoint{l}; %#ok<AGROW>
    end
    Prediction=verif_Prediction_Humanmodel(Human_model,Prediction);  
    
    % get rid of the 6DOF joint
    if isfield(InverseKinematicsResults,'FreeJointCoordinates')
        Human_model(Human_model(end).child).mother = 0;
        Human_model=Human_model(1:(numel(Human_model)-6));
    end
    
    % Velocity and acceleration for every joint
    dq=derivee2(dt,q);  % velocities
    ddq=derivee2(dt,dq);  % accelerations
    nbframe=size(q,1);
    
    % Kinematical data for Pelvis (Position/speed/acceleration/angles/angular speed/angular acceleration)
    if isfield(InverseKinematicsResults,'FreeJointCoordinates')
        p_pelvis=q6dof(:,1:3);  % frame i : p_pelvis(i,:)
        r_pelvis=cell(size(q6dof,1),1);
        for i=1:size(q6dof,1)
            r_pelvis{i}=Rodrigues([1 0 0]',q6dof(i,4))*Rodrigues([0 1 0]',q6dof(i,5))*Rodrigues([0 0 1]',q6dof(i,6)); % matrice de rotation en fonction des rotations successives (x,y,z) : frame i : r_pelvis{i}
        end
    else
        p_pelvis = cell2mat(PelvisPosition)';
        r_pelvis  = PelvisOrientation';
    end
    %dR
    dR=zeros(3,3,nbframe);
    for ligne=1:3
        for colonne=1:3
            dR(ligne,colonne,:)=derivee2(dt,cell2mat(cellfun(@(b) b(ligne,colonne),r_pelvis,'UniformOutput',false)));
            dR(ligne,colonne,:)=derivee2(dt,cell2mat(cellfun(@(b) b(ligne,colonne),r_pelvis,'UniformOutput',false)));
            dR(ligne,colonne,:)=derivee2(dt,cell2mat(cellfun(@(b) b(ligne,colonne),r_pelvis,'UniformOutput',false)));
        end
    end
    w=zeros(nbframe,3);
    for i=1:nbframe
        wmat=dR(:,:,i)*r_pelvis{i}';
        w(i,:)=[wmat(3,2),wmat(1,3),wmat(2,1)];
    end
    % v0
    v=derivee2(dt,p_pelvis);
    vw=zeros(nbframe,3);
    for i=1:nbframe
        vw(i,:)=cross(p_pelvis(i,:),w(i,:));
    end
    v0=v+vw;
    % dv0
    dv0=derivee2(dt,v0);
    % dw
    dw=derivee2(dt,w);

    % Forward kinematics
    BoS = cell(1,nbframe);
    for i=1:nbframe
        Human_model(1).p = p_pelvis(i,:)';
        Human_model(1).R = r_pelvis{i};
        Human_model(1).v0 = v0(i,:)';
        Human_model(1).w = w(i,:)';
        Human_model(1).dv0 = dv0(i,:)';
        Human_model(1).dw = dw(i,:)';
        for j=2:numel(Human_model)
            Human_model(j).q=q(i,j);
            Human_model(j).dq=dq(i,j);
            Human_model(j).ddq=ddq(i,j);
        end
        [~,Prediction] = ForwardAllKinematicsPrediction(Human_model,Prediction,1); 
        
        % Testing contact points
        ActivePoints = zeros(numel(Prediction),1);
        for l=1:numel(Prediction)
            ActivePoints(l,:) = (Prediction(l).pos_anim(3) < PositionThreshold) && (norm(Prediction(l).vitesse) < VelocityThreshold);
        end
        % Base of support
        if sum(ActivePoints)>3
            PosPoints = [Prediction(find(ActivePoints)).pos_anim]; %#ok<FNDSB>
            h = convhull(PosPoints(1,:), PosPoints(2,:));
            BoS{i} = PosPoints(:,h);
        end        
    end
    
    % Saving data
    InverseKinematicsResults.BoS = BoS;
    save([filename '/InverseKinematicsResults.mat'], 'InverseKinematicsResults');
    
end

end