clear all
clc
close all
warning off
global y_inter i1 j1;

%%%%%%%Energy production%%%%%%%%%%%%%%%%
contexto(1).demanda = [0 0;6 0;6 1;3 1;3 2;0 2];
%%%%%%%%%%Energy demands%%%%%%%%%%%%%%%%%
contexto(1).carga = [0 0;3 0;3 1;0 1];
contexto(2).carga = [0 0;3 0;3 1;0 1];
contexto(3).carga = [0 0;3 0;3 1;0 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_min=[0 0 0 0 0 0];
x_max=[3 3 3 3 3 3];
num_poblacion=100;
num_poly=length(contexto);
%%
tic
f = @(x)optimize_demanda(x,contexto,num_poly);
opts = optimoptions('ga','MaxTime',1000,'FunctionTolerance',0.01,'Display','iter');
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


%%
figure
subplot(3,1,1)
plot(poligonos(1).carga,'FaceColor','[0 1 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(2).carga,'FaceColor','[1 0 0]','FaceAlpha',0.5,'LineWidth',1.5)
hold on
plot(poligonos(3).carga,'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
legend('Demand 1','Demand 2','Demand 3')
xlabel('Time (h)') 
ylabel('Power (kW)')
title('DISPLACED ENERGY DEMANDS')
grid on
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 1.5;
xlim([0 7]);
ylim([0 3]);

subplot(3,1,2)
plot(polyshape(contexto(1).demanda),'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('TOTAL ENERGY PRODUCTION')
grid on
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 1.5;
xlim([0 7]);
ylim([0 3]);

subplot(3,1,3)
plot(union(exceso1,exceso2),'FaceColor','[0.5 0 0.8]','FaceAlpha',0.5,'LineWidth',1.5);
xlabel('Time (h)') 
ylabel('Power (kW)')
title('EXCESS ENERGY')
grid on
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 1.5;
xlim([0 7]);
ylim([0 3]);
%%
figure
plot(polyshape(contexto(1).demanda),'FaceColor','[0 0 1]','FaceAlpha',0.5,'LineWidth',1.5)
xlabel('Time (h)') 
ylabel('Power (kW)')
title('TOTAL ENERGY PRODUCTION')
grid on
ax = gca;
ax.FontSize = 20;
ax.LineWidth = 1.5;
xlim([0 7]);
ylim([0 4]);
