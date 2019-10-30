%% ROCKET OPTIMIZATION CODE

% Initial Values
len_nose = 12; % in (plz change)
p_start = 200; % psi
p_inc = 25; % psi
p_end = 1000; % psi
pressures = p_start:p_inc:p_end;
avail_inner_diameters = [4.5 5 5.25 5.5 5.75 6 6.5 7 7.5]; % in
i=1;

% Initialize result matrices
% tank pressure = rows, inner diameter = columns
dry_mass = zeros(length(pressures), length(avail_inner_diameters));
length = zeros(length(pressures), length(avail_inner_diameters));
thrust = zeros(length(pressures), length(avail_inner_diameters));
Isp = zeros(length(pressures), length(avail_inner_diameters));
outer_diameter = zeros(length(pressures), length(avail_inner_diameters));
thickness_tank = zeros(length(pressures), length(avail_inner_diameters));
thickness_fins = zeros(length(pressures), length(avail_inner_diameters));
max_alt = zeros(length(pressures), length(avail_inner_diameters));
t_apo = zeros(length(pressures), length(avail_inner_diameters));
max_vel = zeros(length(pressures), length(avail_inner_diameters));
max_Mach = zeros(length(pressures), length(avail_inner_diameters));
max_acc = zeros(length(pressures), length(avail_inner_diameters));
alt_max_vel = zeros(length(pressures), length(avail_inner_diameters));
time_vec = zeros(length(pressures), length(avail_inner_diameters));
velocity_vec = zeros(length(pressures), length(avail_inner_diameters));
altitude_vec = zeros(length(pressures), length(avail_inner_diameters));

row = 1;
col = 1;

for tank_pressure = pressures
    
    for inner_diameter = avail_inner_diameters
        
        [m_tank, t_tank, len_tank, o_d] = tankWER(inner_diameter, tank_pressure);
        
        [m_eng, thrust_eng, Isp_eng] = propWER(tank_pressure);
        
        [m_str, len_str] = structWER(o_d);
        
        len_tot = len_nose + len_str + len_tank;
        
        [m_fins, t_fins] = finWER(len_tot, o_d);
        
        [m_rec] = recWER();
       
        m_tot = m_eng + m_fins + m_tank + m_rec + m_str;
        
        [alt, t, v_max, v_max_alt, Mach_num_max, acc_max, velocity, altitude, time]...
            = Function_1DOF(o_d, thrust_eng, m_tot, Isp_eng);
        if altitude>minalt && altitude<maxalt
            success(i)=[m_tot, len_tot,thrust_eng,Isp_eng,o_d,t_tank,t_fins,alt,t,v_max,Mach_num_max,acc_max,v_max_alt,time,altitude,velocity];
            i=i+1;
        end
        
        dry_mass(row, col) = m_tot;
        length(row, col) = len_tot;
        thrust(row, col) = thrust_eng;
        Isp(row, col) = Isp_eng;
        outer_diameter(row, col) = o_d;
        thickness_tank(row, col) = t_tank;
        thickness_fins(row, col) = t_fins;
        max_alt(row, col) = alt;
        t_apo(row, col) = t;
        max_vel(row, col) = v_max;
        max_Mach(row, col) = Mach_num_max;
        max_acc(row, col) = acc_max;
        alt_max_vel(row, col) = v_max_alt;
        time_vec(row, col) = time;
        altitude_vec(row, col) = altitude;
        velocity_vec(row, col) = velocity;
        
        col = col + 1;
    end
    row = row + 1;
end