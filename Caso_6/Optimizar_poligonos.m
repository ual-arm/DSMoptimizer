clear all
clc
close all
warning off
global y_inter i1 j1;
load 'caso_real_1.mat'
%%%%%%%Energy production%%%%%%%%%%%%%
contexto(1).demanda = Pg;
%%%%%%%%%%Energy demands%%%%%%%%%%%%%%%%%
contexto(1).carga=Pd1;
contexto(2).carga=Pd2;
contexto(3).carga=Pd3;
contexto(4).carga=Pd4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_min=[0  0  0  0  0  0 0 0];
x_max=[10 3  16 3  8  3 10 3];
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
%%
figure
subplot(2,1,1);
plot(polyshape(contexto(1).demanda),'FaceColor','[1 1 1]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(1).carga,'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(2).carga,'FaceColor','[1 0 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(3).carga,'FaceColor','[0 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(4).carga,'FaceColor','[1 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
grid on
legend('Production','Demand 1','Demand 2','Demand 3','Demand 4')
xlabel('Time (h)')
ylabel('Power (kW)')
title('ENERGY DEMAND PROFILES')
grid on
ax = gca;
ax.FontSize = 20;
xlim([0 24]);
ylim([0 3]);


subplot(2,1,2);
t=plot(exceso1,'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5);
t.LineStyle = '--';
xlim([0 24]);
ylim([0 3]);
hold on
plot(exceso2,'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5);
xlabel('Time (h)')
ylabel('Power (kW)')
title('EXCESS ENERGY')
grid on
xlim([0 24]);
ylim([0 3]);
ax = gca;
ax.FontSize = 20;

%Demanda de energia total
figure
subplot(2,1,1)

h=plot(polyshape(contexto(1).demanda),'FaceColor','[1 1 1]','FaceAlpha',0.5,'LineWidth',1.5)
h.LineStyle = '--';
h.LineWidth=1.5
hold on
plot(polyshape(Produccion),'FaceColor','[0.5 1 0.1]','FaceAlpha',0.5,'LineWidth',1.5)
legend('Production','Demand')
xlim([0 24]);
ylim([0 3]);
xlabel('Time (h)')
ylabel('Power (kW)')
title('INITIAL CONDITIONS')
grid on
ax = gca;
ax.FontSize = 20;
subplot(2,1,2)
plot(translate(polyshape(contexto(1).carga),[0 0]),'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(translate(polyshape(contexto(2).carga),[6 0]),'FaceColor','[1 0 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(translate(polyshape(contexto(3).carga),[11 0]),'FaceColor','[0 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(translate(polyshape(contexto(4).carga),[18 0]),'FaceColor','[1 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
grid on
legend('Demand 1','Demand 2','Demand 3','Demand 4')
xlim([0 24]);
ylim([0 3]);
xlabel('Time (h)')
ylabel('Power (kW)')
title('ENERGY DEMAND')
ax = gca;
ax.FontSize = 20;
