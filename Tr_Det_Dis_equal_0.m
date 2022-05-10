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

%range of c
c=0:0.001:0.5;

%parameter functions
K4=@(c) (((((K1-1).*(c.^2))-(K2.^2)+(K1.*(K3.^2)))./((c.^6)+((K2.^2).*(c.^4)))).^(1/4)); 
p=@(c) (Ve./((g.*Kinf.*K4(c))-Ve)).^(1./4); %p as function of c
h=@(c) 1./(1+(K4(c).*c)^4); %steady state of h
f1=@(c) (c.^2)./((K2.^2)+(c.^2)); %first bracket of dc/dt
f2=@(c) (c.^2)./((K3.^2)+(c.^2)); %second bracket of dc/dt

%equation for trace
Tr1=@(c) (2.*K1.*c)./((K2.^2)+(c.^2)); %splitting up Tr(J) so its easier to read
Tr2=@(c) 1./(1+((K4(c).*c).^4));
Tr3=@(c) (K2.^2)./((K2.^2)+(c.^2)); 
Tr4=@(c) (2.*c)./((K3.^2)+(c.^2));
Tr5=@(c) (K3.^2)./((K3.^2)+(c.^2));
Tr=@(c) (Tr1(c).*Tr2(c).*Tr3(c))-(Tr4(c).*Tr5(c))-1; %trace Tr(J) 

%determinant
Det1=@(c) (2.*K1.*c)./((K2.^2)+(c.^2)); %splitting up Det(J) so its easier to read
Det2=@(c) 1./(1+((K4(c).*c).^4));
Det3=@(c) ((c.^2)./((K2.^2)+(c.^2)))-1; 
Det4=@(c) (2.*c)./((K3.^2)+(c.^2));
Det5=@(c) 1-((c.^2)./((K3.^2)+(c.^2)));
Det6=@(c) (K1.*(c.^2))./((K2.^2)+(c.^2));
Det7=@(c) (4.*(K4(c).^4).*(c.^3))./((1+((K4(c).*c).^4)).^2);
Det=@(c) (Det1(c).*Det2(c).*Det3(c))+(Det4(c).*Det5(c))+(Det6(c).*Det7(c));

%discriminant
Dis=@(c) ((Tr(c).^2)-(4.*Det(c)));

x0=0.02; %initial guesses for use in fzero
x1=0.25;

options = optimset('Display','iter');

%finding zeroes i.e. Hopf bifurcation points
[y1,fval,exitflag,output] = fzero(Tr,x0, options); 
[y2,fval,exitflag,output] = fzero(Tr,x1, options); 
Tr_left=p(y1) %value of p where Tr=0
Tr_right=p(y2)

%finding zeroes of determinant and discriminant
[u1,fval,exitflag,output] = fzero(Det,0.001, options); 
[u2,fval,exitflag,output] = fzero(Det,0.4, options); 
Det_left=p(u1) 
Det_right=p(u2)

[v1,fval,exitflag,output] = fzero(Dis,0.001, options); 
[v2,fval,exitflag,output] = fzero(Dis,0.3, options);
Dis_left=p(v1) 
Dis_right=p(v2)