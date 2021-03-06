function [intertank] = intertank_mass(tank, material)

intertank.h = (tank(1).dome_h + tank(2).dome_h + 5); %in

intertank.thick = min(tank(1).thick, tank(2).thick); %in

intertank.mat_v = pi*(tank(1).diameter^2/4-(tank(1).diameter/2-intertank.thick)^2)*intertank.h; %in^3
intertank.mass = material.density * intertank.mat_v; %lbm

intertank.fastener_mass = 1; %lbm
intertank.total_m = intertank.fastener_mass + intertank.mass;

end