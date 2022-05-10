clear all
close all
clc

c = 0:0.01:0.5;  % define range 

%parameters
K1=4.9;
K2=0.1;
K3=0.05;
Ve=1;
g=0.51;
Kinf=54;

%functions
K4=@(c) (((((K1-1).*(c.^2))-(K2.^2)+(K1.*(K3.^2)))./((c.^6)+((K2.^2).*(c.^4)))).^(1/4)); %K4 in terms of c
p=@(c) (Ve./((g.*Kinf.*K4(c))-Ve)).^(1./4); %p as function of c

%plot equilibrium curve
plot(p(c), c, 'k', LineStyle='-', LineWidth=2);
xlabel('$p$', Interpreter='latex')
ylabel('$c$', Interpreter='latex')
set(gca,'fontsize',15)
set(gca,'linewidth',1.5)