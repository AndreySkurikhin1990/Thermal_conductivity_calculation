function oipim = opredIpImN()
format long g;
te0=273.15;
t3=arrTem3VVF1(); t3=te0+t3;
t1=arrTem1VVF1(); t1=te0+t1;
t2=arrTem2VVF1(); t2=te0+t2;
ktp=arrKTP_VVF1(); ts=(t1+t2)/2;
cpm=arrUdTepl_VVF1();
no=3
ktp1=ktp(no)
mko=0;
mko=masKoefXY(ts,ktp);
aktp=mko(1);
bktp=mko(2);
mko=0;
mko=masKoefXY(ts,cpm);
acp=mko(1);
bcp=mko(2);
Tk=t2(no)
T0=t1(no)
Tsr=ts(no)
Tsred=t3(no)
tol=30e-3
qv=ktp1*(T0-Tk)/tol
npp=Kramers_n();
dl=RasshDiapDlinVoln();
p=length(dl);
Nt=3e1
alfs=RasMasKoAbs();
s=1e0; dko=0.444905; dko2=65e-2; dko3=1.3; s=s*dko*dko2*dko3;
alfs=s*alfs;
hksi=tol/Nt; 
ksi=0:hksi:tol; 
Nt=length(ksi);
for k=1:p
    dv(k)=dl(k)/npp(k);
end
temp=0;
mko=0;
mko=koefOprTemp(T0,Tk,Tsred);
at=mko(1);
bt=mko(2);
ct=mko(3);
for k=1:Nt
    temp(k)=at*(ksi(k)^2)+bt*ksi(k)+ct;
end
temp=temp'
koal=ZapisFileOptio(temp);
koal=rasKoefAlpha(temp,npp);
koal=koal';
PP=6.6260755e-34;
PB=1.380658e-23;
c0=299792458;
C1=2*pi*PP*(c0^2);
C2=PP*c0/PB;
%1----------
taut=0; I1g=0; I2g=0;
for j=1:Nt
    ksi1=0; 
    I11g=0;
for k=1:j
    eb1=0; it1=0;
    tem=temp(k);
    for m=1:p
        c1t=C1/(npp(m)^2);
        c2t=C2/npp(m);
lam=dv(m);
me=exp(c2t/lam/tem)-1;
altek=alfs(m)*koal(k);
altej=alfs(m)*koal(j);
eb1(m)=altek*c1t/(lam^5)/me;
it1(m)=eb1(m)*ProvAd(integroexpon(2,altej*ksi(j)-altek*ksi(k)));
    end
    ksi1(k)=ksi(k);
    I11g(k)=integ2ma(dv,it1);
end
I1g(j)=2*pi*integ2ma(ksi1,I11g);
%2----------
    ksi2=0; I22g=0; q=1;
for k=j:Nt
    eb2=0; 
    it2=0;
    tem=temp(k);
    for m=1:p
        c1t=C1/(npp(m)^2);
        c2t=C2/npp(m);
lam=dv(m);
me=exp(c2t/lam/tem)-1;
altek=alfs(m)*koal(k);
altej=alfs(m)*koal(j);
eb2(m)=altek*c1t/(lam^5)/me;
taut=altek*ksi(k)-altej*ksi(j);
it2(m)=eb2(m)*ProvAd(integroexpon(2,taut));
    end
    ksi2(q)=ksi(k);
    I22g(q)=integ2ma(dv,it2);
    q=q+1;
end
I2g(j)=-2*pi*integ2ma(ksi2,I22g);
end
%3----------
I3g=0;
for k=1:Nt
    eb3=0; 
    it3=0;
    tem=temp(k);
    for m=1:p
        c1t=C1/(npp(m)^2);
        c2t=C2/npp(m);
lam=dv(m);
me=exp(c2t/lam/tem)-1;
alte=alfs(m)*koal(k);
eb3(m)=alte*c1t/(lam^5)/me;
taut=alte*ksi(k);
it3(m)=eb3(m)*ProvAd(integroexpon(2,taut));
    end
    I3g(k)=2*pi*integ2ma(dv,it3);
