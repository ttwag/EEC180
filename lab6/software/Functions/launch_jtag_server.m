function [] = launch_jtag_server(qpath, server_script)
    SYS_CONS = qpath + "\sopc_builder\bin\system-console --script=" + server_script + " &";
    try
        system("taskkill /F /im system-console.exe 2>null");
    catch
        disp("No system-console.exe currently running...");
    end
    system(SYS_CONS);
end