clear;
m_a=load('try_I.txt');
m_b=load('try_Q.txt');
m_len=min([length(m_a),length(m_b)])
m_b=m_b(1:m_len);
m_a=m_a(1:m_len);
%m_a=m_a*128;
%m_b=m_b*128;
m_index=(3:4:length(m_a));
m_c1=m_a(m_index);
% m_index=(3:4:length(m_a));
m_c2=m_b(m_index);
m_d=m_c1+m_c2*i;
for m_i=1:10:length(m_c1)-100
    m_mid=m_d(m_i:m_i+100);
    plot(m_mid,'b*');
    axis([-1.2,1.2,-1.2,1.2]);
    drawnow;
end

% m_count1=1;
% for m_i=2:2:length(m_c1)
%     m_error(m_count1)=(m_c1(m_i)-m_c1(m_i-2))*m_c1(m_i-1);
%     m_count1=m_count1+1;
% end