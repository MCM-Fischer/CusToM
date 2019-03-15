function []=InverseDynamics(AnalysisParameters)
% Computation of the inverse dynamics step
%   Computation of joint torques from joint coordinates, external forces
%   and a biomechanical model
%
%	Based on:
%	- Featherstone, R., 2014. Rigid body dynamics algorithms. Springer.
%
%   INPUT
%   - AnalysisParameters: parameters of the musculoskeletal analysis,
%   automatically generated by the graphic interface 'Analysis'.
%   OUTPUT
%   Results are automatically saved on the folder associated to each motion
%   capture in variable 'InverseDynamicsResults'.
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

for num_fil = 1:numel(AnalysisParameters.filename)
    filename = AnalysisParameters.filename{num_fil}(1:end-4);

    disp(['Inverse dynamics (' filename ') ...'])

    %% Chargement des variables
    load('BiomechanicalModel.mat'); %#ok<LOAD>
    Human_model = BiomechanicalModel.OsteoArticularModel;
    load([filename '/ExperimentalData.mat']); %#ok<LOAD>
    time = ExperimentalData.Time;
    load([filename '/InverseKinematicsResults.mat']); %#ok<LOAD>
    q = InverseKinematicsResults.JointCoordinates';
    q6dof = InverseKinematicsResults.FreeJointCoordinates';
    load([filename '/ExternalForcesComputationResults.mat']); %#ok<LOAD>
    if AnalysisParameters.ID.InputData == 0
        external_forces = ExternalForcesComputationResults.NoExternalForce;
    elseif AnalysisParameters.ID.InputData == 1
        external_forces = ExternalForcesComputationResults.ExternalForcesExperiments;
    elseif AnalysisParameters.ID.InputData == 2
        external_forces = ExternalForcesComputationResults.ExternalForcesPrediction;
    end

    freq=1/time(2);

    %% Gravit� (Gravity)
    g=[0 0 -9.81]';

    %% on enl�ve la liaison 6 ddl ajout�e par la cin�matique inverse
    %% get rid of the 6DOF joint
    Human_model=Human_model(1:(numel(Human_model)-6));

    %% D�finition des vitesses / acc�l�rations articulaires
    %% articular speed and acceleration
    dt=1/freq;
    dq=derivee2(dt,q);  % vitesses
    ddq=derivee2(dt,dq);  % acc�l�rations

    nbframe=size(q,1);

    %% D�finition des donn�es cin�matiques du pelvis
    % (position / vitesse / acc�l�ration / orientation / vitesse angulaire / acc�l�ration angulaire)
    % Kinematical data for Pelvis (Position/speed/acceleration/angles/angular speed/angular acceleration)

    p_pelvis=q6dof(:,1:3);  % frame i : p_pelvis(i,:)
    r_pelvis=cell(size(q6dof,1),1);
    for i=1:size(q6dof,1)
        r_pelvis{i}=Rodrigues([1 0 0]',q6dof(i,4))*Rodrigues([0 1 0]',q6dof(i,5))*Rodrigues([0 0 1]',q6dof(i,6)); 
	% matrice de rotation en fonction des rotations successives (x,y,z) : frame i : r_pelvis{i}
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

    %% Dynamique inverse
    %% Inverse dynamics
    torques=zeros(nbframe,numel(Human_model));
    f6dof=zeros(3,nbframe);
    t6dof0=zeros(3,nbframe);
    t6dof=t6dof0;
    FContactDyn=struct('F',[],'T',[]);
    h = waitbar(0,['Inverse Dynamics (' filename ')']);
    for i=1:nbframe
        % attribution � chaque articulation de la position/vitesse/acc�l�ration
        % setting position/speed/acceleration for each joint
        Human_model(1).p=p_pelvis(i,:)';
        Human_model(1).R=r_pelvis{i};
        Human_model(1).v0=v0(i,:)';
        Human_model(1).w=w(i,:)';
        Human_model(1).dv0=dv0(i,:)';
        Human_model(1).dw=dw(i,:)';    
        for j=2:numel(Human_model)
            Human_model(j).q=q(i,j); %#ok<*SAGROW>
            Human_model(j).dq=dq(i,j);
            Human_model(j).ddq=ddq(i,j);
        end
        Human_model = ForwardAllKinematics(Human_model,1);
        [Human_model,f6dof(:,i),t6dof0(:,i)]=InverseDynamicsSolid(Human_model,external_forces(i).fext,g,1);
        % Calcul des efforts au niveau de la liaison 6DoF (transport du moment)
        % Expression of moment reduced at the point of the 6DOF
        t6dof(:,i) = t6dof0(:,i) + cross(f6dof(:,i),p_pelvis(i,:)'); 
        torques(i,2:end)=[Human_model.torques];
        for j=2:numel(Human_model)
            FContactDyn(j).F(:,i) = Human_model(j).f; FContactDyn(j).T(:,i) = Human_model(j).t;
        end
        waitbar(i/nbframe)
    end
    close(h)
    torques=torques'; % lignes : chaque ddl / colonne : chaque frame (lines: dof, columns: frame)

    InverseDynamicsResults.DynamicResiduals.f6dof = f6dof;
    InverseDynamicsResults.DynamicResiduals.t6dof = t6dof; 
    InverseDynamicsResults.JointTorques = torques; 
    InverseDynamicsResults.ForceContactDynamics = FContactDyn;
    
    save([filename '/InverseDynamicsResults'],'InverseDynamicsResults');
    
    disp(['... Inverse dynamics (' filename ') done'])
    
end

end

