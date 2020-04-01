%Verification of the wrapping for sphere problems
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

% P1=0.8*[0.01,1,1]';
% P2=0.8*[0.01,-.9,-1]';
% R = 0.48;

P1=[0 0 0]';
P2=[0.0213100000000000;0.188071363636364;0.0102800000000000]-[0;0.167400000000000;0]
R = 0.025;

b = Intersect_line_sphere(P1,P2,R);

figure(1);
[x,y,z]=sphere();
s=surf(R*x,R*y,R*z); hold on; axis equal
s.EdgeColor = 'none';
s.FaceAlpha = 0.1;
s.EdgeAlpha = 0.1;


h = plot3point(P1);
h = plot3point(P2);

if b
    [L,Q,T,Pts]=SphereWrapping(P1,P2,R);
    line3(P1,Q);
    line3(P2,T);
    h =plot3(Pts(:,1),Pts(:,2),Pts(:,3),'k*');
else
    line3(P1,P2);
end

disp(['Total distance between the 2 points = ' num2str(L)])


function h = plot3point(Pt)
h =plot3(Pt(1),Pt(2),Pt(3),'r*');
end

function h=line3(Pt1,Pt2)
h=line([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)]);
end