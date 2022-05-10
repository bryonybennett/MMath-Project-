clear all
close all
clc

%solves the PDE
[K1,K2,K3,Ve,g,Kinf,D,p]=param;
m = 0;
x = linspace(-3,3,100); %specify x values
t = linspace(0,50,100); %specify time range
sol = pdepe(m,@eqn1,@initial1,@bc1,x,t);
u1 = sol(:,:,1); %solution for c
u2 = sol(:,:,2); %solution for h
surf(x,t,u1); %solution for c as a surface plot
view(2)
c=colorbar;
c.Limits=[0,4];
c.LineWidth= 1.5;
shading interp
axis([-3 3 0 50])
xticks(-3:1:3) %set x axis values
xlabel('$x$', 'Interpreter','latex')
ylabel('$t$', 'Interpreter','latex')
set(gca,'fontsize',20)
set(gca,'linewidth',1.5)

function [K1,K2,K3,Ve,g,Kinf,D,p]=param %function containing parameters
K1=4.9;
K2=0.1;
K3=0.05;
Ve=1;
g=0.51;
Kinf=52;
D=0.1;
p=0.25;
end 

function [c,b,s] = eqn1(x,t,u,DuDx)
[K1,K2,K3,Ve,g,Kinf,D,p]=param;
%contains the coefficents for a system of two PDE in time and one space dimension
%c=u(1) and h=u(2)
c = [1; 1];
b = [D; 0] .* DuDx;
s = [(K1.*u(2).*((u(1).^2)./((K2.^2)+(u(1).^2))))-((u(1).^2)./((K3.^2)+(u(1).^2))); (1./(1+(((Ve./(g.*(Kinf.*(p.^4./(1+p.^4))))).*u(1)).^4)))-u(2)];
end

function [pl,ql,pr,qr] = bc1(xl,ul,xr,ur,t)
%no flux boundary conditions
pl = [0; 0];
ql = [1; 1];
pr = [0; 0];
qr = [1; 1];
end

function value = initial1(x)
[K1,K2,K3,Ve,g,Kinf,D,p]=param;
syms c
cp = vpasolve((Ve./((g.*Kinf.*(((((K1-1).*(c.^2))-(K2.^2)+(K1.*(K3.^2)))./((c.^6)+((K2.^2).*(c.^4)))).^(1/4)))-Ve)).^(1./4)==p,c,[0,0.5]); %numerically solves function p for c 
hp= 1./(1+(((((((K1-1).*(cp.^2))-(K2.^2)+(K1.*(K3.^2)))./((cp.^6)+((K2.^2).*(cp.^4)))).^(1/4))).*cp).^4);
S=10;
sig=0.01;
value = [cp+4.*exp(-0.5.*(x.^2)./(S.*sig).^2); hp];
end  
