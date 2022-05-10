clear all
close all
clc

%initial conditions of c and h
initial=[1,1];

%range of t
timeRange=[0,100];

%solution
[t,y] = ode45(@New, timeRange , initial);
[pks,locs] = findpeaks(y(:,1)); %find the peaks of c (calcium concentration)
length(pks); %find the number of peaks

hold on 
plot(t,y(:,1), LineStyle='-', LineWidth=2) % plots the first solution (c)
plot(t,y(:,2), LineStyle='--', LineWidth=2) % plots the second solution (h)
l=legend('$c$','$h$', 'Interpreter','latex') 
legend boxoff;
xlabel('$t$', 'Interpreter','latex')
set(gca,'fontsize',20)
set(gca,'linewidth',1.5)
xlim([0 100]) %set the axis limits
ylim([0 3.5])
yticks(0:0.5:3.5)
xticks(0:20:100)
function A= New(t,y) 

%parameters
K1=4.9;
K2=0.1;
K3=0.05;
Ve=1;
g=0.51;
Kinf=52;
p=0.2;

%ODEs to solve
dcdt=K1*y(2)*((y(1)^2)/(K2^2+y(1)^2))-((y(1)^2)/(K3^2+y(1)^2)); %equation dc/dt 
dhdt=1/(1+((Ve/(g*(Kinf*(p^4/(1+p^4))))*y(1))^4))-y(2); %equation dh/dt 

A= [dcdt; dhdt];

end