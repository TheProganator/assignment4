R1 = 1;
C = 0.25;
R2 = 2;
L = 0.2;
R3 = 10;
a = 100;
R4 = 0.1;
Ro = 1000;
Cn = 0.00001;
Y1 = 1/R1;
Y2 = 1/R2;
Y3 = 1/R3;
Y4 = 1/R4;

% V = [V1    V2            V3   V4     V5           i1  iL  i3];
G = [-1/R1  1/R1           0     0      0            1   0   0;
    1/R1 (-1/R1)-(1/R2)  0     0      0            0  -1   0;
    0      0            -1/R3  0      0            0   1   0;
    0      0            0   -1/R4  1/R4            0   0   1;
    0      0            0    1/R4 (-1/R4)-(1/Ro)   0   0   0;
    1      0            0      0      0            0   0   0;
    0      1            -1     0      0            0   0   0;
    0      0            a/R3   1      0            0   0   0]
%%%% I think I need to make in a variable rather than a constant

% V = [V1  V2  V3   V4  V5 i1  iL i3];
Cm =   [-C  C   0   0   0   0   0  0;
    C  -C   0   0   0   0   0  0;
    0   0  -Cn  0   0   0   0  0;
    0   0   0   0   0   0   0  0;
    0   0   0   0   0   0   0  0;
    0   0   0   0   0   0   0  0;
    0   0   0   0   0   0  -L  0;
    0   0   0   0   0   0   0  0]

%%%%%%%%%%%%%%%% Remember to output the matrices above %%%%%%%%%%%%%%

tstep = 0.001;
time = 0;


for n = 1:300
    
    In = randn*0.01;
    Vin = exp(-(time-0.06).^2/(2*(0.03)^2));
    
    F = [0 0 In 0 0 Vin 0 0];
    V = G\F';
    Vo(n) = V(5);
           
    time = tstep*n;
end

figure(9)
plot(tstep:tstep:time,Vo)

figure(10)
X = abs(fft(Vo));
plot(-(time/2-tstep):tstep:time/2,X)
title('fft')