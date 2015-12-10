clear;
clc;
close all;
tic;

%% setup
% Define parameters.
M = 4; % Size of signal constellation
k = log2(M); % Number of bits per symbol
n = 5e4; % Number of bits to process    5e4 1ms serial
nsamp = 4; % Oversampling rate
nresamp = 4.004; % Oversampling of TR

%% Signal Source
% Create a binary data stream as a column vector.
%x = randint(n,1); % Random binary data stream
coff = zeros(1,24);
coff(1) = 1;
coff(24)=1;
coff(19)=1;
int_phase=zeros(1,23);
int_phase(2) = 1;
x = PN_gen(23, coff, n, int_phase);

%% Bit-to-Symbol Mapping
% Convert the bits in x into k-bit symbols
mapping = [1 0 3 2].';
xsym = bi2de(reshape(x,k,length(x)/k).','left-msb');
xsym = mapping(xsym+1);

%% Modulation
% Modulate using QPSK
y = modulate( modem.qammod(M), xsym);

%% Filter Definition
% Define filter-related parameters.
filtorder = 64; % Filter order
delay = filtorder/(nsamp*2); % Group delay (# of input samples)
rolloff = 0.5; % Rolloff factor of filter

% Create a square root raised cosine filter.
rrcfilter = rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
%rrcfilter = rcosine(1,nsamp,'fir',rolloff,delay);
%rrcfilter = firrcos(64,0.5,0.25,2,'rolloff');

% Plot impulse response.
%figure; impz(rrcfilter,1);

%% Transmitted Signal
% Upsample and apply square root raised cosine filter.

y_temp = [y,y,y,y];
y2 = reshape(y_temp.',1,4*length(y));
y2 = y2.';

ytx = rcosflt(y,1,nsamp,'filter',rrcfilter);
%ytx = rcosflt(y2,1,nsamp,'Fs/filter',rrcfilter);
%plot(real(ytx(1:2e4)),'*-');
% Create eye diagram for part of filtered signal.
%eyediagram(ytx(1:2000),nsamp*2);

%% Channel
% Send signal over an AWGN channel.
EbNo = 15; % In dB
snr = EbNo + 10*log10(k) - 10*log10(nsamp);
ynoisy = awgn(ytx,snr,'measured');
%test
%ynoisy = ytx;

%% Signal Resampling
samp_rate_up=floor(nresamp*1000+1e-10);
samp_rate_down=4000;
ynoisy_resamp = resample( ynoisy,samp_rate_up,samp_rate_down);
%ynoisy_resamp = ynoisy

%% Received Signal
% Filter received signal using square root raised cosine filter.
yrx = rcosflt(ynoisy_resamp,1,nsamp,'Fs/filter',rrcfilter);
%yrx_2 = rcosflt(ytx,1,nsamp,'Fs/filter',rrcfilter);
%plot(real(yrx_2),'.-'); grid on;

%Add freq bias
% len_y = length(yrx_1);
% for ii = 1:len_y   
%     yrx(ii) = yrx_1(ii)*( cos(2*pi/500*ii) + j*sin(2*pi/500*ii) );
% end 

fir_order =0;
% m_h = fir1(fir_order,0.3);
% freqz(m_h);
% yrx = filter( m_h,1,yrx_1);

%yrx = yrx_1;
%yrx = downsample(yrx,nsamp); % Downsample.
%plot( real(yrx) , '*-');
%yrx = yrx(2*delay+1:end-2*delay); % Account for delay.

%% Timing Recovery

%plot(real(yrx),'*-');
remove_end = 128;
yrx = yrx( 1:length(yrx)-remove_end );

m=[real(yrx),imag(yrx)];
m=round(m*64);

fid = fopen('Data_matlab_gen.txt','w');
for i=1:8*floor(length(m)/8)
    fprintf(fid,'%d\t%d\n',[m(i,1),m(i,2)]);
end
fclose(fid); 

[ReceiveTimeRecovery_I, ReceiveTimeRecovery_Q, m_loop_filter,loop_acc] = TimerRecovery_Parallel( real(yrx), imag(yrx));
plot(loop_acc);
% 
% figure;
% m_inphase = ReceiveTimeRecovery_I;
% m_quadphase = ReceiveTimeRecovery_Q;
% m_n = 2000;
% m_k = floor( length(m_inphase)/m_n );
% for m_i= 1:m_k
%     m_inphase_t = m_inphase( (m_i-1)*m_n+1 : m_i*m_n );
%     m_quadphase_t = m_quadphase( (m_i-1)*m_n+1 : m_i*m_n );
%     plot(m_inphase_t,m_quadphase_t,'*');
%     axis([-1,1,-1,1]);
%     pause(0.5);
% end

[yrx_trout,loop_filter,ob_u,loop_acc]=TimerRecovery_QPSK_v4(yrx,0,0);
%plot(loop_filter);
%ylim([-0.015,0.015]);
figure;
plot(loop_acc);
% figure;
% plot(ob_u);
% ylim([-1.1,1.1]);
% 
% figure;
% plot(real(yrx),'.-')



%% Scatter Plot
% % Create scatter plot of received signal before and
% % after filtering.
% h = scatterplot(sqrt(nsamp)*ynoisy(1:nsamp*5e3),nsamp,0,'g.');
% hold on;
% scatterplot(yrx_out(1:5e3),1,0,'kx',h);
% title('Received Signal, Before and After Filtering');
% legend('Before Filtering','After Filtering');
% axis([-5 5 -5 5]); % Set axis ranges.

figure;
m_inphase = yrx_trout( :,1);
m_quadphase = yrx_trout(:,2);
m_n = 2000;
m_k = floor( length(m_inphase)/m_n );
for m_i= 1:m_k
    m_inphase_t = m_inphase( (m_i-1)*m_n+1 : m_i*m_n );
    m_quadphase_t = m_quadphase( (m_i-1)*m_n+1 : m_i*m_n );
    plot(m_inphase_t,m_quadphase_t,'*');
    axis([-1,1,-1,1]);
    pause(0.5);
end
    
%% Demodulation
% Demodulate signal using 16-QAM.
yrx_trout = complex( yrx_trout(:,1), yrx_trout(:,2) );
zsym = demodulate(modem.qamdemod(M),yrx_trout);

%% Symbol-to-Bit Mapping
% Undo the bit-to-symbol mapping performed earlier.

% A. Define a vector that inverts the mapping operation.
[dummy demapping] = sort(mapping);
% Initially, demapping has values between 1 and M.
% Subtract 1 to obtain values between 0 and M-1.
demapping = demapping - 1;

% B. Map between Gray and binary coding.
zsym = demapping(zsym+1);

% C. Do ordinary decimal-to-binary mapping.
z = de2bi(zsym,'left-msb');
% Convert z from a matrix to a vector.
z = reshape(z.',prod(size(z)),1);

%% BER Computation
% Compare x and z to obtain the number of errors and
% the bit error rate.
z = z(1: length(z)-4*delay);
% x = x(1: min(length(x),length(z)));
num_throw = 5e3; %5.5e4
throw2 = fir_order/4;
[number_of_errors,bit_error_rate] = biterr( x(num_throw-throw2:length(x)-throw2) , z( num_throw-length(x)+length(z) : length(z) ) )

toc















