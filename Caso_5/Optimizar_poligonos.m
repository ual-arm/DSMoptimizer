clear all
clc
close all
warning off

global y_inter i1 j1;

%%%%%%%Energy production%%%%%%%%%%%%%%%%
contexto(1).demanda = [0 0;24 0;24 3;17 3;14 4;13 5;11 5;10 4;7 3;0 3]; %ok
%%%%%%%%%%Energy demands%%%%%%%%%%%%%%%%%
contexto(1).carga= [0 0;4 0;4 1;3 2;1 2;0 1];
contexto(2).carga= [0 0;3 0;3 1;];
contexto(3).carga= [0 0;3 0;0 1];
contexto(4).carga= [0 0;24 0;24 1;0 1];
contexto(5).carga= [0 0;12 0;12 2;0 2];
contexto(6).carga= [0 0;12 0;12 2;0 2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_min=[0  0  0  0  0  0 0 0 0  0  0  0 ];
x_max=[11 4  8  4  15 4 1 4 13 4  13 4 ];
tic
f = @(x)optimize_demanda(x,contexto);
opts = optimoptions('ga','MaxTime',10000000000000000,'FunctionTolerance',0.005,'Display','iter');
opts.PopulationSize = 800;
NumParamsAOptimizar=12; %Parametros para optimizar en este caso solo hay f
[x,excedente_potencia]=ga(f,NumParamsAOptimizar,[],[],[],[],x_min,x_max,[],opts);
tiempo=toc;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

carga_total=polyshape([0 0]);
for i=1:6
    carga_total=union(carga_total,translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]));
    poligonos(i).carga=translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]);
end

exceso1=subtract(carga_total,polyshape(contexto(1).demanda));
exceso2=subtract(polyshape(contexto(1).demanda),carga_total);


figure
subplot(3,1,1);
% plot([poligonos(1).carga poligonos(2).carga poligonos(3).carga translate(pol_inter,[0 y_inter])])
% hold on
plot(poligonos(1).carga,'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(2).carga,'FaceColor','[1 0 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(3).carga,'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(4).carga,'FaceColor','[1 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(5).carga,'FaceColor','[0.4940 0.1840 0.5560]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(6).carga,'FaceColor','[0.8500 0.3250 0.0980]','FaceAlpha',0.5,'LineWidth',1.5)
grid on
legend('Demand 1','Demand 2','Demand 3','Demand 4','Demand 5','Demand 6')
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DISPLACED ENERGY DEMANDS')
grid on
ax = gca;
ax.FontSize = 15;
xlim([0 24]);
ylim([0 7]);


subplot(3,1,2);

plot(polyshape(contexto(1).demanda),'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Hora (h)') 
ylabel('Potencia (kW)')
title('TOTAL ENERGY PRODUCTION')
ax = gca;
ax.FontSize = 15;
xlim([0 24]);
ylim([0 7]);
grid on

subplot(3,1,3);
plot(union(exceso1,exceso2),'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5);
xlabel('Time (h)') 
ylabel('Power (kW)')
title('EXCESS ENERGY')
grid on
xlim([0 5]);
ylim([0 7]);
ax = gca;
ax.FontSize = 15;
%%
figure
subplot(3,2,1);
plot(polyshape(contexto(1).carga),'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DEMAND 1')
grid on
xlim([0 5]);
ylim([0 3]);
ax = gca;
ax.FontSize = 20;

subplot(3,2,2);
plot(polyshape(contexto(2).carga),'FaceColor','[1 0 0]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DEMAND 2')
grid on
xlim([0 5]);
ylim([0 3]);
ax = gca;
ax.FontSize = 20;

subplot(3,2,3);
plot(polyshape(contexto(3).carga),'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DEMAND 3')
grid on
xlim([0 5]);
ylim([0 3]);
ax = gca;
ax.FontSize = 20;

subplot(3,2,4);
plot(polyshape(contexto(4).carga),'FaceColor','[1 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DEMAND 4')
grid on
xlim([0 24]);
ylim([0 3]);
ax = gca;
ax.FontSize = 20;

subplot(3,2,5);
plot(polyshape(contexto(5).carga),'FaceColor','[0.4940 0.1840 0.5560]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DEMAND 5')
grid on
xlim([0 15]);
ylim([0 3]);
ax = gca;
ax.FontSize = 20;

subplot(3,2,6);
plot(polyshape(contexto(6).carga),'FaceColor','[0.8500 0.3250 0.0980]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DEMAND 6')
grid on
xlim([0 15]);
ylim([0 3]);

ax = gca;
ax.FontSize = 20;
%%

figure
plot(polyshape(contexto(1).demanda),'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Hora (h)') 
ylabel('Powe (kW)')
title('TOTAL ENERGY PRODUCTION')
ax = gca;
ax.FontSize = 20;
xlim([0 24]);
ylim([0 6]);
grid on