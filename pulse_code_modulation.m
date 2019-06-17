clc;
clear all;
close all;
%fc->carrier frequency can be obtained as an input
%fs ->sampling frequency
fc=10; fs=20*fc;
n=input('Enter Bit Depth');
L=2^n;
A=8;
t=1/fs:1/fs:1;
m=A*sin(2*pi*fc*t);
figure;
subplot(2,1,1);
plot(m);title('Original Signal');xlabel('Time');ylabel('Amplitude');
subplot(2,1,2);
stem(m);title('Sampled Signal');xlabel('Time');ylabel('Amplitude');
%quantization of the amplitude levels
v1=A;
v2=-A;
d=(v1-v2)/L;
m=m+A+1;
for i=1:d:2A+1
    for k=round((i-1)*fs/L)+1:round(i*fs/L)
    if m(k)<=i+d/2
        q(k)=i;
    else
        q(k)=i+d;
    end
    end
    
end
m=m-A-1;
q=m-A-1;
for i=1:length(t)
    ind1(i)=(m(i)-v2)/d;
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
figure;
stem(q);grid on;title('Quantized Signal');ylabel('Amplitude'); xlabel('Time');
figure;
%encoding of the signal to binary waveform
c=de2bi(ind,'left-msb');            
b=c';
c1=reshape(b,1,n*fs);
subplot(2,1,1); grid on;
stairs(c1);title('Encoded Signal');ylabel('Amplitude');xlabel('Time');    
%demodulation of the pcm wave
axis([0 100 -2 3]); 
ind2=bi2de(c,'left-msb');                    
q=d*ind2+v2;                       
subplot(2,1,2); 
plot(q);title('Demodulated Signal');ylabel('Amplitude');xlabel('Time');