end
I3gg=integ2ma(ksi,I3g);
%4-----------
I41gm=0;
I42gm=0;
I4gm=0; 
for k=1:Nt
    it4=0;
    tem=temp(k);
    for m=1:p
        alte=alfs(m)*koal(k);
        it4(m)=ProvAd(integroexpon(3,alte*ksi(k)));
    end
    I41gm(k)=2*pi*integ2ma(dv,it4);
    I42gm(k)=-pi;
    I4gm(k)=I41gm(k)+I42gm(k);
end
%5-----------
I51gp=0; I52gp=0; I5gp=0;
for k=1:Nt
    it51=0; it52=0; 
    tau0=0; taut=0;
    tem=temp(k);
    for m=1:p
        alte=alfs(m)*koal(Nt);
        tau0=alte*tol;
        it52(m)=ProvAd(integroexpon(3,tau0));
        alte=alfs(m)*koal(k);
        taut=alte*ksi(k);
        it51(m)=ProvAd(integroexpon(3,tau0-taut));
    end
    I51gp(k)=-2*pi*integ2ma(dv,it51);
    I52gp(k)=2*pi*integ2ma(dv,it52);
    I5gp(k)=I51gp(k)+I52gp(k);
end
%6-----------
I1q=0; 
for k=1:Nt
    eb6=0; 
    it6=0;
    tem=temp(k);
    for m=1:p
        c1t=C1/(npp(m)^2);
        c2t=C2/npp(m);
lam=dv(m);
me=exp(c2t/lam/tem)-1;
eb6(m)=c1t/(lam^5)/me;
alte=alfs(m)*koal(k);
it6(m)=eb6(m)*alte;
    end
    I1q(k)=4*pi*integ2ma(dv,it6);
end
%7---dq/dt-----
I1dq=0; 
for k=1:Nt
    eb7=0; 
    it7=0;
    tem=temp(k);
    for m=1:p
        c1t=C1/(npp(m)^2);
        c2t=C2/npp(m);
lam=dv(m);
me=exp(c2t/lam/tem)-1;
eb7(m)=c1t/(lam^5)/me;
alte=alfs(m)*koal(k);
it7(m)=eb7(m)*alte;
    end
    I1dq(k)=4*pi*integ2ma(dv,it7);
end
%8---dq/dt-----
I41gmdq=0;
for k=1:Nt
    it8=0;
    for m=1:p
        alte=alfs(m)*koal(k);
taut=alte*ksi(k);
it8(m)=ProvAd(integroexpon(2,taut));
    end
    I41gmdq(k)=-2*pi*integ2ma(dv,it8);
end
%9---dq/dt-----
I51gpdq=0;
for k=1:Nt
    it9=0;
    for m=1:p
        alte=alfs(m)*koal(Nt);
        tau0=alte*tol;
        alte=alfs(m)*koal(k);
taut=alte*ksi(k);
it9(m)=ProvAd(integroexpon(2,tau0-taut));
    end
    I51gpdq(k)=-2*pi*integ2ma(dv,it8);
end
%10---dq/dt-----
ep=1e-5;
I12gdq=0;
for j=1:Nt
    I12ggdq=0;
    for k=1:Nt
    eb10=0; 
    it10=0;
    tem=temp(k);
    for m=1:p
        c1t=C1/(npp(m)^2);
        c2t=C2/npp(m);
lam=dv(m);
me=exp(c2t/lam/tem)-1;
altek=alfs(m)*koal(k);
altej=alfs(m)*koal(j);
eb10(m)=altek*c1t/(lam^5)/me;
tauj=altej*ksi(j);
tauk=altek*ksi(k);
tauj=abs(tauj-tauk);
it10(m)=eb10(m)*ProvAd(integroexpon(1,tauj));
    end
    I12ggdq(k)=integ2ma(dv,it10);
