% NOTE: TO COMPARE RESULTS - Open New_Force_Single_Coil - Here distance is varied for a fixed height. In this Program Height is varied for a fixed distance. 
% OBSERVATION: As I increases, a robot with higher height can be choosen
clear;
clc;
% Analysing field along a single wire...
% Constants 
I = -0.2;       %Current flowing in the wire
g = 200e-6;     %Coil spacing
m0 = 4*pi*1e-7;
c = -1000e-6:25e-6:1000e-6;
z = 150e-6; %0.15mm
y = 0;
radius = 3e-3;%m
height = 1e-3;%m
Magentization = 1.45; %T
vol_cy = pi*radius^2*height; %If Object is Cylinder, vol in m^3
vol_sp = (4/3)*(pi * radius^3); %If Object is Sphere, vol in m^3
density = 7300; %kg/m^3 or 7.3 gm/cc for NdFeB 
mass_cy = density * vol_cy; %kg
mass_sp = density * vol_sp; %kg
gravity = 9.8 ; %m/s^2
Coeff_of_Fric = 1;
Force_cy = Coeff_of_Fric * mass_cy * gravity; %N
Force_sp = Coeff_of_Fric * mass_sp * gravity; %N
k = 0.4e-3;
%--------%--------%--------%--------%--------%--------%--------%----------
% Line along Y - axis
%-%--------%--------%--------%--------%--------%--------%--------%--------
y1_1 = -0.6e-3;
y2_1 = 0.6e-3;
a_xp_1 = g;  
a_xn_1 = -g;
[X,Z] = meshgrid(c);


k_yp = 1./(4*pi*((a_xp_1-X).^2+Z.^2));
k_1yp = (y2_1-y)./((y2_1-y)^2+(a_xp_1-X).^2+Z.^2).^0.5;
k_2yp = (y1_1-y)./((y1_1-y)^2+(a_xp_1-X).^2+Z.^2).^0.5;

k_1yp_3 = (y2_1-y)./((y2_1-y)^2+(a_xp_1-X).^2+Z.^2).^1.5;
k_2yp_3 = (y1_1-y)./((y1_1-y)^2+(a_xp_1-X).^2+Z.^2).^1.5;

Bx_yp_1 = -(Z.*k_yp.*(k_1yp - k_2yp))*I*m0;
By_yp_1 = m0*zeros(size(X,1),size(Z,1));
Bz_yp_1 = (-(a_xp_1-X).*k_yp.*(k_1yp - k_2yp))*I*m0;

k_yn_1 = 1./(4*pi*((a_xn_1-X).^2+Z.^2));
k_1yn_1 = (y2_1-y)./((y2_1-y)^2+(a_xn_1-X).^2+Z.^2).^0.5;
k_2yn_1 = (y1_1-y)./((y1_1-y)^2+(a_xn_1-X).^2+Z.^2).^0.5;

Bx_yn_1 = (Z.*k_yn_1.*(k_1yn_1 - k_2yn_1))*I*m0;
By_yn_1 = m0*zeros(size(X,1),size(Z,1));
Bz_yn_1 = ((a_xn_1-X).*k_yn_1.*(k_1yn_1 - k_2yn_1))*I*m0;

[df_xx,df_xz] = gradient(Bx_yp_1,25e-6); %[dBx/dx, dBx/dz]

[df_xx_n,df_xz_n] = gradient(Bx_yn_1,25e-6); %[dBx/dx, dBx/dz]

%--------%--------%--------%--------%--------%--------%--------%----------
% Line along X - axis
%-%--------%--------%--------%--------%a--------%--------%--------%--------

[Y,Z] = meshgrid(c);
x1_1 = -0.6e-3;
x2_1 = 0.6e-3;
a_yp_1 = g;          %Distance of coil from (0,0)
x = 0;
coil_length_x_1 = x2_1 - x1_1;
k_p_1 = 1./(4*pi*((a_yp_1-Y).^2+Z.^2));
k_1xp_1 = (x2_1-x)./((x2_1-x).^2+(a_yp_1-Y).^2+Z.^2).^0.5;
k_2xp_1 = (x1_1-x)./((x1_1-x).^2+(a_yp_1-Y).^2+Z.^2).^0.5;

