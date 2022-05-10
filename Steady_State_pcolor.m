%start from a blank slate
clear all
close all
clc

%parameters
K1=4.9;
K2=0.1;
K3=0.05;
Ve=1;
g=0.51;
Kinf=52;

c = 0:0.01:0.5;  % define range of c and p
p = 0:0.01:0.5;

K4=@(c) (((((K1-1).*(c.^2))-(K2.^2)+(K1.*(K3.^2)))./((c.^6)+((K2.^2).*(c.^4)))).^(1/4));
p1=@(c) (Ve./((g.*Kinf.*K4(c))-Ve)).^(1./4);

%plot f(c,p) i.e. new model dc/dt as a function of c and p
Kinh=@(p) Kinf.*(p.^4./(1+p.^4));
K4=@(p) Ve./(g.*Kinh(p));
h=@(c,p) 1./(1+(K4(p).*c).^4); %h at the steady state
f1=@(c) (c.^2)./((K2.^2)+(c.^2)); 
f2=@(c) (c.^2)./((K3.^2)+(c.^2));
f = @(p,c) (K1.*h(c,p).*f1(c))-f2(c); %dc/dt as a function of c and p

[X, Y] = meshgrid(p, c); 
C=f(X,Y); %values of f at each point in the mesh
x=0:0.01:0.5;
y=0:0.01:0.5;
s=pcolor(x,y,C); %pseudocolor plot 
shading interp;
c=colorbar;
c.LineWidth= 1.5;
xlabel('$p$', Interpreter='latex')
ylabel('$c$', Interpreter='latex')
set(gca,'fontsize',15)
set(gca,'linewidth',1.5)