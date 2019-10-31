%% ROCKET OPTIMIZATION CODE

% Initial Values
len_nose = 34.5; % in (plz change)
m_nose = 6; % lbm (plz change)
m_rec = 2; %lbm (plz change)

p_start = 600; % psi
p_inc = 50; % psi
p_end = 600; % psi
T_start = 1000; % lbf
T_end = 1000; % lbf
T_inc = 50; % lbf
OF = 3; % oxidizer to fuel ratio

% Altitude requirements
min_alt_goal = 42500; % ft
max_alt_goal = 47500; % ft

pressures = p_start:p_inc:p_end;
avail_inner_diameters = [5.25 5.5 5.75 6 6.5 7 7.5]; % in
thrusts = T_start:T_inc:T_end;

% Initialize result matrices
% tank pressure = rows, inner diameter = columns, thrust = up
dry_mass = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
rocket_length = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
Isp = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
outer_diameter = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
thickness_tank_CH4 = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
thickness_tank_LOX = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
thickness_fins = zeros(length(pressures), length(avail_inner_diameters), length(thrusts), 4);
max_alt = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
t_apo = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
max_vel = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
max_Mach = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
max_acc = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
alt_max_vel = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
time_vec = zeros(length(pressures), length(avail_inner_diameters), length(thrusts), 75000);
velocity_vec = zeros(length(pressures), length(avail_inner_diameters), length(thrusts), 75000);
altitude_vec = zeros(length(pressures), length(avail_inner_diameters), length(thrusts), 75000);
CH4_tank_outer = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
thrust2weight = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
heat_flux = zeros(length(pressures), length(avail_inner_diameters), length(thrusts));
prop_outputs = zeros(length(pressures), length(avail_inner_diameters), length(thrusts), 12);

row = 1;
col = 1;
up = 1;

anySuccess = 0;

%% Calculations
tic
for thrust_eng = thrusts
    row = 1;
    for tank_pressure = pressures
        col = 1;
        for inner_diameter = avail_inner_diameters
            
            index = [row col up]

            % [m_tank, t_tank, len_tank, o_d] = tankWER(inner_diameter, tank_pressure);
            
            [m_tank, o_d, odCH4, tLOX, tCH4, len_tank] = tankWER(inner_diameter, tank_pressure);

            [m_eng,  Isp_eng, T2W, q_t, output ] = EngineSizing_FilmCooling(thrust_eng, tank_pressure, o_d, OF);

            [~, m_str, len_str] = Vehicle_WER(o_d, 0);

            len_tot = len_nose + len_str + len_tank;

            [m_fins, t_fins] = WER_Fins(len_tot, o_d);

            % [m_rec] = recWER();

            m_tot = m_eng + m_fins + m_tank + m_rec + m_str + m_nose;
            
            o_d
            thrust_eng
            m_tot
            Isp_eng

            [alt, t, v_max, v_max_alt, Mach_num_max, acc_max, velocity, altitude, time]...
                = Function_1DOF(o_d, thrust_eng, m_tot, Isp_eng);
            
            alt
            
            if alt > min_alt_goal && alt < max_alt_goal
            success(i)=[index, alt, m_tot, len_tot, thrust_eng, Isp_eng, o_d, tCH4, tLOX, ...
                t_fins, t, v_max, Mach_num_max, acc_max, v_max_alt,...
                time, altitude, velocity, T2W, q_t, output];
            i=i+1;
            anySuccess = 1;
            end

            % Result matrices of all values
            dry_mass(row, col, up) = m_tot;
            rocket_length(row, col, up) = len_tot;
            Isp(row, col, up) = Isp_eng;
            outer_diameter(row, col, up) = o_d;
            thickness_tank_CH4(row, col, up) = tCH4;
            thickness_tank_LOX(row, col, up) = tLOX;
            thickness_fins(row, col, up, :) = t_fins;
            max_alt(row, col, up) = alt;
            t_apo(row, col, up) = t;
            max_vel(row, col, up) = v_max;
            max_Mach(row, col, up) = Mach_num_max;
            max_acc(row, col, up) = acc_max;
            alt_max_vel(row, col, up) = v_max_alt;
            time_vec(row, col, up, :) = time;
            altitude_vec(row, col, up, :) = altitude;
            velocity_vec(row, col, up, :) = velocity;
            thrust2weight(row, col, up) = T2W;
            heat_flux(row, col, up) = q_t;
            prop_outputs(row, col, up, :) = output;

            col = col + 1;
        end
        row = row + 1;
    end
    up = up + 1;
end

% runtime = toc;

fprintf('Any Successes? %i\n', anySuccess);
% fprintf('Simulation time = %.3f s\n', runtime);

