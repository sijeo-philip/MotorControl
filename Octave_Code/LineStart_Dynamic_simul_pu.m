% Line start Dynamic Simulation of the PMSM using per unit model
% 
% Pb - Base Power,, Tb- Base Torque, Ib - Base Current, P - Poles, 
% lamaf - rotor flux linkages, Rs - stator resistance per phase, 
% lq - q axis inductance, ld - d axis inductance, ro - sailency ratio
%
clear all; close all;
m=0;
lq=0.0125; ld=0.0057; ro=lq/ld; Rc=416; lamaf=0.123; Rs=1.2;
Pb=890; Tb=2.43; Ib=4.65; P=4;
ws=(2*pi*1800/60)*P/2;            %Stator Frequency, rad/sec
B=0.0005;                         %Friction Coeff of load and machine
J=0.0002;                         %Moment of Inertia of load and machine
tln=0;                            %Load Torque, p.u.
%Base values
Vb=Pb/(3*Ib);                     %Base Voltage
zb=Vb/Ib;                         %Base Impedance
lamb=lamaf;                       %Base Flux Linkage
lb=lamb/Ib;                       %Base Inductance
wb=Vb/lamb;                       %Base speed
rsn=Rs/zb;                        %normalized resistance
lqn=lq/lb;                        %normalized q axes inductance
ldn=ld/lb;                        %normalized d axes inductance
Bn=B*wb^2/(Pb*(P/2)^2);           %normalized Friction Coefficient
H=J*wb^2/(2*Pb*(P/2)^2);          %normailzed Inertia
lamafn=lamaf/lamb;                %Normalized rotor flux linkages
%Actual base power is 890W for this machine. 
%Initial Conditions
x1=0;                             %q axis current in rot. ref. frame. p.u. 
x2=0;                             %d axis current in rot. ref. frame. p.u.
x3=0;                             %rotor speed p.u.
x4=0;                             %Instantaneous Rotor Position, rad.
tp=2*pi/3;
n=1;
dt=0.0001;                        %Integration Step interval, sec
for t=0:0.0001:0.1;
  wst=ws*t;                       %Stator phase angle..
  vabc= [sin(wst); sin(wst-tp); sin(wst+tp)];
  %transformation to dq axis in the rotor
  T = 2/3*[cos(x4) cos(x4-tp) cos(x4+tp);
           sin(x4) sin(x4-tp) sin(x4+tp);
           0.5 0.5 0.5];
  vqdo=T*vabc;
  %q axis volt.eqn
  x1=x1+dt*wb*(-rsn/lqn*x1-x3*ldn/lqn*x2+1/lqn*(vqdo(1)-x3*lamafn));
  x2=x2+dt*wb*(x3*lqn/ldn*x1-rsn/ldn*x2+vqdo(2)/ldn); %d axis volt. eqn
  Ten=(lamafn-(ldn-lqn)*x2)*x1;                     %Electromagnetic Torque
  x3=x3+dt*(Ten-Bn*x3-tln)/(2*H);                   %Rotor Speed Equation
  x4=x4+dt*x3*wb;                                   %Rotor Position Equation
  %q axis volt eqn
  iqd=[x1;x2];                              %qd stator current in rotor reference frame
  T1 = [cos(x4)     sin(x4);      %Transformation from qd to abc currents
        cos(x4-tp)  sin(x4-tp);
        cos(x4+tp)  sin(x4+tp)];
  iabc = T1*iqd;                  %abc Current Vector
  %Storing variables for plotting 
  vas(n)=vabc(1);
  vqs(n)=vqdo(1);
  vds(n)=vqdo(2);
  ias(n)=iabc(1);
  ibs(n)=iabc(2);
  Te(n)=Ten;
  speed(n)=x3;
  time(n)=t;
  n=n+1;
endfor
%Plotting Begins
subplot(5,1,1);
plot(time, vas, 'k');
axis([0 0.1 -1.2 1.2]); set(gca, 'xticklabel', []);
subplot(5,1,2);
plot(time, vqs, 'k', time, vds, 'k');
axis([0 0.1 -1.2 1.2]); set(gca, 'xticklabel', []);
subplot(5,1,3);
plot(time, ias, 'k', time, ibs, 'k');
axis([0 0.1 -6 6]); set(gca, 'xticklabel', []);
subplot(5, 1, 4);
plot(time, Te, 'k');
axis([0 0.1 -5 5]); set(gca, 'xticklabel', []);
subplot(5, 1, 5);
plot(time, speed, 'k');
axis([0 0.1 0 1.2]);