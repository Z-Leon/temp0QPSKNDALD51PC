a = load('result.txt');

m_inphase = a( :,1);
m_quadphase = a(:,2);
len = length(a(:,1));
m_i = zeros(len,1);
m_q = zeros(len,1);
for i=1:len
    if m_inphase(i)>0 
        m_i(i) = 1;
    else
        m_i(i) = 0;
    end
    if m_quadphase(i)>0 
        m_q(i) = 1;
    else
        m_q(i) = 0;
    end
end

m_data = [m_i';m_q'];
m_d = reshape(m_data,1,len*2);
m_d = m_d(len:1:len*2);

coff = zeros(1,24);
coff(1) = 1;
coff(24)=1;
coff(19)=1;
int_phase = m_d(1:23);

m_d_2=PN_gen(23, coff, length(m_d), int_phase);
[number_of_errors,bit_error_rate] = biterr(m_d,m_d_2);
bit_error_rate

    















