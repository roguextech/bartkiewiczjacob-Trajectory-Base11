%% Tank Sizing 
% guesstimates weights of various tank configurations based on thin walled
% hoop stress approximations, script assumes tank pressures are the same

% does not account for compressive, intertial loads
% uhhhhh thocik walls and small radii make thin wall assumption less
% reliable
% strain????
% This flaming pile of shit is absolutley not the fault of Forrest Lim

%% Input Variables
OF = 3 ; % Oxidizer : fuel ratio
Isp = 220 ; % Specific impulse
SF = 4 ; % Safety factor
r = 2.5 ; % Approximate average radius , in
p = 500 ; % tank pressure, PSI
ullage = 15 ; % % ullage percentage
strength = 40000; % yield tensile strength, PSI
maxT = strength / SF ; % max tensile stress
minDeltaP = 50 ; % minimum pressure differential across shared walls
rhoLOx = .0394 ; % density LOx, 1 bar, -280F, lbm/in^3
rhoCH4 = .015 ; % density methane at -260F , lbm/in^3
rhoTank = .1 ; % density of tank material, lbm/in^3

%% Generic Math
wTotal = 9208 / Isp ;
wCH4 = wTotal / ( OF + 1 ) ;
wLOx = wTotal * OF / ( OF + 1 ) ;
vCH4 = ( 1 + ullage / 100 ) * wCH4 / rhoCH4 ;
vLOx = ( 1 + ullage / 100 ) * wLOx / rhoLOx ;
wallThickness = p * r / maxT ; % required wall thickness, based on hoop stresses and maximum tensile stress
domeThickness = p * r / ( 2 * maxT ) ; 

fprintf( "\nTotal propellant weight: %.2f lbf " , wTotal ) ;
fprintf( "\nOF ratio : %.2f " , OF ) ;
fprintf( "\nWeight Methane: %.2f lbf " , wCH4 ) ;
fprintf( "\nWeight LOx : %.2f lbf " , wLOx ) ;
fprintf( "\nVolume Methane, including %.2f percent ullage: %.2f cubic in " , ullage , vCH4 ) ;
fprintf( "\nVolume LOx, incuding %.2f percent ullage : %.2f cubic in " , ullage , vLOx ) ;
fprintf( "\nMinimum wall thickness at %.0f PSI : %.4f in " , p , wallThickness ) ;

%% Separate Tanks
% assumes perfectly hemispherical bulkheads

