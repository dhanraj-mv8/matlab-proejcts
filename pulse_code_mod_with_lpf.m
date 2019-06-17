clc;
clear all;
close all;
fc=10;
fs=1000;
n=input('Enter bit depth');
L=2^n;
A=input('Enter amplitude');
t=1/fs:1/fs:1;
m1=A/2*sin(2*pi*fc/2*t);
m2=A/2*cos(2*pi*fc*t);
m3=m1+m2;
figure;
subplot(2,1,1);
plot(t,m1);title('Signal 1');xlabel('Time');ylabel('Amplitude');
subplot(2,1,2);
plot(t,m2);title('Signal 2');xlabel('Time');ylabel('Amplitude');
figure;
subplot(3,1,1);
plot(t,m3);title('Message Signal');xlabel('Time');ylabel('Amplitude');
m4=(square(2*pi*10*fc*t)+1)/2;
m=m3.*m4;
subplot(3,1,2);
plot(t,m4);title('Square Signal');xlabel('Time');ylabel('Amplitude');
subplot(3,1,3);
plot(t,m);title('Sampled Signal');xlabel('Time');ylabel('Amplitude');
v1=A;
v2=-A;
d=(v1-v2)/L;
for k=1:L+1
    v(k)=(k-1)*d;
end
m=m+A;
for i=1:1:fs
    e=0;
    for k=1:1:L
        if ((m(i)<v(k))&&e==0)
            q(i)=v(k-1);
            e=1;
        elseif (m(i)>v(L))
            q(i)=v(L);
            e=1;
        end
        
    end
end
m=m-A;
for i=1:length(t)
    ind1(i)=(q(i)-v2)/d;
end
ind=round(ind1);
l1=length(ind);
l2=length(q);
 for i=1:l1
    if(ind(i)~=0)                                          
        ind(i)=ind(i)-1;
    end 
    i=i+1;
 end   
 p=q';
figure;
subplot(2,1,1);
stairs(t,p);
grid on;title('Quantized Signal');ylabel('Amplitude'); xlabel('Time');
c=de2bi(ind,'left-msb');            
b=c';
c1=reshape(b,1,(n+1)*fs);
subplot(2,1,2); grid on;
stairs(c1);title('Encoded Signal');ylabel('Amplitude');xlabel('Time');                                
axis([0 100 -2 3]); 
ind2=bi2de(c,'left-msb');                    
q1=d*ind2+v2; 
q1=q1-A;
figure;
subplot(3,1,1);
plot(m);title('Original Signal');ylabel('Amplitude');xlabel('Time');
subplot(3,1,2); 
plot(q1);title('Demodulated Signal');ylabel('Amplitude');xlabel('Time');
w1=4*fc;
w2=8*fc;
wp=w1/fs/2;
ws=w2/fs/2;
[n1,Wn]=buttord(wp,ws,2,20);
[b,a]=butter(n1,Wn,'low');
y1=filter(b,a,q1);
subplot(3,1,3);
plot(t,y1);title('Low Pass Filter Output');xlabel('Frequecy');ylabel('Amplitude');



