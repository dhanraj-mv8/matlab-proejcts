clc;
clear all;
close all;
h=input('Enetr small data sequence');
m=length(h);
x=input('Enter long data sequence');
n=length(x);
l=input('Enter length of block');
a=n/l;
for i=n+1:n+10
     x(i)=0;
end
b=round(a);
if(a/b>1)
    b=b+1
end
h=[h zeros(1,l-1)];
v=l+m-1;
for i=0:b-1
    if (i==0)
    x1=x(i*l+1:i*l+l)
     x2=[zeros(1,m-1) x1]
    y1(i+1,:)=circularconv(x2,h)
    end
    f=length(x1);
    if(i>0)
    if(f==l)
    x2=[x((i*l)-1:i*l) x((i*l)+1:(i*l)+l)]
    y1(i+1,:)=circularconv(x2,h)
    end    
    end
end
z=y1;
for k=1:b
    p(k,:)=z(k,b:v)
end
p=p';

s=p(:)'

