function [] = jtag_write_32(t, addr, word, flag)
    final_cmd = "jtag_write_32 " + " " + string(addr) + " " + string(word);
    t.writeline(final_cmd);
    check = jtag_read_32(t, addr, 1);
    if check ~= word
        disp("Write 32 error! " + flag)
    end
end