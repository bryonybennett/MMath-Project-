clear all
close all
clc

%wave speeds in each dimension
Wavespeeds_1D=[170.80,165.26,134.81,162.32,154.33,133.89,164.56,77.39,186.21,132.66,115.89,109.88,87.38,140.36,55.43,139.61,101.83,106.97,175.61,118.12,94.47,80.62,116.54,92.27,61.90,175.38,128.07,46.59,73.08,72.14,69.61,61.73];
Wavespeeds_2D=[179.07,91.63,82.61,169.11,77.84,203.19,143.91,104.91,101.36,133.66,147.59,71.67,158.96,110.16,155.93,85.16,156.61,153.07,123.63,100.04,96.80,117.03,150.89,122.86,151.47,173.67,152.35,69.70,92.60,183.51,67.52, 126.05];
Wavespeeds_3D=[110.90,85.75,91.11,102.26,127.91,126.05,166.03,86.59,181.47,103.94,175.38,119.38,84.46,143.75,148.15,124.57,109.21,178.82,95.02,271.01,156.99,157.11,111.25,167.09,84.92,140.46,161.85,147.98,106.05,104.21,132.84,111.47];
allDim=[Wavespeeds_1D, Wavespeeds_2D, Wavespeeds_3D]; 
X=reshape(allDim,[],3) %array with rows 1,2,3 containing the wave speeds from 1D,2D,3D 
%%
close
edges=[0:25:300] %bin edges for histograms
%histogram plots for 1D,2D,3D wave speeds
h1=histogram(Wavespeeds_1D,6, LineWidth=1.5, LineStyle="-", FaceColor="green")
hold on
h2=histogram(Wavespeeds_2D,6, LineWidth=1.5, LineStyle="-", FaceColor="blue")
hold on
h3=histogram(Wavespeeds_3D,6, LineWidth=1.5, LineStyle="-", FaceColor="yellow")

l=legend('1D','2D','3D', 'Interpreter','latex');
legend boxoff;
l.LineWidth=1.5;
l.Location='northwest'
xlabel('Wave speed ($\mu m s^{-1}$)', 'Interpreter','latex')
ylabel('Count','Interpreter','latex')
xlim([0 300])
set(gca,'fontsize',15)
set(gca,'linewidth',1.5)