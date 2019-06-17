clc;clearvars;close all;
%no of bits
x=input('enter x');w=10*x;t=1/w:1/w:1; fc=x;
%range of bits to be displayed...can be changed for convenient no of bits
w1=input('Enter 0 to 99');
a=round(rand(1,x));rand('state',0);m=1;
w2=((w1*x/10)+1):(w1+1)*x/10;
b=(2*a)-1;
b1=b;
%differential encoding
if (b(1)==-1)
        b(1)=-m;
    else
        b(1)=m;
end
for i=2:1:x
     if (b(i-1)==1&&b(i)==1)
         b(i)=1;
     elseif (b(i-1)==-1&&b(i)==1)
         b(i)=-1;
     elseif (b(i-1)==-1&&b(i)==-1)
         b(i)=1;
     elseif (b(i-1)==1&&b(i)==-1)
         b(i)=-1;
     end
end
c=repmat(b,1,10);
d=reshape(c,x,10);                                        
e=d';                                                                                                         
f=e(:)';
c1=repmat(b1,1,10);
d1=reshape(c1,x,10);                                        
e1=d1';                                                                                                         
f1=e1(:)';
g=sin(2*pi*fc*t);
h=f.*g;
figure(1);
subplot(4,1,1); plot(t(w2),f1(w2)); grid on;
xlabel('Time'); ylabel('Amplitude'); title('Binary Stream');1
subplot(4,1,2); plot(t(w2),f(w2)); grid on;
xlabel('Time'); ylabel('Amplitude'); title('Encoded Binary Stream');
subplot(4,1,3); plot(t(w2),g(w2)); grid on;
xlabel('Time'); ylabel('Amplitude'); title('Carrier Wave');
subplot(4,1,4); plot(t(w2),h(w2)); grid on; xlabel('Time'); ylabel('Amplitude'); title('DPSK Wave');
k=1;
%clear b;clear b1;clear c;clear c1;clear d;clear d1;clear f;
%introduction of awgn noise of different decibel values
for i=-20:10:10
    n(k,:)=awgn(h,i,'measured');
    k=k+1;
end
figure(2);
subplot(5,1,1); plot(t(w2),h(w2)); grid on; title('Original Signal');
str={'Signal with SNR @-20dB' 'Signal with SNR @-10dB' 'Signal with SNR @0dB' 'Signal with SNR @10dB'};
xlabel('Time'); ylabel('Amplitude');
for i=1:4
    subplot(5,1,i+1); plot(t(w2),n(i,(w2))); grid on;
    title(str(i));
    xlabel('Time'); ylabel('Amplitude');
end
figure(3);
tb=1/w:1/w:1/x;
%pilot carrier of unit/bit duration
sc=sin(2*pi*fc*(tb));
%correlation of the signal
for i=1:10:length(t)
    co(i:i+9)=sc.*h(i:i+9);
    sc=h(i:i+9);
end
subplot(5,1,1);plot(t(w2),co(w2));
grid on;hold on;title('Correlated wave');xlabel('time');
ylabel('amplitude');
str={'Correlated Signal with SNR @-20dB' 'Correlated Signal with SNR @-10dB' 'Correlated Signal with SNR @0dB' 'Correlated Signal with SNR @10dB'};
%integration of correlated signal
for i=1:4
    sc=sin(2*pi*fc*tb);
    for j=1:10:length(t);
        r(i,j:j+9)=sc.*n(i,j:j+9);
        sc=n(i,j:j+9);
    end
    subplot(5,1,i+1);plot(t(w2),r(i,(w2)));title(str(i));xlabel('time');ylabel('amplitude');grid on;hold on;
end
str={'Signal Integrated over bit duration for SNR @-20dB' 'Signal Integrated over bit duration for SNR @-10dB' 'Signal Integrated over bit duration for SNR @0dB' 'Signal Integrated over bit duration for SNR @10dB'};
y_1=zeros(1,length(t)); k=1;
x_1=zeros(1,length(t));
z_1=zeros(1,length(t));
for l=1:10:w
    y_1(l:l+9)=cumsum(co(l:l+9)); 
    z(k)=y_1(l+9);
    k=k+1;
end
figure(4);
subplot(5,1,1);plot(t(w2),y_1(w2));title('Signal Integrated over Bit Duration');xlabel('time');ylabel('amplitude');
for i=1:4
    x_1=r(i,:);
    for l=1:10:w
        z_1(l:l+9)=cumsum(x_1(l:l+9)); 
        z(k)=z_1(l+9);
        k=k+1;
    end
    s_1(i,:)=z_1;
    subplot(5,1,i+1); plot(t(w2),s_1(i,(w2))); grid on;
    title(str(i));
    xlabel('Time'); ylabel('Amplitude');
    x_1=zeros(1,length(t)); z_1=x_1;
end
r2=zeros(1,length(z));
r2=z;
r3=reshape(r2,x,5);
r4=r3';
for i=1:1:4
    r5(i)=max(abs(r4(i+1,:)));
    r6(i,:)=(r4(i+1,:)/r5(i));
end
%constellation plots for different decibels of noise added.
str={'CONSTELLATION FOR SNR @-20dB' 'CONSTELLATION FOR SNR @-10dB' 'CONSTELLATION FOR SNR @0dB' 'CONSTELLATION FOR SNR @10dB'};
for i=1:4
    figure;
    scatter(r6(i,:),zeros(1,x));title(str(i));grid on;
end
v=zeros(1,5*w); v1=0;
%decision making for demodulation of the signal
for i=1:(5*x)
    if z(i)>0
       v1=ones(1,10);
    else
       v1=-ones(1,10);
    end
    v(1,((i-1)*10)+1:i*10)=[v1]; 
end
u=reshape(v,w,5);
p=u';
figure(9);
subplot(5,1,1); plot(t(w2),f1(w2)); grid on; title('Original Data Stream'); xlabel('Time'); ylabel('Amplitude');
k=2;
str={'Retreived Binary Stream for SNR @-20dB' 'Retreived Binary Stream for SNR @-10dB' 'Retreived Binary Stream for SNR @0dB' 'Retreived Binary Stream for SNR @10dB'};
for i=1:4
subplot(5,1,i+1); plot(t(w2),p(i+1,(w2))); grid on;title(str(i));xlabel('Time'); ylabel('Amplitude');
k=k+1;
end
%bit errror rates vs snr for dpsk
 SNRdB=-20:10:10;
 SNR=10.^(SNRdB/10);
 error=0;
 for i=1:1:4
 e=p(i+1,:);     
     if (e==f1)
         error=0;
     else
         for j=1:1:w
             if ((e(j)==1&&f1(j)==-1)||(e(j)==-1&&f1(j)==1))
                  error=error+1;
             end
         end
     end
  error1(i)=error;
  error=error/w;
  m(i)=error;
  error=0;
 end
figure;
semilogy(SNRdB,m,'b','linewidth',2.5);grid on;hold on;
BER_th=(1/2)*erfc(sqrt(SNR)); 
semilogy(SNRdB,BER_th,'r','linewidth',2.5);
title('BER vs SNR FOR DPSK');
xlabel('SNR(dB)');
ylabel('BER');
legend('Simulation','Theoretical');

