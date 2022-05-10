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

%functions
K4=@(c) (((((K1-1).*(c.^2))-(K2.^2)+(K1.*(K3.^2)))./((c.^6)+((K2.^2).*(c.^4)))).^(1/4)); %K4 as a function of c
p=@(c) (Ve./((g.*Kinf.*K4(c))-Ve)).^(1./4); %p as a function of c
h=@(c) 1./(1+(K4(c).*c)^4); %steady state of h
f1=@(c) (c.^2)./((K2.^2)+(c.^2)); %first bracket of f(c,h)
f2=@(c) (c.^2)./((K3.^2)+(c.^2)); %second bracket of f(c,h)

%solving function p(c) numerically
numSolvedc=[]; %initialise array for c 
pArray=[]; %array of p values to solve for
j=0.01;
i=1;
while j<=0.5
    P=@(c) p(c)-j; 
    numSolvedc(i)=fsolve(P,0); %solve p(c)=j i.e solve p(c)-j=0
    pArray(i)=j;
    j=j+0.005;
    i=i+1;
end

%differentiate using matlab symbolic toolbox 
syms f(c,h) g(c,h) h(c) H varK4 %K4 and H as variables (not functions), needed here
f(c) = (K1.*H.*f1(c))-f2(c); %new model dc/dt
g(c)= 1./(1+(varK4.*c)^4)-H; %new model dh/dt
h(c)= 1./(1+(K4(c).*c)^4);
Fc = diff(f,c); %differentiate 
Fh = diff(f,H);
Gc = diff(g,c);
Gh = diff(g,H);

%replace H with the steady state h(c) and variable varK4 with K4(c)
Fc=subs(Fc,'H',h(c));
Gc=subs(Gc,'varK4',K4(c));

trace=Fc+Gh; %trace 
det=(Fc*Gh)-(Fh*Gc); %determinant
disc=(trace^2)-(4*det); %discriminant

%find the trace, determinant and discriminant at p (and corresponding c) values
for k=1:size(numSolvedc,2)
    traceArray(k)=round(trace(numSolvedc(k)),4);
    detArray(k)=round(det(numSolvedc(k)),4);
    discArray(k)=round(disc(numSolvedc(k)),4);
    k=k+1;
end

%plotting the trace, determinant, discriminant and line through zero
figure('units','normalized','outerposition',[0 0 1 1])
plot(pArray, traceArray, 'k', LineStyle='-', LineWidth=2);
hold on;
plot(pArray, detArray, 'r', LineStyle='--', LineWidth=2);
hold on;
plot(pArray, discArray, 'b', LineStyle='-.', LineWidth=2);
hold on;
plot(pArray,zeros(size(numSolvedc,2)), 'g', LineStyle=':', LineWidth=2);
xlabel('$p$', 'Interpreter','latex');
l=legend('trace', 'determinant', 'discriminant', 'zero', 'Interpreter','latex');
l.LineWidth=1.5;
l.Location='northeastoutside';
set(gca,'fontsize',25)
set(gca,'linewidth',1.5)
