%�������� � ������������� ���������� �����������, ������������ �� ��������
%�������� � �����������
ko1=SredGraf();
ko2=SredGrafKoAbsVer();
dl=dlivoln();
pl=plot(dl*1e6,ko1,'-b',dl*1e6,ko2,'-k');
set(pl,'LineWidth',2);
hold on; grid on; 
xlabel({'����� �����, ���'}); 
ylabel({'���������� ����������'});
title({'������ ����������� ������������ ���������� �� ����� �����'});
