function [bytes] = jtag_read_bytes(t, addr, n, max)
    max_str = string(max);
    bytes = zeros(1, n);
    pos = 1;
    n_tmp = n;
    while n > max
        pos_nxt = pos+max;
        pos_end = pos_nxt - 1;
        max_cmd = "jtag_read " + " " + string(addr) + " " + max_str;
        read_cmd_safe(t, max_cmd);
        bytes_tmp = eval("[" + t.readline() + "]");
        bytes(pos:pos_end) = bytes_tmp;
        pos = pos_nxt;
        n = n - max;
        addr = addr + max;
    end
    final_cmd = "jtag_read " + " " + string(addr) + " " + string(n);
    read_cmd_safe(t, final_cmd);
    bytes(pos:n_tmp) = eval("[" + t.readline() + "]");
end