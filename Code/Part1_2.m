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

VPulse = zeros(8,1);
VSin = zeros(8,1);
VGauss = zeros(8,1);
tstep = 0.001;
time =0;
VinPulse = 0;
deltat = 0.001;
w2 = 2*pi*(1/0.03);
figure(6);
clf;
figure(7);
clf;

for n = 1:1000 %each step represents a milisecond

    if time == 0.03
        VinPulse = 1;
    end
    
   VinSin = sin(w2*time);

   VinGauss = exp(-(time-0.06).^2/(2*(0.03)^2));
    
    FPulse = [0 0 0 0 0 VinPulse 0 0];
    FSin = [0 0 0 0 0 VinSin 0 0];
    FGauss = [0 0 0 0 0 VinGauss 0 0];
    A = G+(Cm/deltat);
    
%     V2 = A\(0*(V2/deltat)+F2.');
    VPulse = A\(Cm*(VPulse/deltat)+FPulse.');
    VSin = A\(Cm*(VSin/deltat)+FSin.');
    VGauss = A\(Cm*(VGauss/deltat)+FGauss.');
       
    time = tstep*n;
    
    VinPulseIn(n,1) = VinPulse;
    VinSinIn(n,1) = VinSin;
    VinGaussIn(n,1) = VinGauss;
    
    VPulseO(n,1) = VPulse(5);
    VSinO(n,1) = VSin(5);
    VGaussO(n,1) = VGauss(5);
    
end

figure(6)
subplot(3,1,1)
title('Blue-input Red-output')
plot(deltat:deltat:time,VinPulseIn,deltat:deltat:time,VPulseO)
subplot(3,1,2)
plot(deltat:deltat:time,VinSinIn,deltat:deltat:time,VSinO)
subplot(3,1,3)
plot(deltat:deltat:time,VinGaussIn,deltat:deltat:time,VGaussO)


figure(7)
XPulse = abs(fft(VinPulseIn));%fft(Vin11,length(Vin11));
XSin = abs(fft(VinSinIn));
XGauss = abs(fft(VinGaussIn));
XPulseOut = abs(fft(VPulseO));
XSinOut = abs(fft(VSinO));
XGaussOut = abs(fft(VGaussO));
subplot(3,1,1)
plot(-(time/2-deltat):deltat:time/2,XPulse,-(time/2-deltat):deltat:time/2,XPulseOut)%plot(1./(deltat:deltat:time),X)
title('fft Blue-input Red-output')
grid on
subplot(3,1,2)
plot(-(time/2-deltat):deltat:time/2,XSin,-(time/2-deltat):deltat:time/2,XSinOut)
grid on
subplot(3,1,3)
plot(-(time/2-deltat):deltat:time/2,XGauss,-(time/2-deltat):deltat:time/2,XGaussOut)
grid on


figure(8)
XshiftPulse = fftshift(XPulse);
XshiftSin = fftshift(XSin);
XshiftGauss = fftshift(XGauss);
XshiftPulseOut = fftshift(XPulseOut);
XshiftSinOut = fftshift(XSinOut);
XshiftGaussOut = fftshift(XGaussOut);
subplot(3,1,1)
grid on
title('fftshift Blue-input Red-output')
plot(-(time/2-deltat):deltat:time/2,XshiftPulse,-(time/2-deltat):deltat:time/2,XshiftPulseOut)
subplot(3,1,2)
grid on
plot(-(time/2-deltat):deltat:time/2,XshiftSin,-(time/2-deltat):deltat:time/2,XshiftSinOut)
subplot(3,1,3)
plot(-(time/2-deltat):deltat:time/2,XshiftGauss,-(time/2-deltat):deltat:time/2,XshiftGaussOut)
grid on


%%%%%%% It should be noted that as the time step increases the smoother the
%%%%%%% fourier transform plot becomes. Which would mean it is more 
%%%%%%% precises.

