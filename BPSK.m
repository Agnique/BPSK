%%%%%%% ͨ��ԭ��BPSK�źŷ���
%%
clc 
close all 
clear all  
codn=100000;              % �������Ԫ���� 
fc=20e3;              % �ز�Ƶ��
Tc=1/fc;
fs=fc*20;              %������
Ts=1/fs;
bode=10e3;                  % �źŲ����� 
code=round(rand(1,codn));   % �����������   
code_len=round(1/bode*fs);  % �õ�һ����Ԫ���ڵ����ݳ���  
%�ز�
t=0:Ts:(code_len*codn-1)*Ts;
car=sin(2*pi*fc*t);
%���ֻ����ź�
for i=1:codn                
    x0((i-1)*code_len+1:code_len*i)=code(i); 
end 
x=2*x0-1; %����˫�����ź�
msig=x.*car; %����
dem=msig.*car; %���
figure
plot(x0,'r-','LineWidth',6)
axis([0 length(t) -1.5 1.5]) 
grid on 
zoom on 
hold on;
plot(msig,'b-','LineWidth',3)
axis([0 length(t) -1.5 1.5]) 
grid on 
zoom on 
hold on;
plot(dem,'g-','LineWidth',1)
axis([0 length(t) -1.5 1.5]) 
grid on 
zoom on 
title('�����źš���������ɽ�����о����')
% �о�
k=1;
rcv=[];
for i=1:codn
    sm=0;
    for j=1:code_len
        sm=sm+dem(k);
        k=k+1;
    end
    if(sm>0)
        rcv=[rcv 1];
    else
        rcv=[rcv 0];
    end  
end
for i=1:codn                
    y0((i-1)*code_len+1:code_len*i)=rcv(i); 
end 
plot(y0,'g-','LineWidth',2)
axis([0 length(t) -1.5 1.5]) 
grid on 
zoom on
hold off;
%% AWGN�ŵ� �ظ�ʵ�飬��������������
pe=[];
for j=-10:0.5:5
SNR=-10+j;
rx=awgn(msig,SNR);

%% ��ɽ��
dem=rx.*car;
%% �о�
k=1;
rcv=[];
for i=1:codn
    sm=0;
    for j=1:code_len
        sm=sm+dem(k);
        k=k+1;
    end
    if(sm>0)
        rcv=[rcv 1];
    else
        rcv=[rcv 0];
    end  
end
for i=1:codn                
    y0((i-1)*code_len+1:code_len*i)=rcv(i); 
end 
%plot(y0,'g-','LineWidth',2)
%axis([0 length(t) -1.5 1.5]) 
%grid on 
%zoom on
%hold off;
%% ����������
err=1-sum(code==rcv)/length(code);
pe=[pe err];
%fprintf('SNR:%d, error rate: %f\n', SNR, err);
end
%% 
figure
x=-10:0.5:5;
x1=power(10,(x/10));
y=0.5*erfc(sqrt(x1));
semilogy(x,y,'LineWidth',4);
hold on;
semilogy(x,pe,'-r','LineWidth',2);
title('����������');
xlabel('ƽ�����������dB');
ylabel('������');



