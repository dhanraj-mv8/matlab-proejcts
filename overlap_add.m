clc;
clear all;
close all;
h=input('Enetr small data sequence');
m=length(h);
x=input('Enter long data sequence');
n=length(x);
l=input('Enter length of block');
a=n/l
for i=n+1:n+10
     x(i)=0;
end
b=ceil(a)
% if(a/b>1)
%     b=b+1
% end
h=[h zeros(1,l-1)];
v=l+m-1;
for i=0:b-1
    x1=x(i*l+1:i*l+l);
    f=length(x1);
    if(f==l)
    x2=[x1 zeros(1,m-1)];
    y1(i+1,:)=cconv(x2,h);
    end    
    if (f<l)
          x2=[x1 zeros(1,v-f)];
          y1(i+1,:)=cconv(x2,h);
    end            
end
z=y1;
for k=1:b-1
    z(k+1,1:v-l)=z(k+1,1:v-l)+z(k,l+1:v);
end
for k=1:b
    d(k,:)=z(k,1:l);    
end
d=d';
s=d(:)';

