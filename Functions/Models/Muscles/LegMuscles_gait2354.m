function [Muscles]=LegMuscles_gait2354(Muscles, Signe)
% Langage: 9.5.0.1178774 (R2018b) Update 5
% Plate-forme:PCWIN64
% Definition of a muscle model
%   This model contains X muscles
%
%	Based on:
%   INPUT
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - Signe: side of the leg model ('R' for right side or 'L' for left side)
%   OUTPUT
%   - Muscles: new set of muscles (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
if strcmp(Signe,'Right')
    Signe = 'R';
elseif strcmp(Signe,'Left')
Signe = 'L';
else
error('Signe need to be written as Right or Left')
end
s=cell(0);
s=[s;{
['glut_med1_' lower(Signe) ],1119,0.0535,0,0.078,0.13963,{ ['glut_med1_' lower(Signe) '-P1'];['glut_med1_' lower(Signe) '-P2']},{};...
['glut_med2_' lower(Signe) ],873,0.0845,0,0.053,0,{ ['glut_med2_' lower(Signe) '-P1'];['glut_med2_' lower(Signe) '-P2']},{};...
['glut_med3_' lower(Signe) ],1000,0.0646,0,0.053,0.33161,{ ['glut_med3_' lower(Signe) '-P1'];['glut_med3_' lower(Signe) '-P2']},{};...
['bifemlh_' lower(Signe) ],2700,0.109,0,0.326,0,{ ['bifemlh_' lower(Signe) '-P1'];['bifemlh_' lower(Signe) '-P2'];['bifemlh_' lower(Signe) '-P3']},{};...
['bifemsh_' lower(Signe) ],804,0.173,0,0.089,0.40143,{ ['bifemsh_' lower(Signe) '-P1'];['bifemsh_' lower(Signe) '-P2'];['bifemsh_' lower(Signe) '-P3']},{};...
['sar_' lower(Signe) ],156,0.52,0,0.1,0,{ ['sar_' lower(Signe) '-P1'];['sar_' lower(Signe) '-P2'];['sar_' lower(Signe) '-P3'];['sar_' lower(Signe) '-P4'];['sar_' lower(Signe) '-P5']},{};...
['add_mag2_' lower(Signe) ],2343,0.121,0,0.12,0.05236,{ ['add_mag2_' lower(Signe) '-P1'];['add_mag2_' lower(Signe) '-P2']},{};...
['tfl_' lower(Signe) ],233,0.095,0,0.425,0.05236,{ ['tfl_' lower(Signe) '-P1'];['tfl_' lower(Signe) '-P2'];['tfl_' lower(Signe) '-P3'];['tfl_' lower(Signe) '-P4']},{};...
['pect_' lower(Signe) ],266,0.1,0,0.033,0,{ ['pect_' lower(Signe) '-P1'];['pect_' lower(Signe) '-P2']},{};...
['grac_' lower(Signe) ],162,0.352,0,0.126,0.05236,{ ['grac_' lower(Signe) '-P1'];['grac_' lower(Signe) '-P3'];['grac_' lower(Signe) '-P4']},{};...
['glut_max1_' lower(Signe) ],573,0.142,0,0.125,0.087266,{ ['glut_max1_' lower(Signe) '-P1'];['glut_max1_' lower(Signe) '-P2'];['glut_max1_' lower(Signe) '-P3'];['glut_max1_' lower(Signe) '-P4']},{};...
['glut_max2_' lower(Signe) ],819,0.147,0,0.127,0,{ ['glut_max2_' lower(Signe) '-P1'];['glut_max2_' lower(Signe) '-P2'];['glut_max2_' lower(Signe) '-P3'];['glut_max2_' lower(Signe) '-P4']},{};...
['glut_max3_' lower(Signe) ],552,0.144,0,0.145,0.087266,{ ['glut_max3_' lower(Signe) '-P1'];['glut_max3_' lower(Signe) '-P2'];['glut_max3_' lower(Signe) '-P3'];['glut_max3_' lower(Signe) '-P4']},{};...
['iliacus_' lower(Signe) ],1073,0.1,0,0.1,0.12217,{ ['iliacus_' lower(Signe) '-P1'];['iliacus_' lower(Signe) '-P2'];['iliacus_' lower(Signe) '-P4'];['iliacus_' lower(Signe) '-P5']},{};...
['psoas_' lower(Signe) ],1113,0.1,0,0.16,0.13963,{ ['psoas_' lower(Signe) '-P1'];['psoas_' lower(Signe) '-P2'];['psoas_' lower(Signe) '-P4'];['psoas_' lower(Signe) '-P5']},{};...
['quad_fem_' lower(Signe) ],381,0.054,0,0.024,0,{ ['quad_fem_' lower(Signe) '-P1'];['quad_fem_' lower(Signe) '-P2']},{};...
['gem_' lower(Signe) ],164,0.024,0,0.039,0,{ ['gem_' lower(Signe) '-P1'];['gem_' lower(Signe) '-P2']},{};...
['peri_' lower(Signe) ],444,0.026,0,0.115,0.17453,{ ['peri_' lower(Signe) '-P1'];['peri_' lower(Signe) '-P2'];['peri_' lower(Signe) '-P3']},{};...
['rect_fem_' lower(Signe) ],1169,0.114,0,0.31,0.087266,{ ['rect_fem_' lower(Signe) '-P1']},{};...
['vas_int_' lower(Signe) ],5000,0.107,0,0.116,0.05236,{ ['vas_int_' lower(Signe) '-P1'];['vas_int_' lower(Signe) '-P2']},{};...
['med_gas_' lower(Signe) ],2500,0.09,0,0.36,0.29671,{ ['med_gas_' lower(Signe) '-P1'];['med_gas_' lower(Signe) '-P3']},{};...
['soleus_' lower(Signe) ],4000,0.05,0,0.25,0.43633,{ ['soleus_' lower(Signe) '-P1'];['soleus_' lower(Signe) '-P2']},{};...
['tib_post_' lower(Signe) ],3600,0.031,0,0.31,0.20944,{ ['tib_post_' lower(Signe) '-P1'];['tib_post_' lower(Signe) '-P2'];['tib_post_' lower(Signe) '-P3'];['tib_post_' lower(Signe) '-P4']},{};...
['tib_ant_' lower(Signe) ],3000,0.098,0,0.223,0.087266,{ ['tib_ant_' lower(Signe) '-P1'];['tib_ant_' lower(Signe) '-P2'];['tib_ant_' lower(Signe) '-P3']},{};...
['ercspn_' lower(Signe) ],2500,0.12,0,0.03,0,{ ['ercspn_' lower(Signe) '-P1'];['ercspn_' lower(Signe) '-P2']},{};...
['intobl_' lower(Signe) ],900,0.1,0,0.1,0,{ ['intobl_' lower(Signe) '-P1'];['intobl_' lower(Signe) '-P2']},{};...
['extobl_' lower(Signe) ],900,0.12,0,0.14,0,{ ['extobl_' lower(Signe) '-P1'];['extobl_' lower(Signe) '-P2']},{};...
}];
% Structure generation
Muscles=[Muscles;struct('name',{s{:,1}}','f0',{s{:,2}}','l0',{s{:,3}}',...
'Kt',{s{:,4}}','ls',{s{:,5}}','alpha0',{s{:,6}}','path',{s{:,7}}','wrap',{s{:,8}}')]; %#ok<CCAT1>
end
