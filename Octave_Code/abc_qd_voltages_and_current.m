% Solution of abc to qd voltages and then solving for currents. 
% Rotor speed is constant
%

close all; clear all;
rs=1.2; lq=0.012; ld=0.0057; lamaf=0.123; p=4; vm=10;
wr=2*pi*60; n=1;
for angle=0:0.25:360
  theta=angle*pi/180;       % Angle is converted from deg to rad
  v = [vm*sin(theta); vm*sin(theta-2*pi/3); vm*sin(theta+2*pi/3)]; % abc voltage column vectorize
  % Transformation Matrix from abc to qdo in rotor
  % reference frames
  T = 2/3*[cos(theta) cos(theta-2*pi/3) cos(theta+2*pi/3);
      sin(theta) sin(theta-2*pi/3) sin(theta+2*pi/3) ;
      0.5   0.5     0.5];
      
  vqdo = T*v;           % qdo voltages in rotor reference frame
  vqd = vqdo(1:2);      % only qd voltages in rotor reference frame
  A = [rs wr*ld; -wr*lq rs ];   %Impedance Matrix
  C = [-wr*lamaf; 0];     %Motional emf vector
  iqd = A^-1 *(vqd+C);    % qd currents in rotor ref. frames
  Te(n)=0.75*p*(lamaf +(ld-lq)*iqd(2))*iqd(1);   %Air gap Torque
  iqs(n) = iqd(1);
  ids(n) = iqd(2);
  vqs(n) = vqd(1); vds(n)=vqd(2);
  vas(n) = v(1); vbs(n) = v(2); vcs(n) = v(3);
  T1 = [cos(theta) sin(theta);
        cos(theta - 2*pi/3) sin(theta - 2*pi/3);
        cos(theta + 2*pi/3) sin(theta + 2*pi/3) ];
  iabc = T1 * iqd;        %abc phase current vector
  ias(n) = iabc(1); ibs(n) = iabc(2); ics(n) = iabc(3);
  thet(n) = angle;
  n = n + 1;
end 


subplot(5, 1, 1);
plot(thet, vas, 'k', thet, vbs, 'k', thet, vcs, 'k');
axis([0 360 -12 12]); set(gca, 'xticklabel', []);
subplot(5, 1, 2);
plot(thet, vqs, 'k', thet , vds, 'k');
axis([0 360 -2 12]); set(gca, 'xticklabel', []);
subplot(5, 1, 3);
plot(thet, iqs, 'k', thet, ids, 'k');
axis([0 360 -2 12]); set(gca, 'xticklabel', []);
subplot(5, 1, 4);
plot(thet, ias, 'k', thet, ibs, 'k', thet, ics, 'k');
axis([0 360 -22 22]); set(gca, 'xticklabel', []);
subplot(5,1, 5);
plot(thet, Te, 'k'); axis([0 360 -10 2]);

