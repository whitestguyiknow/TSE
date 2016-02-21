function [sys_par] = createSysPar()
%TODO:: all vars here

sys_par.fileName = './dat/Stoch_optim.csv';
sys_par.equityInit = 100000;
sys_par.comission = 0.5*8/100000;
sys_par.tInit = 100;
sys_par.insamplePCT = 0.7;

end

