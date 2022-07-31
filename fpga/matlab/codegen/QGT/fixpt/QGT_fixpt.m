%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%          Generated by MATLAB 9.10 and Fixed-Point Designer 7.2           %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen
function [p00, p01, p10, p11] = QGT_fixpt(rotAx1, rotAy2, rotAx3, rotBx1, rotBy2, rotBx3)

fm = get_fimath();

auxAx1 = fi(rotAx1 + fi(1, 0, 1, 0, fm), 0, 4, 0, fm);
auxAy2 = fi(rotAy2 + fi(1, 0, 1, 0, fm), 0, 4, 0, fm); 
auxAx3 = fi(rotAx3 + fi(1, 0, 1, 0, fm), 0, 4, 0, fm); 
auxBx1 = fi(rotBx1 + fi(1, 0, 1, 0, fm), 0, 4, 0, fm);
auxBy2 = fi(rotBy2 + fi(1, 0, 1, 0, fm), 0, 4, 0, fm); 
auxBx3 = fi(rotBx3 + fi(1, 0, 1, 0, fm), 0, 4, 0, fm); 

input = fi([0.707107; 0; 0; 1i * 0.707107], 1, 16, 14, fm);

cos_rot = fi([1 0.92388 0.707107 0.382683 0 -0.382683 -0.707107 -0.92388], 1, 16, 14, fm);
sin_rot = fi([0 0.382683 0.707107 0.92388 1 0.92388 0.707107 0.382683], 0, 16, 14, fm);

G_Rx1 = fi([fi(cos_rot(auxBx1)*cos_rot(auxAx1), 1, 16, 15, fm) fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx1)*cos_rot(auxBx1) fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx1)*cos_rot(auxAx1) fi_uminus(sin_rot(auxBx1))*sin_rot(auxAx1);
         fi(fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx1)*cos_rot(auxBx1), 1, 16, 15, fm) cos_rot(auxBx1)*cos_rot(auxAx1) fi_uminus(sin_rot(auxBx1))*sin_rot(auxAx1) fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx1)*cos_rot(auxAx1);
         fi(fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx1)*cos_rot(auxAx1), 1, 16, 15, fm) fi_uminus(sin_rot(auxBx1))*sin_rot(auxAx1) cos_rot(auxBx1)*cos_rot(auxAx1) fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx1)*cos_rot(auxBx1);
         fi(fi_uminus(sin_rot(auxBx1))*sin_rot(auxAx1), 1, 16, 15, fm) fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx1)*cos_rot(auxAx1) fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx1)*cos_rot(auxBx1) cos_rot(auxBx1)*cos_rot(auxAx1)], 1, 16, 14, fm);

G_Ry2 = fi([fi(cos_rot(auxBy2)*cos_rot(auxAy2), 1, 16, 14, fm) fi_uminus(sin_rot(auxAy2))*cos_rot(auxBy2) fi_uminus(sin_rot(auxBy2))*cos_rot(auxAy2) sin_rot(auxBy2)*sin_rot(auxAy2);
         fi(sin_rot(auxAy2)*cos_rot(auxBy2), 1, 16, 14, fm) cos_rot(auxBy2)*cos_rot(auxAy2) fi_uminus(sin_rot(auxBy2))*sin_rot(auxAy2) fi_uminus(sin_rot(auxBy2))*cos_rot(auxAy2);
         fi(sin_rot(auxBy2)*cos_rot(auxAy2), 1, 16, 14, fm) fi_uminus(sin_rot(auxBy2))*sin_rot(auxAy2) cos_rot(auxBy2)*cos_rot(auxAy2) fi_uminus(sin_rot(auxAy2))*cos_rot(auxBy2);
         fi(sin_rot(auxBy2)*sin_rot(auxAy2), 1, 16, 14, fm) sin_rot(auxBy2)*cos_rot(auxAy2) sin_rot(auxAy2)*cos_rot(auxBy2) cos_rot(auxBy2)*cos_rot(auxAy2)], 1, 16, 14, fm);     

G_Rx3 = fi([fi(cos_rot(auxBx3)*cos_rot(auxAx3), 1, 16, 15, fm) fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx3)*cos_rot(auxBx3) fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx3)*cos_rot(auxAx3) fi_uminus(sin_rot(auxBx3))*sin_rot(auxAx3);
         fi(fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx3)*cos_rot(auxBx3), 1, 16, 15, fm) cos_rot(auxBx3)*cos_rot(auxAx3) fi_uminus(sin_rot(auxBx3))*sin_rot(auxAx3) fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx3)*cos_rot(auxAx3);
         fi(fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx3)*cos_rot(auxAx3), 1, 16, 15, fm) fi_uminus(sin_rot(auxBx3))*sin_rot(auxAx3) cos_rot(auxBx3)*cos_rot(auxAx3) fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx3)*cos_rot(auxBx3);
         fi(fi_uminus(sin_rot(auxBx3))*sin_rot(auxAx3), 1, 16, 15, fm) fi(-1i, 1, 2, 0, fm)*sin_rot(auxBx3)*cos_rot(auxAx3) fi(-1i, 1, 2, 0, fm)*sin_rot(auxAx3)*cos_rot(auxBx3) cos_rot(auxBx3)*cos_rot(auxAx3)], 1, 16, 14, fm); 


J_dg =  fi([0.707107 0 0 (-1i * 0.707107);
         0 0.707107 (-1i * 0.707107) 0;
         0 (-1i * 0.707107) 0.707107 0;
         (-1i * 0.707107) 0 0 0.707107], 1, 16, 14, fm);
     
state = fi(J_dg * G_Rx3 * G_Ry2 * G_Rx1 * input, 1, 16, 14, fm);
p00 = fi(real(state(1))^2 + imag(state(1))^2, 0, 16, 15, fm);
p01 = fi(real(state(2))^2 + imag(state(2))^2, 0, 16, 15, fm);
p10 = fi(real(state(3))^2 + imag(state(3))^2, 0, 16, 15, fm);
p11 = fi(real(state(4))^2 + imag(state(4))^2, 0, 16, 15, fm);
end



function y = fi_uminus(a)
    coder.inline( 'always' );
    if isfi( a )
        nt = numerictype( a );
        new_nt = numerictype( 1, nt.WordLength + 1, nt.FractionLength );
        y = -fi( a, new_nt, fimath( a ) );
    else
        y = -a;
    end
end

function fm = get_fimath()
	fm = fimath('RoundingMethod', 'Floor',...
	     'OverflowAction', 'Wrap',...
	     'ProductMode','FullPrecision',...
	     'MaxProductWordLength', 128,...
	     'SumMode','FullPrecision',...
	     'MaxSumWordLength', 128);
end
