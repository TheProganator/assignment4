clear all
close all

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

% V = [V1    V2            V3   V4     V5           i1  iL  i3];
G = [-1/R1  1/R1           0    0       0           1   0   0; 
      1/R1 (-1/R1)-(1/R2)  0    0       0           0  -1   0;
      0      0            -1/R3  0       0           0   1   0;
      0      0            0   -1/R4  1/R4           0   0   1;  
      0      0            0    1/R4 (-1/R4)-(1/Ro)  0  0   0; 
      1      0            0     0       0           0   0   0;
      0      1            -1     0       0           0   0   0; 
      0      0            a/R3  1       0           0   0   0]

% V = [V1 V2 V3 V4 V5 i1 iL i3];
Cm =   [-C  C 0  0  0  0  0  0;
        C -C 0  0  0  0  0  0;
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  0  0;
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  0  0; 
        0  0 0  0  0  0  -L  0; 
        0  0 0  0  0  0  0  0]
    %%%%%%%%%%%%%%%% Remember to output the matrices above %%%%%%%%%%%%%%

 n = 0;
%  VinTest = -10:10; 
for Vin = -10:10 
    n = n + 1;
    F = [0 0 0 0 0 Vin 0 0];
    V = G\F';
    V3(n) = V(3);
    Vo(n) = V(5);
end

vin = -10:1:10;
figure(1)
plot(vin,V3)
title('V3')
figure(2)
plot(vin,Vo)
title('Vo')

% w = linspace(1,1e6);
w = logspace(-3, 5, 100);
for n = 1:100
    F = [0 0 0 0 0 1 0 0];
    V = (G+(1i*w(n)*Cm))\F';
    Voii(n) = V(5);
    Adb(n) = 20*log10(Voii(n));
end

v1 = 1;
figure(3)
%%subplot(4,1,3)
semilogx(w,Voii)
title('Vo func of w')
grid on
figure(4)
semilogx(w,Adb)
title('Gain in dB')
grid on


figure(5)
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
title('Hist of Gain')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2

V2 = zeros(8,1);
tstep = 0.001;
time =0;
Vin1 = 0;
deltat = 0.001;
w2 = 2*pi*(1/0.03);
figure(6);
clf;
figure(7);
clf;

for n = 1:1000 %each step represents a milisecond

    if time == 0.03
        Vin1 = 1;
    end
    
%    Vin1 = sin(w2*time);

%     Vin1 = exp(-(time-0.06).^2/(2*(0.03)^2));
    
    F2 = [0 0 0 0 0 Vin1 0 0];
    A = G+(Cm/deltat);
    
%     V2 = A\(0*(V2/deltat)+F2.');
    V2 = A\(Cm*(V2/deltat)+F2.');
       
    time = tstep*n;
    figure(6);
    hold on
    scatter(time,Vin1,'r')
    title('input voltage')
    figure(7)
    hold on
    scatter(time,V2(5),'b')
    title('output voltage')
    
    Vin11(n,1) = Vin1;
    V2o(n,1) = V2(5);
    
end

figure(8)
Xin = fft(Vin11); %fft(Vin11,length(Vin11));
Xout = fft(V2o);
freq = 1./(deltat:deltat:time);
semilogx(freq,Xin,freq,Xout)
title('fft red-vin blue-vout')
grid on
figure(9)
Xshiftin = fftshift(Xin);
Xshiftout = fftshift(Xout);
semilogx(freq,Xshiftin,freq,Xshiftout)
grid on
title('fftshift red-vin blue-vout')

%%%%%%% It should be noted that as the time step increases the smoother the
%%%%%%% fourier transform plot becomes. Which would mean it is more 
%%%%%%% precises.

