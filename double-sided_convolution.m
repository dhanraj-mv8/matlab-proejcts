clc;
close all 
clear all 
x=input('enter the sequence x ') 
h=input('Enter h: ') 
m1=input('starting of x');
n1=input('starting of h');
m=length(x); 
n=length(h); 
X=[x,zeros(1,n)]; 
H=[h,zeros(1,m)]; 
for i=1:n+m-1 
Y(i)=0; 
for j=1:m 
if(i-j+1>0) 
Y(i)=Y(i)+X(j)*H(i-j+1); 
else 
end 
end 
end 
Y 
p=n1+m1;
b=p+n+m-1;
c=p:b-1;
subplot(2,1,1);
stem(c,Y); 
ylabel('Y[n]'); 
xlabel('----->n'); 
title('Convolution of Two Signals without conv function');
z=conv(x,h);
subplot(2,1,2);
stem(c,z);