Bx_xp_1 = m0*zeros(size(Y,1),size(Z,1));
By_xp_1 = (-Z.*k_p_1.*(k_1xp_1 - k_2xp_1))*I*m0;
Bz_xp_1 = (-(a_yp_1-Y).*k_p_1.*(k_1xp_1 - k_2xp_1))*I*m0;

a_yn_1 = -g;
k_n_1 = 1./(4*pi*((a_yn_1-Y).^2+Z.^2));
k_1xn_1 = (x2_1-x)./((x2_1-x).^2+(a_yn_1-Y).^2+Z.^2).^0.5;
k_2xn_1 = (x1_1-x)./((x1_1-x).^2+(a_yn_1-Y).^2+Z.^2).^0.5;

Bx_xn_1 = m0*zeros(size(Y,1),size(Z,1));
By_xn_1 = (Z.*k_n_1.*(k_1xn_1 - k_2xn_1))*I*m0;
Bz_xn_1 = ((a_yn_1-Y).*k_n_1.*(k_1xn_1 - k_2xn_1))*I*m0;

[dBy_1_dy,dBy_1_dz] = gradient(By_xp_1,25e-6);

[dBy_1_dyn,dBy_1_dzn] = gradient(By_xn_1,25e-6);

%--------%--------%--------%--------%--------%--------%--------%----------
% Force along X - axis
%-%--------%--------%--------%--------%--------%--------%--------%--------

F_xx = vol_cy * Magentization* (df_xx + df_xx_n)/m0;
F_xz = vol_cy * Magentization* (df_xz + df_xz_n)/m0;

%--------%--------%--------%--------%--------%--------%--------%----------
% Force along Y - axis
%-%--------%--------%--------%--------%--------%--------%--------%--------

F_yy = vol_cy * Magentization* (dBy_1_dy + dBy_1_dyn)/m0;
F_yz = vol_cy * Magentization* (dBy_1_dz + dBy_1_dzn)/m0;


%--------%--------%--------%--------%--------%--------%--------%----------
% Plotting "Force generated by Field along X - axis (N)"
%-%--------%--------%--------%--------%--------%--------%--------%--------
p = 46;     %Change this to set the distance of bot.
figure
plot(Z(41:81,1),F_xx(41:81,p), '--b') 
hold on
plot(Z(41:81,1),F_xz(41:81,p),'r')
line([0 1e-3],[Force_cy Force_cy],'linewidth',3,'color','r')
% line([a_yn_1 a_yn_1],[-1e-3 1e-3],'linewidth',10,'color','g');
line([a_yp_1,a_yp_1],[-1e-3 1e-3],'linewidth',10,'color','g');
legend('F_xx', 'F_xz')
xlabel("Height of the bot (m)")
ylabel("Force generated by Field along X - axis (N)")
title("Variation in Force generated by Field along X - axis")
hold off
%--------%--------%--------%--------%--------%--------%--------%----------
% Plotting "Force generated by Field along Y - axis (N)"
%-%--------%--------%--------%--------%--------%--------%--------%--------
figure
plot(Z(41:81,1),F_yy(41:81,p), '--b')  %Z - 41-> 81 because height is positive. When compared with distance file, check height in this range only, so as to get the sign correctly.
hold on
plot(Z(41:81,1),F_yz(41:81,p),'r')
% line([0 0],[-1e-3 1e-3],'linewidth',10,'color','g');
line([a_xp_1,a_xp_1],[-1e-3 1e-3],'linewidth',10,'color','g');
line([0 1e-3],[Force_cy Force_cy],'linewidth',3,'color','r')
legend('F_yy', 'F_yz')
xlabel("Height of the bot (m)")
ylabel("Force generated by Field along X - axis (N)")
title("Variation in Force generated by Field along Y - axis")
hold off