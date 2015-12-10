function [ReceiveCarrierRecovery_I, ReceiveCarrierRecovery_Q, m_phase_filter] = CarrierRecovery_Parallel( InputData_I, InputData_Q, nRepeatNum )

N_Parallel = 4;


m_d = 5;
m_phase_revolve_Reg = zeros(1,m_d);
m_sum1 = 0; 
m_sum2 = 0;
m_sum3 = 0;
m_phase_revolve = 0;
m_loop_filter = 0;
m_An = [0,0]; 
m_En = 0; 

count_out = 1;
count_filter = 1;

m_data_long = length(InputData_I);

m_input_data_I = InputData_I;
m_input_data_Q = InputData_Q;

num_loop = 1;

for rep_times=1:num_loop       
    
    n1 = m_data_long;
        
    for m_i=1:N_Parallel:n1    
        
        m_sum3 = m_phase_revolve + m_loop_filter;
                
        %phase adjust to (-2pi~2pi) 
        if m_sum3>=2*pi
            m_phase_revolve = m_sum3-2*pi;
        elseif m_sum3<=-2*pi
            m_phase_revolve = m_sum3+2*pi;
        else 
            m_phase_revolve = m_sum3;
        end
    
        for m_k=m_d:-1:2
            m_phase_revolve_Reg(m_k) = m_phase_revolve_Reg(m_k-1);
        end    
        m_phase_revolve_Reg(1) = m_phase_revolve;    
        
        % phase revolve       
        m_middle = complex( cos( m_phase_revolve_Reg(m_d) ), sin( m_phase_revolve_Reg(m_d) ) );    
        

        for j=1:N_Parallel
            m_complex_data(j) = complex( m_input_data_I(m_i+j-1), m_input_data_Q(m_i+j-1) );
            m_result_mid(j) = m_complex_data(j) * m_middle;
            %取实部和虚部
            m_Re(j) = real( m_result_mid(j) );
            m_Im(j) = imag( m_result_mid(j) );
            % phase error detection
            error_branch(j) = sign(m_Im(j)) * m_Re(j) - sign(m_Re(j)) * m_Im(j);    
        end           
        
%         m_sum1(j) = m_sum1(j) + (2^-5) * error_branch(j);
%             m_An(j) = m_sum1(j) + error_branch(j)/2;
%         
%         if ( sign(m_An_last)==sign(m_An(1)) )
%             m_En(1) = m_An(1) - m_An_last;
%         end 
%         for j=2:N_Parallel
%             if ( sign(m_An(j))==sign(m_An(j-1)) )
%                 m_En(j) = m_An(j) - m_An(j-1);
%             else
%                 m_En(j) = m_En(j-1);
%             end 
%         end      
%         
%         m_En_Sum = ( m_En(1) + m_En(2) + m_En(3) + m_En(4) )/1;  

        m_error1 = error_branch(1) +  error_branch(2) +  error_branch(3) +  error_branch(4);
        
        m_An(1) = m_An(2);
        m_sum1 = m_sum1 + (2^-5) * m_error1;
        m_An(2) = m_sum1 + m_error1/2;   
        
        
        if ( sign(m_An(1))==sign(m_An(2)) )
            m_En = m_An(2) - m_An(1);
        end 
        
        %环路滤波   
%         m_sum2 = m_sum2 + (2^-8) * m_En;
%         m_loop_filter = m_sum2 + m_En * (2^-4);
        m_sum2 = m_sum2 + (2^-7) * m_En;
        m_loop_filter = m_sum2 + m_En * (2^-3);
        
        for j=1:N_Parallel
            m_Recovery_I(count_out) = m_Re(j);
            m_Recovery_Q(count_out) = m_Im(j);              
            count_out = count_out + 1;
        end           
        m_phase_filter(count_filter) = m_loop_filter;
        count_filter = count_filter + 1;
        
    end
    
end

ReceiveCarrierRecovery_I = m_Recovery_I(1:m_data_long);
ReceiveCarrierRecovery_Q = m_Recovery_Q(1:m_data_long);

plot( m_phase_filter, 'k', 'LineWidth', 2);