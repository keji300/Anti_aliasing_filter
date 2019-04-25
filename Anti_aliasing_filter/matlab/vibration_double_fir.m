clear;clc;
Fs = 128000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 128000;             % Length of signal
t = (0:L-1)*T;        % Time vector
f1 = 2000;                %基频
f2 = 16000;
f3 = 32000;
f4 = 1000;
f5 = 4000;
f6 = 1500;
f7 = 500;
f8 = 250;
S = 0.7*sin(2*pi*f1*t) + sin(2*pi*f2*t)+sin(2*pi*f3*t)+ sin(2*pi*f4*t)+sin(2*pi*f5*t)+sin(2*pi*f6*t)+sin(2*pi*f7*t)+sin(2*pi*f8*t);

X = S+ 2*randn(size(t)); %加入噪声
% figure(1)
% plot(1000*t(1:50),X(1:50))
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('t (milliseconds)')
% ylabel('X(t)')
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1); %计算单侧频谱
f = Fs*(0:(L/2))/L;
figure(2)
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
%% 多层滤波
load 16kfir.mat;
y_16k_fir_out =filter(Num,1,X);  
%fft
Y_16k = fft(y_16k_fir_out);
P2_16 = abs(Y_16k/L);
P1_16 = P2_16(1:L/2+1);
P1_16(2:end-1) = 2*P1_16(2:end-1); %计算单侧频谱
f = Fs*(0:(L/2))/L;
figure(3)
plot(f,P1_16) 
title('first fir result')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% 滤波后抽样平均
after_first_fir_out = y_16k_fir_out;
for j = 1:16000 % 平均抽样后的长度
    y_mean(j) = mean(after_first_fir_out(j*8-7:j*8-7+8-1));
end
%fft
plot_fft(y_mean,16000);
y_pre_fir2 = y_mean;
load Num2K_n.mat
%fir
y_2k_fir_out =filter(Num2K_n,1,y_pre_fir2);
%fft
plot_fft(y_2k_fir_out,16000);
title('second fir result')
xlabel('f (Hz)')
ylabel('|P1(f)|')
%% 第二种方法，直接抽样平均后滤波
original_128k_wave =  0.7*sin(2*pi*f1*t) + sin(2*pi*f2*t)+sin(2*pi*f3*t)+ sin(2*pi*f4*t)+sin(2*pi*f5*t)+sin(2*pi*f6*t)+sin(2*pi*f7*t)+sin(2*pi*f8*t)+ 2*randn(size(t));
for j = 1:4000 % 平均抽样后的长度
    y_mean_4k(j) = mean(original_128k_wave(j*32-31:j*32-31+32-1));
end
%fft
plot_fft(original_128k_wave,Fs);
plot_fft(y_mean_4k,4000);
title('y-mean-4k result')
%直接滤掉了高频信号
