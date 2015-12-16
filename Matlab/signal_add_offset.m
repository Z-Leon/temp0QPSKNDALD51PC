clear;
close all;
%% 设定参数
a = load('Mod_out_p8.txt');
%   I    Q
%   p0   p0
%   p1   p1
%   ...
%   p7   p7
%   p0   p0
%   ...

M = 40000; %FFT点数
sclk = 400; %采样时钟频率
% Symbol rate : 50Msps
AD_w = 14;  %AD位宽
%% 
N=length(a(:,1));  % N : Sample Depth
b=a(:,1);
d = b(N-M+1:N);
%d = d-2^(AD_w-1); % unsigned --> signed 
d = d/2^(AD_w-1); % normalization
%% FFT plot
DFFT = fft(d,M);
DF = abs(DFFT)/(M/2); %除去FFT增益
DF = DF(1:M/2); %取0到fs/2


x = [0:M-1]*sclk/M;
x = x(1:M/2);
for R=1:length(DF)
    if DF(R)<1e-7
        DF(R)=1e-7;
    end
end
DF_log = 20*log10(DF);
figure;
plot( x , DF_log );

%% Add timing offset
sI = a(:,1);
sQ = a(:,2);
sI_resmp = round(resample(sI, 1001, 1000));
sQ_resmp = round(resample(sQ, 1001, 1000));
% sI_resmp = resample(sI, 1000, 1000);
% sQ_resmp = resample(sQ, 1000, 1000);


% truncation
sI_add = round(sI_resmp/64);
sQ_add = round(sQ_resmp/64);

% Write to file
fileID = fopen('Mod_add_offset.txt','w');
for k=1:(8*floor(length(sI_resmp)/8))
fprintf(fileID,'%14d  %14d\n',sI_add(k), sQ_add(k));
end
fclose(fileID);

%% Match filtering
match_fltr_half = [1,0,-1,-2,0,2,1,-1,-3,-1,3,4,1,-4,-4,4,11,4,-19,-40,-27,40,148,249,291];
match_fltr = [ match_fltr_half, match_fltr_half(end-1:-1:1)]/1024;
sI_match = conv(sI_resmp,match_fltr);
sQ_match = conv(sQ_resmp,match_fltr);

%% TR
s_match = sI_match + j*sQ_match;

[yrx_trout,m_loop_filter,ob_u,loop_acc]=TimerRecovery_QPSK_v4(s_match/3000,0,0);

figure;
plot(loop_acc);

figure;
m_inphase = yrx_trout( :,1);
m_quadphase = yrx_trout(:,2);
m_n = 1000;
m_k = floor( length(m_inphase)/m_n );
for m_i= 1:m_k
    m_inphase_t = m_inphase( (m_i-1)*m_n+1 : m_i*m_n );
    m_quadphase_t = m_quadphase( (m_i-1)*m_n+1 : m_i*m_n );
    plot(m_inphase_t,m_quadphase_t,'*');
    axis([-2,2,-2,2]);
    pause(0.3);
end