end
I12gdq(j)=-2*pi*integ2ma(ksi,I12ggdq);
end
I12gdq=I12gdq'
%Total-----------
Ipl=0; Imi=0; Ite=0;
    Ite=oprIpIm1(I41gm, I1g, I2g, I51gp, round(Nt/2), Nt);
    Ipl=Ite(1)
    Imi=Ite(2)
    Ite=oprIpImN2(I41gm, I1g, I2g, I51gp, round(Nt/2), Nt);
    Ipl=Ite(1)
    Imi=Ite(2)
    qr=0; qr0=-(I3gg+I52gp(q)*Imi+I42gm(q)*Ipl);qrr=0;
for k=1:Nt
    qr(k)=I1q(k)-(I1g(k)+I2g(k)+I41gm(k)*Ipl+I51gp(k)*Imi);
    qrr(k)=I1q(k)-qr(k);
end
qr=qr'
qrr=qrr'
qr0=qr0'
I4gm=I4gm'
I5gp=I5gp'
I41gm=I41gm'
I52gp=I52gp'
I1g=I1g'
I2g=I2g'
I3gg=I3gg'
I1q=I1q'
n=nsreddvVer((T0+Tk)/2)
Tz=T0;
disp((5.67e-8)*(n^2)*(Tz^4));
Tz=ZapisFile(qrr);
pl=plot(1e3*ksi(ceil(Nt/10):floor(Nt-Nt/10)),qrr(ceil(Nt/10):floor(Nt-Nt/10)),'-b');
set(pl,'LineWidth',2); 
hold on; grid on; 
xlabel({'���������� x, ��'}); 
ylabel({'��������� ��������� ������, ��/�2'}); 
title({'������ ����������� ��� �� x'});
oipim=0;
end

function t = ZapisFileOptio(massi)
fid = fopen('Temperature.txt','w');
p=length(massi);
for k=1:p
    fprintf(fid,'%0.20f\n',massi(k));
end
fclose(fid);
t=0;
end

function t = ZapisFile(massi)
fid = fopen('Plotnost_luchistogo_potoka.txt','w');
p=length(massi);
for k=1:p
    fprintf(fid,'%0.20f\n',massi(k));
end
fclose(fid);
t=0;
end

function [ ma ] = masKoefXY(masx,masy)
N=length(masx);
xiyi=0;
xi=0;
yi=0;
xi2=0;
for k=1:N
    xiyi=xiyi+masy(k)*masx(k);
    xi=xi+masx(k);
    yi=yi+masy(k);
    xi2=xi2+masx(k)^2;
end
a=(N*xiyi-xi*yi)/(N*xi2-xi^2);
b=(yi-a*xi)/N;
ma = [a b]';
end

function mk = ProvAd(m)
ep=1e-40;
if (isnan(m))   
    m=0; 
end; 
if (isinf(m))  
    m=0;  
end; 
if (abs(m)<ep)  
    m=0;  
end; 
mk=real(abs(m));
end

function inte = integ2ma(ar1,ar2)
p=length(ar1);
su=0;
for k=2:p
    su=su+(ar2(k)+ar2(k-1))*(ar1(k)-ar1(k-1))/2;
end
inte=su;
end

function [ mas ] = oprIpIm1(I41gm, I1g, I2g, I51gp, k, Nt)
a11=I41gm(1)-I41gm(k);
a12=I51gp(1)-I51gp(k);
b1=I1g(k)-I1g(1)+I2g(k)-I2g(1);
a21=I41gm(1)-I41gm(Nt);
a22=I51gp(1)-I51gp(Nt);
b2=I1g(Nt)-I1g(1)+I2g(Nt)-I2g(1);
m=[a11, a12; a21, a22]; b=[b1, b2];
mas=inv(m)*b';
end

