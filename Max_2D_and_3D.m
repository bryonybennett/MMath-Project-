clear all
close all
clc

data=readtable('3D data 0.05 cut line 350-400.xlsx','Range','A2:ALN101','ReadVariableNames',false); %read in COMSOL data 
start=350; 
X=data.Var1; %position values 
T=[start:0.05:start+50]; %time values in this data
C = table2array(data(:,2:1002)); %concentrations for each time as an array
l=length(T); 
maxC=zeros(l,1); %initialise maximum concentration for each time array
indexMax=[]; %initialise array for index of max concentration

for i=1:l %if the concentration is greater than the value in maxC, replace it and update the index in indexMax
    for j=50:99
        if C(j,i)>=maxC(i)
            maxC(i)=C(j,i);
            indexMax(i)=j;
        end
    end
end

maxX=[]; %initialise array for x (position) values at max concentration
for i=1:l
    maxX(i)=X(indexMax(i)); %find the corresponding x value by using the index in indexMax
end
%%
close all
notBoundX=[]; %initialise array for positions that are not at the boundary of the domain
notBoundT=[]; %initialise array for the times corresponding to positions in notBoundX
t1=220; %looking in time range t1-t2 for an inward travelling wave
t2=222; 
j=1; 
for i=((t1-start)/0.05):((t2-start)/0.05) %manipulate to get array index corresponding to time t1 - time t2
    if maxX(i)<5.9 && maxX(i)>3.1 %if the position is not at either boundary 
        notBoundX(j)=maxX(i); %add it to the array for positions not at the boundary
        notBoundT(j)=T(i); %update the array for corresponding times 
        j=j+1; %move to the next index in notBoundX and notBoundT
    end
end

%fitting the line
p = polyfit(notBoundX,notBoundT,1); %monic polynomial coefficients that best fit data
x=linspace(notBoundX(1),notBoundX(end)); %100 evenly spaced points 
y=p(1)*x+p(2); %polynomial with the polynomial coefficients found 
plot(notBoundX, notBoundT, 'b .', MarkerSize=10) %plot the position against the time of maximum concentrations in t1-t2
hold on;
plot(x,y, 'LineStyle','-', 'LineWidth',2) %plot the fitted line

abs(p(1)) %output the gradient dx/dt of the fitted line (inverse wave speed)

% plot(maxX,T,'b .', MarkerSize=10)
shg
% axis([3 6 300 400])
xlabel('$x$', 'Interpreter','latex')
ylabel('$t$', 'Interpreter','latex')
set(gca,'fontsize',20)
set(gca,'linewidth',1.5)