function [] = jtag_disconnect(t)
    t.writeline("jtag_close")
end