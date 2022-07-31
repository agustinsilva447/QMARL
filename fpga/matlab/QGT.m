function [p00, p01, p10, p11] = QGT(rotAx1, rotAy2, rotAx3, rotBx1, rotBy2, rotBx3)

auxAx1 = rotAx1 + 1;
auxAy2 = rotAy2 + 1; 
auxAx3 = rotAx3 + 1; 
auxBx1 = rotBx1 + 1;
auxBy2 = rotBy2 + 1; 
auxBx3 = rotBx3 + 1; 

input = [0.707107; 0; 0; 1i * 0.707107];

cos_rot = [1 0.92388 0.707107 0.382683 0 -0.382683 -0.707107 -0.92388];
sin_rot = [0 0.382683 0.707107 0.92388 1 0.92388 0.707107 0.382683];

G_Rx1 = [cos_rot(auxBx1)*cos_rot(auxAx1) -1i*sin_rot(auxAx1)*cos_rot(auxBx1) -1i*sin_rot(auxBx1)*cos_rot(auxAx1) -sin_rot(auxBx1)*sin_rot(auxAx1);
         -1i*sin_rot(auxAx1)*cos_rot(auxBx1) cos_rot(auxBx1)*cos_rot(auxAx1) -sin_rot(auxBx1)*sin_rot(auxAx1) -1i*sin_rot(auxBx1)*cos_rot(auxAx1);
         -1i*sin_rot(auxBx1)*cos_rot(auxAx1) -sin_rot(auxBx1)*sin_rot(auxAx1) cos_rot(auxBx1)*cos_rot(auxAx1) -1i*sin_rot(auxAx1)*cos_rot(auxBx1);
         -sin_rot(auxBx1)*sin_rot(auxAx1) -1i*sin_rot(auxBx1)*cos_rot(auxAx1) -1i*sin_rot(auxAx1)*cos_rot(auxBx1) cos_rot(auxBx1)*cos_rot(auxAx1)];

G_Ry2 = [cos_rot(auxBy2)*cos_rot(auxAy2) -sin_rot(auxAy2)*cos_rot(auxBy2) -sin_rot(auxBy2)*cos_rot(auxAy2) sin_rot(auxBy2)*sin_rot(auxAy2);
         sin_rot(auxAy2)*cos_rot(auxBy2) cos_rot(auxBy2)*cos_rot(auxAy2) -sin_rot(auxBy2)*sin_rot(auxAy2) -sin_rot(auxBy2)*cos_rot(auxAy2);
         sin_rot(auxBy2)*cos_rot(auxAy2) -sin_rot(auxBy2)*sin_rot(auxAy2) cos_rot(auxBy2)*cos_rot(auxAy2) -sin_rot(auxAy2)*cos_rot(auxBy2);
         sin_rot(auxBy2)*sin_rot(auxAy2) sin_rot(auxBy2)*cos_rot(auxAy2) sin_rot(auxAy2)*cos_rot(auxBy2) cos_rot(auxBy2)*cos_rot(auxAy2)];     

G_Rx3 = [cos_rot(auxBx3)*cos_rot(auxAx3) -1i*sin_rot(auxAx3)*cos_rot(auxBx3) -1i*sin_rot(auxBx3)*cos_rot(auxAx3) -sin_rot(auxBx3)*sin_rot(auxAx3);
         -1i*sin_rot(auxAx3)*cos_rot(auxBx3) cos_rot(auxBx3)*cos_rot(auxAx3) -sin_rot(auxBx3)*sin_rot(auxAx3) -1i*sin_rot(auxBx3)*cos_rot(auxAx3);
         -1i*sin_rot(auxBx3)*cos_rot(auxAx3) -sin_rot(auxBx3)*sin_rot(auxAx3) cos_rot(auxBx3)*cos_rot(auxAx3) -1i*sin_rot(auxAx3)*cos_rot(auxBx3);
         -sin_rot(auxBx3)*sin_rot(auxAx3) -1i*sin_rot(auxBx3)*cos_rot(auxAx3) -1i*sin_rot(auxAx3)*cos_rot(auxBx3) cos_rot(auxBx3)*cos_rot(auxAx3)]; 


J_dg =  [0.707107 0 0 (-1i * 0.707107);
         0 0.707107 (-1i * 0.707107) 0;
         0 (-1i * 0.707107) 0.707107 0;
         (-1i * 0.707107) 0 0 0.707107];
     
state = J_dg * G_Rx3 * G_Ry2 * G_Rx1 * input;
p00 = real(state(1))^2 + imag(state(1))^2;
p01 = real(state(2))^2 + imag(state(2))^2;
p10 = real(state(3))^2 + imag(state(3))^2;
p11 = real(state(4))^2 + imag(state(4))^2;
end