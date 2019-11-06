clear; clc;

% retrieve aerodynamic data
Cd_data = load('cd_M.csv');
Cn_data = load('cl_M_a.csv');
Cp_data = load('cp_M_a.csv');
alpha_data = load('alpha_data.csv');
M_data = load('M_data.csv');
air_data = load('air_data.csv');

% design parameters
d = 16*0.0254; % m
r = d/2; % m
S = pi*d^2/4; % m2
len = 24*0.3048; % m
throttle = 1;
T = 5100; %[lbs]
T_th = T*throttle;
t_th = 0;
margin = 60;
burn_time = (200000 - T*t_th)/T_th; % s
m_wet = 1437.33*0.453592 + margin*0.453592; % kg
mdot = 23.34*0.453592; % kg/s
mdot_th = mdot*throttle;
m_dry = m_wet - mdot*t_th - mdot_th*burn_time + margin*0.453592; % kg
CG = len/2; % m

% initial position
theta0 = 0; % rad
psi0 = 0; % rad
h0 = 4595*0.3048; % m
u0 = 0.1; % m/s
v0 = 0.1;
w0 = 0.1;

% wind
lat = 32.9861;
lon = -106.9717;
day = 119;
sec = 12*3600;
h_trailer = 75*0.3048;

%rail
lr = 75*0.3048;
x1 = len*3/4;
x2 = len*1/4;
mu = 0.42;

% engine %[lbs]
De = 8.4932;
Dt = 3.0968;
At = pi*Dt^2/4;
Pc = 450;
Pe = 10;
AR = De^2/Dt^2;

%heating data
cp = 910; %Material Specific Heat [J/kg*K]
material_density = 2700; %kg/m^3
x = 0.1; %Analysis Location from Nose Tip [m]
t = 0.07*0.0254; %Skin thickness[m]
figure(1)
i = 1;
n = 10;
qdl_tot = 0;
kc = 0.35;
tc = 0.03;
x = 3*d;
% for kc = linspace(0.01, 1, 20) 
%     Wall_Temp = 500;
%     while max(Wall_Temp) > 475
%         sim('eqns_motion_mdl.slx')
%         tc = tc + 0.0005;
%     end
%     tr(i) = tc;
%     i = i + 1;
% end 
% kc = linspace(0.01, 1, 20);
% plot(kc, tr);
title('Thickness Required vs. Thermal Conductivity');
xlabel('K [W/mK]')
ylabel('Thickness [m]')
grid on
% x3 = linspace(0.1, len, n);
% legendCell = cellstr(num2str(x3', 'Distance From Nose Tip =%-.2f m'));
% legend(legendCell);
% title('Wall Temp vs. Time')
% xlabel('Time [sec]')
% grid on
% hold off
% figure(2)
% qd_tot.value = qdl_tot*1.3;
% qd_tot.time = heat_in.time;
% plot(heat_in.time, qd_tot.value);
 

