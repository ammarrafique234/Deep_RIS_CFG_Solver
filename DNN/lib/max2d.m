function [max_all,max_row,max_col] = max2d(inputArg1)
%MAX2D Returns max_value, row index and column index of maximum value.
[max_val,max_pos] = max(inputArg1);
[max_all, max_pos2] = max(max_val);
max_row=max_pos(max_pos2);
max_col = max_pos2;
end

