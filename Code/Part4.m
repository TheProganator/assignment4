% %%%%%%% Part 4
% % 
% % A) If the output voltage was changed to a non-linear representation for 
% the current it would have to be represented in the B matrix of the MNA
% form 
% 
% B) the B matrix would have to be inlcuded when making the caculation.
% instead of using the the a/R3 and denoting there is a votage at that
% point in the matrix (denoted by the 1 in the fourth column in the last
% row in the G matrix). Just a 1 is denoted so as to allow the B matrix use
% it. Now since we know that the total curent is equal to a*V3/R3 we use
% that in the B matrix. Then we use a jacobian to find the non-linear
% solution. begin by defining an operating point.
%

%C)
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

% V = [V1    V2            V3     V4     V5            i1  iL  i3];
G = [-1/R1  1/R1           0       0      0             1   0   0;
    1/R1 (-1/R1)-(1/R2)    0       0      0             0  -1   0;
      0      0            -1/R3    0      0             0   1   0;
      0      0             0   -1/R4    1/R4            0   0   1;
      0      0             0    1/R4  (-1/R4)-(1/Ro)    0   0   0;
      1      0             0       0      0             0   0   0;
      0      1            -1       0      0             0   0   0;
      0      0             0       1      0             0   0   0]


% V =  [V1  V2  V3   V4  V5 i1  iL i3];
Cm =   [-C   C   0   0   0   0   0  0;
         C  -C   0   0   0   0   0  0;
         0   0   0   0   0   0   0  0;
         0   0   0   0   0   0   0  0;
         0   0   0   0   0   0   0  0;
         0   0   0   0   0   0   0  0;
         0   0   0   0   0   0  -L  0;
         0   0   0   0   0   0   0  0]
 
 
 %B = [0 0 0 0 a*(V3/R3) 0 0 0]
 
  n = 0;
  vin = -10:1:10;  
  V3 = zeros(size(vin));
  
for Vin = -10:10 
    n = n + 1;
    F = [0 0 0 0 0 Vin 0 0];
    B = [0 0 0 0 a*(V3(n)/R3) 0 0 0];
    V = ((G+Cm)\F')+B;
    
    
    V3(n) = V(3);
    Vo(n) = V(5);
end

figure(14)
plot(vin,V3)
title('V3')
figure(15)
plot(vin,Vo)
title('Vo')
