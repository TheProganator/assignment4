R1 = 1;
C = 0.25;
R2 = 2;
L = 0.2;
R3 = 10;
a = 100;
R4 = 0.1;
Ro = 1000;
Y1 = 1/R1;
Y2 = 1/R2;
Y3 = 1/R3;
Y4 = 1/R4;
timestep = 1e-12;

% V = [V1    V2            V3   V4     V5           i1  iL  i3];
G = [-1/R1  1/R1           0    0       0           1   0   0; 
      1/R1 (-1/R1)-(1/R2)  0    0       0           0  -1   0;
      0      0            1/R3  0       0           1   0   0;
      0      0            0   -1/R4  1/R4           0   0   1;  
      0      0            0    1/R4 (-1/R4)-(1/Ro)  0  -1   0; 
      1      0            0     0       0           0   0   0;
      0      1            1     0       0           0   0   0; 
      0      0            a/R3  1       0           0   0   0];

% V = [V1 V2 V3 V4 V5 i1 iL i3];
Cm =   [-C  C 0  0  0  0  0  0;
        C -C 0  0  0  0  0  0;
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  0  0;
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  L  0; 
        0  0 0  0  0  0  0  0];

 n = 0;
for Vin = -10:10 
    n = n + 1;
    F = [0 0 0 0 0 Vin 0 0];
    V = G\F';
    V3(n) = V(3);
    Vo(n) = V(5);
end

vin = -10:1:10;
figure('Name','V3')
plot(vin,V3)
figure('Name','Vo')
plot(vin,Vo)

w = linspace(1,1e6);
for n = 1:100
    F = [0 0 0 0 0 1 0 0];
    V = (G+(1i*w(n)*Cm))\F';
    Voii(n) = V(5);
    Adb(n) = 20*log10(Voii(n));
end

v1 = 1;
figure('Name','Vo func of w')
%%subplot(4,1,3)
semilogx(w,Voii)
grid on
figure('name','Gain in dB')
semilogx(w,Adb)
grid on


figure('name','Hist of Gain')
Cnd = 0.25 + 0.05*randn(1,100);

for n = 1:100
    F = [0 0 0 0 0 1 0 0];
    Cmnd =   [-Cnd(n)  Cnd(n) 0  0  0  0  0  0;
        Cnd(n) -Cnd(n) 0  0  0  0  0  0;
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  0  0;
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  L  0; 
        0  0 0  0  0  0  0  0];
    V = (G+(pi*Cmnd))\F';
    Voiii(n) = V(5);
end

hist(Voiii)