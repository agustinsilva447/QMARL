function [prob] = quantum_minority(rx0,ry0,rz0,rx1,ry1,rz1)

phi_0 = [1; 0; 0; 0];
I = [1 0; 0 1];
X = [0 1; 1 0];
I_f = kron(I,I);
X_f = kron(X,X);
J = (1/sqrt(2)) * (I_f + 1i * X_f);
J_dg = J';

Rot_x0 = [    cos(rx0/2) -1i*sin(rx0/2);
          -1i*sin(rx0/2)     cos(rx0/2)];
Rot_x1 = [    cos(rx1/2) -1i*sin(rx1/2);
          -1i*sin(rx1/2)     cos(rx1/2)];
Rot_y0 = [cos(ry0/2) -sin(ry0/2);
          sin(ry0/2)  cos(ry0/2)];
Rot_y1 = [cos(ry1/2) -sin(ry1/2);
          sin(ry1/2)  cos(ry1/2)];
Rot_z0 = [exp(-1i*rz0/2) 0;
          0              exp(1i*rz0/2)];
Rot_z1 = [exp(-1i*rz1/2) 0;
          0              exp(1i*rz1/2)];

Rot_x = kron(Rot_x0, Rot_x1);
Rot_y = kron(Rot_y0, Rot_y1);
Rot_z = kron(Rot_z0, Rot_z1);

phi = J_dg * Rot_z * Rot_y * Rot_x * J * phi_0;
prob = power(abs(phi),2);
end