clc
clear all
close all
%%
dof=3;
% m1=1;m2=1;l1=1;l2=1;g=9.81;
tinit=0;
step_size=.01;
tlimit=10000*step_size; % multiply by number of steps needed (12*step_size;) or directly input the end point
tspan=[0:step_size:tlimit];
y0=10*rand(dof,1);%zeros(dof,1);
yd0=[0;0];
y_int=[y0];
tends=[tinit tlimit];
input=[]; output=[];
for j=1:200  % training trajectories
    y0=rand(3,1);

    y_int=y0;
    [t,y] = ode45(@rossler,tspan,y_int);
    input=[input; y(1:50:end-50,:)];
    output=[output; y(51:50:end,:)];
        plot3(y(:,1),y(:,2),y(:,3)), hold on
    plot3(y0(1),y0(2),y0(3),'ro')
end


%%
net = feedforwardnet([20 20 20],'trainscg');
net.layers{1}.transferFcn = 'logsig';
% net.layers{2}.transferFcn = 'elliotsig';
net.layers{2}.transferFcn = 'radbas';
net.layers{3}.transferFcn = 'purelin';
% net.performParam.normalization = 'standard';
net = train(net,input.',output.');
genFunction(net,'rosseler_ann');
%%
y0=rand(dof,1);
yd0=[0;0];
y_int=[y0];
ynn=y_int;
[t,y] = ode45(@rossler,tspan,y_int);
for jj=2:length(tspan)
    x=rosseler_ann(ynn(:,jj-1));
    ynn(:,jj)=x;
end
figure(2)
plot3(y(:,1),y(:,2),y(:,3)), hold on
% plot3(y0(1),y0(2),y0(3),'ro','Linewidth',[2])
grid on

ynn(:,1)=y0;
for jj=2:length(tspan)
    x=rosseler_ann(ynn(:,jj-1));
    ynn(:,jj)=x;
end
plot3(ynn(1,:),ynn(2,:),ynn(3,:),'r:','Linewidth',[2])

figure(3)
subplot(3,2,1), plot(tspan,y(:,1),tspan,ynn(1,:),'Linewidth',[2])
subplot(3,2,3), plot(tspan,y(:,2),tspan,ynn(2,:),'Linewidth',[2])
subplot(3,2,5), plot(tspan,y(:,3),tspan,ynn(3,:),'Linewidth',[2])


