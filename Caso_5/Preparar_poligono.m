function [y_inter,i1,j1,area_salida] = Preparar_poligono(poligonos,carga_total)
global r;
tol_area=0.05;
despl=0.01;
control=0;
y_inter=0;
i1=0;
j1=0;
area_intersect=10000;
k=1;
area_salida(1)=0;
for i=1:(length(poligonos)-1)
    for j=2+control:length(poligonos)
        inter_poli=intersect(poligonos(i).carga,poligonos(j).carga);
        area_salida(k)=area(inter_poli);
        if area_salida(k)>tol_area
            while area_intersect>=tol_area          
                area_intersect=area(intersect(carga_total,translate(inter_poli,[0 y_inter])));
                y_inter=y_inter+despl;
            end
            i1=i;
            j1=j;
        end
            if k<4
            k=k+1;
            end
            
    end
    control=control+1;
%     if k<4
%     k=k+1;
%     end
r=5;
end
        if area_salida(1)<tol_area && area_salida(2)<tol_area && area_salida(3)<tol_area
             i1=1;
             j1=1;
        end
