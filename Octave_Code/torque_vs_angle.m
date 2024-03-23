% Steady state torque versus angle characteristics for constant stator
%     Current Phasor
%
clear all; close all;

m=0;
%Data starts here
Rs=1.2;                 %Stator resistance per phase
lq=0.0125;              % Q axis inductance
ld=0.0057;              % D axis inductance 
ro=lq/ld;               % Sailency Ratio
Rc=416;                 % Core Loss Resistance
lamaf=0.123;            % Rotor Flux Linkages
Pb=121;                 % Base Power Loss
Tb=2.43;                % Base Torque
Ib=4.65;                % Base current
P=4;                    % Number of Poles
w = (2*pi*3500/60)*P/2; % Electrical Rotor Speed
%Pb is rated loss. Actual base power is 890W for this machine.
%Computation Starts here
for isn=2.325:0.465:4.65;     % Stator current phasor Magnitude
  m = m + 1;
  n = 1;
  for del= 0:0.05:180;        % Torgue Angle , deg
    delt = del*pi/180;        % Torque Angle rad
    ide = isn*cos(delt);      % D axis current in rotor ref frames
    iqe = isn*sin(delt);      % Q axis current in rotor ref frames
    tes(m,n)=0.75*P*iqe*lamaf/Tb; % Synchronous Torgue, p.u.
    ter(m,n)=0.75*P*iqe*ld*(1-ro)*ide/Tb; % Reluctance Torque, p.u.
    te(m,n)=tes(m,n)+ter(m,n);    % Air Gap Torque, p.u.
    delta(n) = del;
    n=n+1;
  endfor
endfor
%Computation ends here and plotting begins
plot(delta, te, 'k');          %Air gap torque vs. angle
figure(2);
plot(delta, te, delta, tes, delta, ter) %Rel.. syn. and air gap torque vs. angle
