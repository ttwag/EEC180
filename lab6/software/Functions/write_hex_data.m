% Write an n-hex-digit x len(img_data) hex file
%   - write input data in bytes
function [] = write_hex_data(fh, img_data, n_dig)
    fid = fopen(fh,'w');
    %data_str = join(string(img_data));
    % eval_str = 'hex_data = compose("%0' ... 
    %            + string(n_dig) + 'x",[' ... 
    %            + data_str + "])";
    % eval(eval_str);
    formatSpec = '%0' + string(n_dig) + 'x';
    hex_data = compose(formatSpec, img_data); 
    fprintf(fid, join(hex_data, "\n"));
    fclose(fid);
end