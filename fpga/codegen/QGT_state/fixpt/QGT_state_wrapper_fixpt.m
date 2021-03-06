%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%          Generated by MATLAB 9.10 and Fixed-Point Designer 7.2           %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p00,p01,p10,p11] = QGT_state_wrapper_fixpt(rotAx1,rotAy2,rotAx3,rotBx1,rotBy2,rotBx3)
    fm = get_fimath();
    rotAx1_in = fi( rotAx1, 0, 3, 0, fm );
    rotAy2_in = fi( rotAy2, 0, 3, 0, fm );
    rotAx3_in = fi( rotAx3, 0, 3, 0, fm );
    rotBx1_in = fi( rotBx1, 0, 3, 0, fm );
    rotBy2_in = fi( rotBy2, 0, 3, 0, fm );
    rotBx3_in = fi( rotBx3, 0, 3, 0, fm );
    [p00_out,p01_out,p10_out,p11_out] = QGT_state_fixpt( rotAx1_in, rotAy2_in, rotAx3_in, rotBx1_in, rotBy2_in, rotBx3_in );
    p00 = double( p00_out );
    p01 = double( p01_out );
    p10 = double( p10_out );
    p11 = double( p11_out );
end

function fm = get_fimath()
	fm = fimath('RoundingMethod', 'Floor',...
	     'OverflowAction', 'Wrap',...
	     'ProductMode','FullPrecision',...
	     'MaxProductWordLength', 128,...
	     'SumMode','FullPrecision',...
	     'MaxSumWordLength', 128);
end