function [ mas ] = oprIpImN2(I41gm, I1g, I2g, I51gp, k, Nt)
a11=I41gm(1)-I41gm(k);
a12=I51gp(1)-I51gp(k);
b1=I1g(k)-I1g(1)+I2g(k)-I2g(1);
a21=I41gm(Nt)-I41gm(k);
a22=I51gp(Nt)-I51gp(k);
b2=I1g(k)-I1g(Nt)+I2g(k)-I2g(Nt);
m=[a11, a12; a21, a22]; b=[b1, b2];
mas=inv(m)*b';
end

function [ ko ] = rasKoefAlpha(te,pp)
tem=3e2:1e2:16e2;
mgo=opredStepCherVesch(1,tem);
al2o3=opredStepCherVesch(2,tem);
sio2=opredStepCherVesch(3,tem);
wmg=21.7; wsi=36.8; wal=13.2; wo=(wmg+wsi+wal);
kumm=vychKoe(tem,te,mgo);
kuma=vychKoe(tem,te,al2o3);
kums=vychKoe(tem,te,sio2);
for k=1:length(pp)
    ep(k)=epsilam(pp(k));
end
n=length(te);
for k=1:n
    koo(k)=kumm(k)*wmg/wo+kuma(k)*wal/wo+kums(k)*wsi/wo;
end
ko=koo;
end

%������������ ���������� ������������ ������� ������� ��� SiO2, Al2O3
function [ t ] = opredStepCherVesch(nom,te)
n=length(te);
scma=[1,0.940,0.870,0.801,0.736,0.676,0.635,0.590,0.567,0.543,0.530,0.525,0.515,0.507]; %������� ������� ���������
mdma=[0.98,0.02]; %MgO - ��������
%-------
scsh=[1,0.976,0.949,0.905,0.859,0.812,0.774,0.737,0.709,0.681,0.661,0.639,0.626,0.620]; %������� ������� ������
scksh=[1,0.980,0.951,0.920,0.883,0.853,0.821,0.790,0.767,0.746,0.730,0.715,0.705,0.692]; %������� ������� �������������
scktik=[1,0.983,0.936,0.867,0.819,0.721,0.659,0.593,0.541,0.490,0.453,0.429,0.403,0.384]; %������� ������� ����������� ������������������ �������
scmu=[1,0.984,0.941,0.882,0.813,0.751,0.695,0.641,0.594,0.558,0.530,0.499,0.479,0.462]; %������� ������� �������
sckr=[1,0.984,0.953,0.917,0.854,0.808,0.756,0.711,0.578,0.523,0.495,0.468,0.448,0.429]; %������� ������� ����������
%-------
mdsh=[0.56,0.396]; mdsh=[mdsh(1)/(mdsh(1)+mdsh(2)),mdsh(2)/(mdsh(1)+mdsh(2))]; mdsh=mdsh'; %SiO2, Al2O3 - �����
mdksh=[0.28,0.70]; mdksh=[mdksh(1)/(mdksh(1)+mdksh(2)),mdksh(2)/(mdksh(1)+mdksh(2))]; mdksh=mdksh'; %SiO2, Al2O3 - ������������
mdktik=[0.57,0.4]; mdktik=[mdktik(1)/(mdktik(1)+mdktik(2)),mdktik(2)/(mdktik(1)+mdktik(2))]; mdktik=mdktik'; %SiO2, Al2O3 - ����. �/� ������
mdmu=[0.28,0.72]; %SiO2, Al2O3 - ������
mdkr=[0.985,0.01]; mdkr=[mdkr(1)/(mdkr(1)+mdkr(2)),mdkr(2)/(mdkr(1)+mdkr(2))]; mdkr=mdkr'; %SiO2, Al2O3 - ���������
for j=1:n
kor=0; k=1;
kor=RasKor(mdsh(1),mdsh(2),mdksh(1),mdksh(2),scsh(j),scksh(j),kor,k); k=k+1;
kor=RasKor(mdsh(1),mdsh(2),mdktik(1),mdktik(2),scsh(j),scktik(j),kor,k); k=k+1;
kor=RasKor(mdsh(1),mdsh(2),mdmu(1),mdmu(2),scsh(j),scmu(j),kor,k); k=k+1;
kor=RasKor(mdksh(1),mdksh(2),mdktik(1),mdktik(2),scksh(j),scktik(j),kor,k); k=k+1;
kor=RasKor(mdksh(1),mdksh(2),mdmu(1),mdmu(2),scksh(j),scmu(j),kor,k); k=k+1;
kor=RasKor(mdktik(1),mdktik(2),mdmu(1),mdmu(2),scktik(j),scmu(j),kor,k); k=k+1;
kor=RasKor(mdsh(1),mdsh(2),mdkr(1),mdkr(2),scsh(j),sckr(j),kor,k); k=k+1;
kor=RasKor(mdksh(1),mdksh(2),mdkr(1),mdkr(2),scksh(j),sckr(j),kor,k); k=k+1;
kor=RasKor(mdktik(1),mdktik(2),mdkr(1),mdkr(2),scktik(j),sckr(j),kor,k); k=k+1;
kor=RasKor(mdmu(1),mdmu(2),mdkr(1),mdkr(2),scmu(j),sckr(j),kor,k); k=k+1;
usr=UsredMas(kor,k);
msio(j)=usr(1);
malo(j)=usr(2);
end
msio=msio';
malo=malo';
for k=1:length(scma)
    scma(k)=(scma(k)-msio(k)*mdma(2))/mdma(1);
