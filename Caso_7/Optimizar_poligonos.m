clear all
clc
close all
warning off
global y_inter i1 j1;
load 'caso_real_2.mat'
%%%%%%%Energy production%%%%%%%%%%%%%%%%
contexto(1).demanda = Pg; %ok
%%%%%%%%%%Energy demands%%%%%%%%%%%%%%%%%
contexto(1).carga=Pd1;
contexto(2).carga=Pd2;
contexto(3).carga=Pd3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_min=[0  0  0  0  0  0 ];
x_max=[0  3  11 3  16 3 ];
num_poblacion=400;
num_poly=length(contexto);
tic
%%
f = @(x)optimize_demanda(x,contexto,num_poly);
opts = optimoptions('ga','MaxTime',100000000000,'FunctionTolerance',0.005,'Display','iter');
opts.PopulationSize = num_poblacion;
NumParamsAOptimizar=num_poly*2; %Parametros para optimizar en este caso solo hay f
[x,excedente_potencia]=ga(f,NumParamsAOptimizar,[],[],[],[],x_min,x_max,[],opts);
%%%%
tiempo=toc;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

carga_total=polyshape([0 0]);
for i=1:num_poly
    carga_total=union(carga_total,translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]));
    poligonos(i).carga=translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]);
end

pol_inter=intersect(poligonos(i1).carga,poligonos(j1).carga);
carga_total_inter=union(carga_total,translate(pol_inter,[0 y_inter]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exceso1=subtract(carga_total_inter,polyshape(contexto(1).demanda));
exceso2=subtract(polyshape(contexto(1).demanda),carga_total_inter);

Ppv=flip(Pg);

%% Resultados
figure
subplot(2,1,1);
plot(polyshape(contexto(1).demanda),'FaceColor','[1 1 1]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(1).carga,'FaceColor','[0 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(2).carga,'FaceColor','[1 0 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(3).carga,'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
legend('Production','Demand 1','Demand 2','Demand 3')
xlabel('Time (h)')
ylabel('Power (kW)')
title('ENERGY DEMAND PROFILES')
grid on
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 1.5;
xlim([0 24]);
ylim([0 3]);

subplot(2,1,2);
% plot(exceso1,'FaceColor','[1 0.1 0.4]','FaceAlpha',0.5,'LineWidth',1.5);
plot(exceso1,'FaceAlpha',0.5,'LineWidth',1.5);
hold on
plot(exceso2,'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5);
legend('Deficit','Excess')
xlabel('Time (h)')
ylabel('Power (kW)')
title('EXCESS ENERGY')
grid on
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 1.5;
xlim([0 24]);
ylim([0 3]);
%%
%Demanda
figure
subplot(2,1,2)
plot(polyshape(contexto(1).carga),'FaceColor','[0 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(translate(polyshape(contexto(2).carga),[6 0.65*1.17]),'FaceColor','[1 0 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(translate(polyshape(contexto(3).carga),[11 0.65*1.17]),'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
legend('Demand 1','Demand 2','Demand 3')
xlabel('Time (h)')
ylabel('Power (kW)')
title('ENERGY DEMAND')
grid on
bx = gca;
bx.FontSize = 20;
bx.LineWidth = 1.5;
xlim([0 24]);
ylim([0 3]);
subplot(2,1,1)
h=plot(polyshape(contexto(1).demanda),'FaceColor','[1 1 1]','FaceAlpha',0.5,'LineWidth',1.5);
h.LineStyle = '--';
h.LineWidth=1.5;
hold on
plot(polyshape(Produccion),'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5)
legend('Production','Demand')
xlabel('Time (h)')
ylabel('Power (kW)')
title('INITIAL CONDITIONS')
grid on
bx = gca;
bx.FontSize = 20;
bx.LineWidth = 1.5;
xlim([0 24]);
ylim([0 3]);

