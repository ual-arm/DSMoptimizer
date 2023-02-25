function salida = optimize_demanda(x,contexto,num)

carga_total=polyshape([0 0]);
for i=1:num
  carga_total=union(carga_total,translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]));
  poligonos(i).carga=translate(polyshape(contexto(i).carga),[x(2*i-1) x(2*i)]);
end

[carga_inter] = Preparar_poligono(poligonos,carga_total,num); 
carga_total_intr=union(carga_total,carga_inter);

salida = area(union(subtract(polyshape(contexto(1).demanda),carga_total_intr),...
    subtract(carga_total_intr,polyshape(contexto(1).demanda))));