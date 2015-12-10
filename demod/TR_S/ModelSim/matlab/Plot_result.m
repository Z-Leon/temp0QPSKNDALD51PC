a = load('tr_out.txt');



figure;
m_inphase = a( :,1);
m_quadphase = a(:,2);
len = length(a(:,1));

m_n = 400;
m_k = floor( length(m_inphase)/m_n );
for m_i= 1:m_k
    m_inphase_t = m_inphase( (m_i-1)*m_n+1 : m_i*m_n );
    m_quadphase_t = m_quadphase( (m_i-1)*m_n+1 : m_i*m_n );
    plot(m_inphase_t,m_quadphase_t,'*');
    axis([-100,100,-100,100]);
    pause(0.5);
end
    















