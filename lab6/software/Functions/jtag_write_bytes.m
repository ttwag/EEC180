function [] = jtag_write_bytes(t, addr, bytes, max)
    n = length(bytes);
    n_tmp = n;
    bytes_str = strings(1, n);
    i = 1;
    for byte = bytes
        bytes_str(i) = "0x"+dec2hex(byte);
        i = i + 1;
    end
    pos = 1;
    while n > max
        pos_nxt = pos+max;
        pos_end = pos_nxt - 1;
        bytes_w = bytes_str(pos:pos_end);
        bytes_w_len = length(bytes_w);
        max_cmd = "jtag_write " + " " + string(addr) + " " + join(bytes_w);
        t.writeline(max_cmd);
        check_bytes = jtag_read_bytes(t, addr, bytes_w_len, max);
        if check_bytes ~= bytes(pos:pos_end)
            disp("Error writing bytes!");
        end
        pos = pos_nxt;
        n = n - max;
        addr = addr + max;
    end
    bytes_w = bytes_str(pos:n_tmp);
    bytes_w_len = length(bytes_w);
    final_cmd = "jtag_write " + " " + string(addr) + " " + join(bytes_str(pos:n_tmp));
    t.writeline(final_cmd);
    check_bytes = jtag_read_bytes(t, addr, bytes_w_len, max);
    if check_bytes ~= bytes(pos:n_tmp)
        disp("Error writing bytes!");
    end
end