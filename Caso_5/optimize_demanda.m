function [salida] = optimize_demanda(x,contexto)

carga_total=polyshape([0 0]);
for i=1:6
  carga_total=union(carga_total,translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]));
%   poligonos(i).carga=translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]);
end
%  [y_int,i1,j1] = Preparar_poligono(poligonos,carga_total); 
salida = area(union(subtract(polyshape(contexto(1).demanda),carga_total),...
    subtract(carga_total,polyshape(contexto(1).demanda))));
