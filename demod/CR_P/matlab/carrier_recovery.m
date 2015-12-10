%**********************************************************
%作者： 杨再初
%时间： 2008.8.27
%
%作用： 用于仿真QPSK载波恢复
%**********************************************************
function [m_result,m_phase_out]=carrier_recovery(m_input_data)
m_phase_revolve=0;
m_sum1=0;
m_sum2=0;
m_sum3=0;
m_En=0;
m_An=[0,0];
m_data_len=length(m_input_data);
m_result_mid(1)=0;
m_loop_filter=0;
m_d=5;
m_phase_revolve_Reg=zeros(1,m_d);
for m_i=1:m_data_len
    m_middle=cos(m_phase_revolve_Reg(m_d))+j*sin(m_phase_revolve_Reg(m_d));
    m_result_mid(m_i+1)=m_input_data(:,m_i)*m_middle;
    %取实部和虚部
    m_Re1=real(m_result_mid(m_i));
    m_Im1=imag(m_result_mid(m_i));
    m_Re2=real(m_result_mid(m_i+1));
    m_Im2=imag(m_result_mid(m_i+1));
    
    %if mod(m_i,m_d)==1
        m_error1=-0.15*(sign(m_Re2)*m_Im2-sign(m_Im2)*m_Re2);
        m_An(1)=m_An(2);
        m_sum1=m_sum1+2^-4*m_error1;
        m_An(2)=m_sum1+m_error1;
    
        if sign(m_An(1))==sign(m_An(2))
            m_En=m_An(2)-m_An(1);
        end 

        %环路滤波
        m_sum2=m_sum2+(2^-8)*m_En;
        m_loop_filter=m_sum2+m_En*2^-6;
    %end
    
    m_sum3=m_phase_revolve+m_loop_filter;
    
    if m_sum3>0
        m_phase_revolve=m_sum3-floor(abs(m_sum3)/2/pi)*2*pi;
    elseif m_sum3<0
        m_phase_revolve=m_sum3+floor(abs(m_sum3)/2/pi)*2*pi;
    else 
        m_phase_revolve=m_sum3;
    end
    for m_k=m_d:-1:2
        m_phase_revolve_Reg(m_k)=m_phase_revolve_Reg(m_k-1);
    end
    m_phase_revolve_Reg(1)=m_phase_revolve;
   
%      m_phase_revolve=m_phase_revolve; 
     m_phase_out(m_i)=m_loop_filter;
end
m_result=m_result_mid;