end
scma=scma';
if (nom==1) 
    t=scma;
end
    if (nom==2) 
        t=malo;
    end
        if (nom==3) 
            t=msio;
        end
end

function [ ko ] = RasKor(a11,a12,a21,a22, b1,b2,kor,k)
mas(1,1)=a11; mas(1,2)=a12; 
mas(2,1)=a21; mas(2,2)=a22; 
b(1)=b1; b(2)=b2; 
x=inv(mas)*b';
if ((x(1)>=0) && (x(2)>=0) && (x(1)<=1) && (x(2)<=1))
    kor(k,1)=x(1); kor(k,2)=x(2);
else
    kor(k,1)=0; kor(k,2)=0;
end
ko=kor;
end

function [ usr ] = UsredMas(kor,k)
s1=0; s2=0; q=0;
for j=1:k-1
    if ((kor(j,1)>0) && (kor(j,2)>0))
        s1=s1+kor(j,1); 
        s2=s2+kor(j,2); 
        q=q+1;
    end
end
s1=s1/q;
s2=s2/q;
usr=[s1,s2];
end

function epsi = epsilam(n)
eps=(4*n+2)/3/((n+1)^2);
eps=eps+2*(n^3)*(n^2+2*n-1)/(n^2+1)/(n^4-1);
eps=eps-8*(n^4)*(n^4+1)*log(abs(n))/(n^2+1)/((n^4-1)^2);
eps=eps-(n^2)*log(abs(n-1)/abs(n+1))*((n^2-1)^2)/((n^2+1)^3);
epsi=eps;
end

function [ koe ] = vychKoe(tem,te,epra)
for q=1:length(te)
    f=1; j=0; n=length(tem);
for k=1:n
    if ((te(q)<=tem(k)) && (f>0))
        j=k;
        f=0;
    end
end
if ((j==0) && (f>0))
    j=n; f=0;
end
if (j==1)
    j=2; f=0;
end
if (f==0) 
    ep(q)=epra(j-1)+(epra(j)-epra(j-1))*(te(q)-tem(j-1))/(tem(j)-tem(j-1));
else
    ep(q)=0;
end
end
koe=ep;
end

function [ koe ] = koefOprTemp(T1,T2,T3)
c=T1;
x1=0; x3=15e-3; x2=30e-3;
x11=x2^2; x12=x2; x21=x3^2; x22=x3;
b1=T2-c; b2=T3-c;
de=x11*x22-x12*x21;
de1=b1*x22-b2*x12;
de2=x11*b2-x21*b1;
koe = [de1/de de2/de c];
end