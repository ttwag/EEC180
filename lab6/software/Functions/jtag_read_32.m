function [words] = jtag_read_32(t, addr, n)
    final_cmd = "jtag_read_32 " + " " + string(addr) + " " + string(n);
    read_cmd_safe(t, final_cmd);
    words = eval("[" + t.readline() + "]");
end