clear all
close all
clc

data= readtable('1D 0.05 -25 25 400 p=0.25.xlsx','Range','A2:C808102','ReadVariableNames',false); %read in the data from COMSOL
X=[-25:0.5:25]; %position x values
T=[0:0.05:400]; %time t values
C=data.Var3; % calcium concentration (c) values
%%
close all
C=reshape(C,101,8001); %c values: columns corresponding to each time step, rows to each position
s=pcolor(X,T,transpose(C)); %pseudocolor plot
shading interp;
c=colorbar;
c.Limits=[0,4];
c.LineWidth= 1.5;
shg
%set axis limits
xticks(-25:5:25);
yticks(0:50:400);
xlabel('$x$', 'Interpreter','latex')
ylabel('$t$', 'Interpreter','latex')
set(gca,'fontsize',15)
set(gca,'linewidth',1.5)