% CH4
hCH4 = ( vCH4 - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe

% LOx
hLOx = ( vLOx - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe

wStraight = rhoTank * wallThickness * pi * 2 * r * ( hLOx + hCH4 ) ; 
wSeparate = wStraight + ( 8 * pi * r ^ 2 * domeThickness ) ;
 

fprintf( "\nSeparate Tank Total Weight: %.1f lbf" , wSeparate ) ;

%% Shared Bulkhead, Coax
% assumes same pressure in both tanks, tank can be considered single, large
% pressure vessel;
vTotal = vCH4 + vLOx ;
hTotal = ( vTotal - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe
wStraightTotal = rhoTank * wallThickness * pi * 2 * hTotal * r ;
wDomesTotal = 4 * pi * r ^ 2 * domeThickness ;
wSubTotal = wDomesTotal + wStraightTotal ; % weight of outer tank

tSub = minDeltaP * r / maxT ; % thickness required for inner tank or shared bulkhead 
wCoaxInner = rhoTank * tSub * pi * 2 * r * hTotal ;
wSharedDome = rhoTank * pi *  r ^ 2 * tSub ;

% 
fprintf( "\nShared Bulkhead Total Weight: %.1f lbf" , wSubTotal + wSharedDome ) ;
fprintf( "\nCoax Weight: %.1f lbf\n" , wSubTotal + wCoaxInner ) ;


%% Graphs
% a loop cuz im lazy pls no bully
weightSeparate = [ 1 : 10 : 1000 ] ;
weightShared = [ 1 : 10 : 1000 ] ; 
weightCoax = [ 1 : 10 : 1000 ] ; 
pressure = [ 1 : 10 : 1000 ] ; 
for index = 1 : 100 
    wallThickness = pressure( index ) * r / maxT ; % required wall thickness, based on hoop stresses and maximum tensile stress
    domeThickness = pressure( index ) * r / ( 2 * maxT ) ;
    
    hCH4 = ( vCH4 - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe
    hLOx = ( vLOx - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe

    wStraight = rhoTank * wallThickness * pi * 2 * r * ( hLOx + hCH4 ) ; 
    weightSeparate( index ) = wStraight + ( 8 * pi * r ^ 2 * domeThickness ) ;

    vTotal = vCH4 + vLOx ;
    hTotal = ( vTotal - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe
    wStraightTotal = rhoTank * wallThickness * pi * 2 * hTotal * r ;
    wDomesTotal = 4 * pi * r ^ 2 * domeThickness ;
    wSubTotal = wDomesTotal + wStraightTotal ; % weight of outer tank

    tSub = minDeltaP * r / maxT ; % thickness required for inner tank or shared bulkhead 
    wCoaxInner = rhoTank * tSub * pi * 2 * r * hTotal ;
    wSharedDome = rhoTank * pi *  r ^ 2 * tSub ;

    weightShared( index ) = wSubTotal + wSharedDome ;
    weightCoax( index ) = wSubTotal + wCoaxInner ;
end

figure( 1 ) ;
plot( pressure , weightSeparate ) ;
hold on ; 
xlabel( "Tank Pressure, PSI " ) ; 
ylabel( "Weight, lbf" ) ; 
plot( pressure , weightShared ) ;
plot( pressure , weightCoax ) ;
legend( "Separate Tanks" , "Shared Bulkhead", "Coax" ) ;

weightSeparate = [ 2 : .25 : 5 ] ;  
weightShared = [ 2 : .25 : 5 ] ; 
weightCoax = [ 2 : .25 : 5 ] ; 
radius = [ 2 : .25 : 5 ] ; 
for index = 1 : length( radius )  
    r = radius( index ) ;
    wallThickness = p * r / maxT ; % required wall thickness, based on hoop stresses and maximum tensile stress
    domeThickness = p * r / ( 2 * maxT ) ;
    
    hCH4 = ( vCH4 - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe
    hLOx = ( vLOx - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe

    wStraight = rhoTank * wallThickness * pi * 2 * r * ( hLOx + hCH4 ) ; 
    weightSeparate( index ) = wStraight + ( 8 * pi * r ^ 2 * domeThickness ) ;

    vTotal = vCH4 + vLOx ;
    hTotal = ( vTotal - ( 4 / 3 * pi * r ^ 3 ) ) / ( pi * r ^ 2 ) ; % height of straight pipe
    wStraightTotal = rhoTank * wallThickness * pi * 2 * hTotal * r ;
    wDomesTotal = 4 * pi * r ^ 2 * domeThickness ;
    wSubTotal = wDomesTotal + wStraightTotal ; % weight of outer tank

    tSub = minDeltaP * r / maxT ; % thickness required for inner tank or shared bulkhead 
    wCoaxInner = rhoTank * tSub * pi * 2 * r * hTotal ;
    wSharedDome = rhoTank * pi *  r ^ 2 * tSub ;

    weightShared( index ) = wSubTotal + wSharedDome ;
    weightCoax( index ) = wSubTotal + wCoaxInner ;
end

figure( 2 ) ;
title( "Shared Bulkhead Weight vs Radius" ) ;
plot( radius , weightSeparate ) ;
hold on ; 
xlabel( "Tank Radius , in " ) ; 
ylabel( "Weight, lbf" ) ; 
plot( radius , weightShared ) ;
plot( radius , weightCoax ) ;
legend( "Separate Tanks" , "Shared Bulkhead", "Coax" ) ;

clear ;
