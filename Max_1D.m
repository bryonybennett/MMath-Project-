clear all
close all
clc

data= readtable('1D 0.005 t=150-200 p=0.2 NEW.xlsx','Range','A1:C1010000','ReadVariableNames',false);
X=data.Var1; %x values
T=data.Var2; %time t values
C=data.Var3; %calcium concentration c

l=length(X)/101 %there are 101 time steps so divide the total by 101 to find the number of position values
k=1;
maxC=zeros(1,l); %initialise array for maximum concentration for each time t
indexMax=[]; %initialise array for the index of the maximum c
for i=1:l
    for j=(k+50):(k+100) %there are 101 of each time t i.e. 101 x values, so look at positive x in 50-101
        if C(j)>maxC(i) 
            maxC(i)=C(j); %if c is larger than the one in the array replace it
            indexMax(i)=j; %record the index 
        end 
    end
    k=(i*101)+1; 
end
maxC;
indexMax;
maxX=[]; %initialise array for x values at max c
maxT=[]; %initialise array for x values at max c
for i=1:l-1
    maxX(i)=X(indexMax(i)); %find the corresponding x value by using the index found
    maxT(i)=T(indexMax(i));
end
maxX;
maxT;

%% 
notBoundX=[]; %initialise arrays for x and t that are not on the boundary x=3 or x=0
notBoundT=[];
t1=196;
t2=199; %looking in time range t1-t2 for an inward travelling wave
j=1;
for i=((t1-150)/0.005):((t2-150)/0.005) %need t1-k if using t=k-k+50 data 
    if maxX(i)~=3 && maxX(i)>0.001
        notBoundX(j)=maxX(i);
        notBoundT(j)=maxT(i);
        j=j+1;
    end
end
notBoundX;  
notBoundT;
%this can be used for fitting the line now 

p = polyfit(notBoundX,notBoundT,1); %monic polynomial coefficients that best fit data
x=linspace(notBoundX(1),notBoundX(end));
y=p(1)*x+p(2); %polynomial equation
plot(notBoundX, notBoundT, 'b .', MarkerSize=10) %plot the set of data points
hold on;
plot(x,y, 'LineStyle','-', 'LineWidth',2)

abs(p(1)) %gradient dx/dt of best fit line
abs(1/p(1)) %dt/dx

% plot(maxX, maxT, 'b .', MarkerSize=10)
%set axis limits
axis([0 3 151.5 156])
xticks(0:0.5:3)
yticks(150:0.5:200)
xlabel('$x$', 'Interpreter','latex')
ylabel('$t$', 'Interpreter','latex')
set(gca,'fontsize',20)
set(gca,'linewidth',1.5)