%%%%%%% 通信原理BPSK信号仿真
%%
clc 
close all 
clear all  
codn=100000;              % 仿真的码元个数 
fc=20e3;              % 载波频率
Tc=1/fc;
fs=fc*20;              %采样率
Ts=1/fs;
bode=10e3;                  % 信号波特率 
code=round(rand(1,codn));   % 产生随机信码   
code_len=round(1/bode*fs);  % 得到一个码元周期的数据长度  
%载波
t=0:Ts:(code_len*codn-1)*Ts;
car=sin(2*pi*fc*t);
%数字基带信号
for i=1:codn                
    x0((i-1)*code_len+1:code_len*i)=code(i); 
end 
x=2*x0-1; %产生双极型信号
msig=x.*car; %调制
dem=msig.*car; %解调
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
title('输入信号、调制与相干解调、判决结果')
% 判决
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
%% AWGN信道 重复实验，绘制误码率曲线
pe=[];
for j=-10:0.5:5
SNR=-10+j;
rx=awgn(msig,SNR);

%% 相干解调
dem=rx.*car;
%% 判决
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
%% 计算误码率
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
title('误码率曲线');
xlabel('平均符号信噪比dB');
ylabel('误码率');



