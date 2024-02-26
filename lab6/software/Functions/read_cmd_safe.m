function [] = read_cmd_safe(t, cmd)
    if(t.NumBytesAvailable > 0)
        flush(t, "input");
    end
    t.writeline(cmd);
end