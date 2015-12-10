% clear;
% m_a=load('..\timerecovery\try_I.txt');
% m_b=load('..\timerecovery\try_Q.txt');
% m_len=min([length(m_a),length(m_b)])
% m_b=m_b(1:m_len);
% m_a=m_a(1:m_len);
% m_index=(3:4:length(m_a));
% m_c1=m_a(m_index);
% % m_index=(3:4:length(m_a));
% m_c2=m_b(m_index);
% m_data_with_err=m_c1+m_c2*i;
% subplot(221);
% plot(m_data_with_err(round(length(m_data_with_err)/2):length(m_data_with_err)-1000),'b*');
% % return

a = load('crin_new_2.txt');
b = a( a(:,2)==1,3:4);
b_i = b(:,1);
b_q = b(:,2);
m_data_with_err = b_i + b_q*i;
m_data_with_err = m_data_with_err.';
[m_result,m_phase_out]=carrier_recovery(m_data_with_err);

% subplot(222);
figure;
len = length(m_result);
len2 = 3000;
m_data_mid = m_result(len-len2:len);
plot(m_data_mid,'b*');
axis([-40,40,-40,40]);
grid on;

% for m_i=1:4000:len
%     m_data_mid=m_result(m_i:m_i+100);
%     plot(m_data_mid,'b*');
%     drawnow;
%     pause(0.5)
% end

% subplot(223);
% plot(m_phase_out,'b');