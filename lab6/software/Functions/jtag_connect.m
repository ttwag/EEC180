function [t] = jtag_connect(ip, port, id)
    pause(10)
    t = tcpclient(ip, port, "ConnectTimeout", 5);
    t.writeline("jtag_open" + string(id));
end