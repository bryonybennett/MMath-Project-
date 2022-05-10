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

%functions to be used (cs,hs are the values of c and h at the steady state)
Kinh=@(p) Kinf.*(p.^4./(1+p.^4));
hs=@(cs,p) 1./(1+(Ve./(g.*Kinh(p)).*cs)^4); %steady state of h
f1=@(cs) (cs.^2)./((K2.^2)+(cs.^2)); %first bracket of new model dc/dt
f2=@(cs) (cs.^2)./((K3.^2)+(cs.^2)); %second bracket of new model dc/dt
f=@(cs,p) (K1.*hs(cs,p).*f1(cs))-f2(cs); %new model dc/dt

%solving numerically
K4=@(c) (((((K1-1).*(c.^2))-(K2.^2)+(K1.*(K3.^2)))./((c.^6)+((K2.^2).*(c.^4)))).^(1/4)); %K4 at steady state
p=@(c) (Ve./((g.*Kinf.*K4(c))-Ve)).^(1./4); %p as a function of c
numSolvedc=[]; %initialise array for numerically found c values
pArray=[]; %array of p values to solve for
j=0.01;
i=1;
while j<=0.5
    P=@(c) p(c)-j; 
    numSolvedc(i)=fsolve(P,0); %solve p(c)=j i,e. p(c)-j=0
    pArray(i)=j;
    j=j+0.005;
    i=i+1;
end

%trace
tr1=@(cs) (2.*K1.*cs)./((K2.^2)+(cs.^2)); %splitting up Tr(J) so its easier to read
tr2=@(cs,p) 1./(1+((Ve./(g.*Kinh(p)).*cs).^4));
tr3=@(cs) (K2.^2)./((K2.^2)+(cs.^2)); 
tr4=@(cs) (2.*cs)./((K3.^2)+(cs.^2));
tr5=@(cs) (K3.^2)./((K3.^2)+(cs.^2));
tr=@(cs,p) (tr1(cs).*tr2(cs,p).*tr3(cs))-(tr4(cs).*tr5(cs))-1; %trace Tr(J) 

%determinant
det1=@(cs) (2.*K1.*cs)./((K2.^2)+(cs.^2)); %splitting up Det(J) so its easier to read
det2=@(cs,p) 1./(1+((Ve./(g.*Kinh(p)).*cs).^4));
det3=@(cs) ((cs.^2)./((K2.^2)+(cs.^2)))-1; 
det4=@(cs) (2.*cs)./((K3.^2)+(cs.^2));
det5=@(cs) 1-((cs.^2)./((K3.^2)+(cs.^2)));
det6=@(cs) (K1.*(cs.^2))./((K2.^2)+(cs.^2));
det7=@(cs,p) 1./((1+((Ve./(g.*Kinh(p)).*cs).^4)).^2);
det8=@(cs,p) 4.*((Ve./(g.*Kinh(p))).^4).*(cs.^3);
det=@(cs,p) (det1(cs).*det2(cs,p).*det3(cs))+(det4(cs).*det5(cs))+(det6(cs).*det7(cs,p).*det8(cs,p));

%discriminant
disc=@(cs,p) ((tr(cs,p).^2)-(4.*det(cs,p)));

%find the trace, determinant and discriminant at p (and corresponding c) values
for k=1:size(numSolvedc,2)
    trArray(k)=tr(numSolvedc(k),pArray(k));
    detArray(k)=det(numSolvedc(k),pArray(k));
    disArray(k)=disc(numSolvedc(k),pArray(k));
    k=k+1;
end

%plotting the trace, determinant, discriminant
figure('units','normalized','outerposition',[0 0 1 1])
plot(pArray, trArray, 'k', LineStyle='-', LineWidth=2);
hold on;
plot(pArray, detArray, 'r', LineStyle='--', LineWidth=2);
hold on;
plot(pArray, disArray, 'b', LineStyle='-.', LineWidth=2);
hold on;
plot(pArray,zeros(size(numSolvedc,2)), 'g', LineStyle=':', LineWidth=2);
xlabel('$p$', 'Interpreter','latex');
l=legend('trace', 'determinant', 'discriminant', 'zero', 'Interpreter','latex');
l.LineWidth=1.5;
l.Location='northeastoutside';
set(gca,'fontsize',25)
set(gca,'linewidth',1.5)