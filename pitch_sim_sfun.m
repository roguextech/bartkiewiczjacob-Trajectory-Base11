function [sys,x0,str,ts] = pitch_sim_sfun(t,x,w,flag)
% t is time
% x is state
% u is input
% flag is a calling argument used by Simulink.
% The value of flag determines what Simulink wants to be executed.
switch flag
case 0 % Initialization
[sys,x0,str,ts]=mdlInitializeSizes;
case 1 % Compute xdot
sys=mdlDerivatives(t,x,w);
case 2 % Not needed for continuous-time systems
case 3 % Compute output
sys = mdlOutputs(t,x,w);
case 4 % Not needed for continuous-time systems
case 9 % Not needed here
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlInitializeSizes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [sys,x0,str,ts]=mdlInitializeSizes
%
% Create the sizes structure 
sizes=simsizes;
sizes.NumContStates = 2; % Set number of continuous-time state variables
sizes.NumDiscStates = 0;
sizes.NumOutputs = 0; % Set number of output variables
sizes.NumInputs = 1; % Set number of input variables
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1; % Need at least one sample time
sys = simsizes(sizes);
%
global init
x0 = init; % Set initial state
%
str=[]; % str is always an empty matrix
ts=[0 0]; % ts must be a matrix of at least one row and two columns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlDerivatives
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function sys = mdlDerivatives(t,x,w)
%
% Compute xdot based on (t,x,w) and set it equal to sys
%
sys = pitch_sim_eqns_corr(t,x,w);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlOutput
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function sys = mdlOutputs(t,x,w)
% Compute output based on (t,x,w) and set it equal to sys
sys = [];

