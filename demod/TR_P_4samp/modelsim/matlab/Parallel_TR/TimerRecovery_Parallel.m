function [ReceiveTimeRecovery_I, ReceiveTimeRecovery_Q, m_loop_filter, loop_acc] = TimerRecovery_Parallel( InputData_I, InputData_Q)

N_Parallel = 8;

%幅度归一化
m_data_inputI = InputData_I / max( InputData_I );
m_data_inputQ = InputData_Q / max( InputData_Q );

%滤波
% m_w=window(@blackman,65);
% m_h=firrcos(64,0.5,0.15,2,'rolloff','sqrt',32,m_w);
% m_data_inputI = conv( m_h, m_data_inputI );
% m_data_inputQ = conv( m_h, m_data_inputQ );
% 
% m_data_long = length( m_data_inputI );
% 
% m_data_inputI = m_data_inputI( 33:m_data_long-32 );
% m_data_inputQ = m_data_inputQ( 33:m_data_long-32 );

m_data_long = length( m_data_inputI );

%时钟恢复
m_loop_filter_mid=0;
m_loop_filter_out=0;
m_count1=1; % 插值器输出指针,4倍采样率数据
m_count2=1; % 环路滤波器输出对应的指针,1倍采样率
m_count3=1; % 插值器输出2倍抽取后指针,2倍采样率数据,,用于计算时钟误差
m_count4=1 ;% 输出最佳采样点对应的指针,1倍采样率
m_u=0;
m_error1=0;
m_sum=0;
m_d=25;  %环路滤波器的延时周期
m_err_delay_chain=zeros(1,m_d);%用于缓存环路滤波器输出，以仿真不同环路延时情况下的锁定效果

u_parallel_inc = zeros(1,N_Parallel);
Mu_parallel = zeros(1,N_Parallel);
m_data_decI_1 = zeros(1,N_Parallel/2);
m_data_decQ_1 = zeros(1,N_Parallel/2);
m_data__Fifo_I = zeros(1, N_Parallel*2);
m_data__Fifo_Q = zeros(1, N_Parallel*2);
Fifo_startpoint = 1;
Fifo_endpoint = 1;



m_dataI_1 = zeros(1,N_Parallel+3);
m_dataQ_1 = zeros(1,N_Parallel+3);

Garner_Data_I = m_data_inputI;
Garner_Data_Q = m_data_inputQ;


num_loop = 1;

for rep_times=1:num_loop       
    
    n1 = m_data_long;
       
    for m_i=1:N_Parallel:n1
        
        if (m_i>m_data_long)
            Reverse_Flag = true;
        else
            Reverse_Flag = false;
        end
        
        
        % data for parallel interpolation
        m_dataI_1(1) = m_dataI_1(N_Parallel+1);
        m_dataI_1(2) = m_dataI_1(N_Parallel+2);
        m_dataI_1(3) = m_dataI_1(N_Parallel+3);
        
        m_dataQ_1(1) = m_dataQ_1(N_Parallel+1);
        m_dataQ_1(2) = m_dataQ_1(N_Parallel+2);
        m_dataQ_1(3) = m_dataQ_1(N_Parallel+3);
        
        for j=1:N_Parallel
            if (m_i+j-1)<n1
                m_dataI_1(3+j) = Garner_Data_I(m_i+j-1);        
                m_dataQ_1(3+j) = Garner_Data_Q(m_i+j-1);
            else
                m_dataI_1(3+j) = 0;        
                m_dataQ_1(3+j) = 0;
            end
        end 
        
               
        %TED control
        % Mu increase for parallel interpolation
        for j=1:N_Parallel
            u_parallel_inc(j) = m_u * j;
        end;
        
        % judge if throwing point in last frame 
        Jump_sign = 0;
        for j=1:N_Parallel
            if abs( Mu_parallel(j) )>=1
                Jump_sign = 1;
            end
        end

        % get the last Mu of last frame
        if( abs(Mu_parallel(N_Parallel))<1 )
            Mu_parallel_last = Mu_parallel(N_Parallel);
        else
            if Mu_parallel(N_Parallel)>0
                Mu_parallel_last = Mu_parallel(N_Parallel) - floor(Mu_parallel(N_Parallel));
            else               
                Mu_parallel_last = Mu_parallel(N_Parallel) + floor(abs(Mu_parallel(N_Parallel)));
            end
            
        end
        % get Mu of current frame
        if Jump_sign==1
            Mu_parallel(1) = Mu_parallel_last;
            for j=2:N_Parallel
                Mu_parallel(j) = Mu_parallel_last + u_parallel_inc(j-1);
            end
        else
            for j=1:N_Parallel
                Mu_parallel(j) = Mu_parallel_last + u_parallel_inc(j);
            end
        end
        
        % get Mu for calculation
        for j=1:N_Parallel
            if abs( Mu_parallel(j) )>=1
                if Mu_parallel(j)>0
                    Mu_temp(j) = Mu_parallel(j) - floor(Mu_parallel(j));
                else
                    Mu_temp(j) = Mu_parallel(j) + floor( abs(Mu_parallel(j)) );
                end
            else
                Mu_temp(j) = Mu_parallel(j);
            end
        end
        
        % enable to out
        if abs( Mu_parallel(1) )>=1
            enable_out(1) = 0;            
        else
            enable_out(1) = 1;
        end        
        for j=2:N_Parallel
            if abs( Mu_parallel(j) )>=1
                if abs( Mu_parallel(j-1) )>=1
                    enable_out(j) = 1;
                else
                    enable_out(j) = 0;
                end
            else
                enable_out(j) = 1;
            end
        end        
        
        % adjust Mu for interpolation
        if enable_out==[0,1,1,1,1,1,1,1]
            Mu_interpolation(1) = 0;
            for j=2:N_Parallel
                Mu_interpolation(j) = Mu_temp(j-1);
            end
        elseif enable_out==[1,0,1,1,1,1,1,1]
            Mu_interpolation(1) = Mu_temp(1);
            Mu_interpolation(2) = 0;
            for j=3:N_Parallel
                Mu_interpolation(j) = Mu_temp(j-1);
            end
        elseif enable_out==[1,1,0,1,1,1,1,1]
            Mu_interpolation(1) = Mu_temp(1);
            Mu_interpolation(2) = Mu_temp(2);
            Mu_interpolation(3) = 0;
            for j=4:N_Parallel
                Mu_interpolation(j) = Mu_temp(j-1);
            end
        elseif enable_out==[1,1,1,0,1,1,1,1]
            Mu_interpolation(1) = Mu_temp(1);
            Mu_interpolation(2) = Mu_temp(2);
            Mu_interpolation(3) = Mu_temp(3);
            Mu_interpolation(4) = 0;
            for j=5:N_Parallel
                Mu_interpolation(j) = Mu_temp(j-1);
            end
        elseif enable_out==[1,1,1,1,0,1,1,1]
            Mu_interpolation(1) = Mu_temp(1);
            Mu_interpolation(2) = Mu_temp(2);
            Mu_interpolation(3) = Mu_temp(3);
            Mu_interpolation(4) = Mu_temp(4);
            Mu_interpolation(5) = 0;
            for j=6:N_Parallel
                Mu_interpolation(j) = Mu_temp(j-1);
            end
        elseif enable_out==[1,1,1,1,1,0,1,1]
            Mu_interpolation(1) = Mu_temp(1);
            Mu_interpolation(2) = Mu_temp(2);
            Mu_interpolation(3) = Mu_temp(3);
            Mu_interpolation(4) = Mu_temp(4);
            Mu_interpolation(5) = Mu_temp(5);
            Mu_interpolation(6) = 0;
            for j=7:N_Parallel
                Mu_interpolation(j) = Mu_temp(j-1);
            end
        elseif enable_out==[1,1,1,1,1,1,0,1]
            Mu_interpolation(1) = Mu_temp(1);
            Mu_interpolation(2) = Mu_temp(2);
            Mu_interpolation(3) = Mu_temp(3);
            Mu_interpolation(4) = Mu_temp(4);
            Mu_interpolation(5) = Mu_temp(5);
            Mu_interpolation(6) = Mu_temp(6);
            Mu_interpolation(7) = 0;
            
            Mu_interpolation(N_Parallel) = Mu_temp(N_Parallel-1);
        elseif enable_out==[1,1,1,1,1,1,1,0]
            Mu_interpolation(1) = Mu_temp(1);
            Mu_interpolation(2) = Mu_temp(2);
            Mu_interpolation(3) = Mu_temp(3);
            Mu_interpolation(4) = Mu_temp(4);
            Mu_interpolation(5) = Mu_temp(5);
            Mu_interpolation(6) = Mu_temp(6);
            Mu_interpolation(7) = Mu_temp(7);;
            
            Mu_interpolation(N_Parallel) = 0;
        else
            for j=1:N_Parallel
                Mu_interpolation(j) = Mu_temp(j);
            end            
        end
        
       % interpolation
       for j=1:N_Parallel
           m_data__intpola_I(j) = CubicInterpolate( Mu_interpolation(j), m_dataI_1(j:j+3) );
           m_data__intpola_Q(j) = CubicInterpolate( Mu_interpolation(j), m_dataQ_1(j:j+3) );
       end
       
       % fifo control
       for j=1:N_Parallel
           if enable_out(j)==1               
               m_data__Fifo_I(Fifo_endpoint) = m_data__intpola_I(j);
               m_data__Fifo_Q(Fifo_endpoint) = m_data__intpola_Q(j);
               Fifo_endpoint = mod( Fifo_endpoint+1, N_Parallel*2 );
               if Fifo_endpoint==0
                   Fifo_endpoint = N_Parallel*2;
               end
           end
       end
  
      
            
       %数据2倍抽取,zero point and best sample point
       m_data_decI_1_last4 = m_data_decI_1(4);
       m_data_decQ_1_last4 = m_data_decQ_1(4);

       Fifo_num = Fifo_endpoint - Fifo_startpoint;
       if Fifo_endpoint<Fifo_startpoint
           Fifo_num = Fifo_num + 16;
       end
       if Fifo_num>=8
           for j=1:N_Parallel/2
               m_data_decI_1(j) = m_data__Fifo_I(Fifo_startpoint);
               m_data_decQ_1(j) = m_data__Fifo_Q(Fifo_startpoint);
               Fifo_startpoint = mod( Fifo_startpoint+2, N_Parallel*2 );
               if Fifo_startpoint==0
                   Fifo_startpoint = N_Parallel*2;
               end
           end
           %数据4倍抽取,best sample point
           for j=1:N_Parallel/4
               m_data_decI_2(j)=m_data_decI_1(j*2);
               m_data_decQ_2(j)=m_data_decQ_1(j*2);
           end

           if( rep_times==num_loop )
               %记录最后一帧作为输出数据
               ReceiveTimeRecovery_I(m_count4) = m_data_decI_2(1);
               ReceiveTimeRecovery_I(m_count4+1) = m_data_decI_2(2);
               ReceiveTimeRecovery_Q(m_count4) = m_data_decQ_2(1);
               ReceiveTimeRecovery_Q(m_count4+1) = m_data_decQ_2(2);
               m_count4 = m_count4 + 2;
           end
       else
           continue;
       end



       %计算误差信号
       m_errorI_1 = m_data_decI_1(1)*( m_data_decI_1(2) - m_data_decI_1_last4 );
       m_errorQ_1 = m_data_decQ_1(1)*( m_data_decQ_1(2) - m_data_decQ_1_last4 );
       m_errorI_2 = m_data_decI_1(3)*( m_data_decI_1(4) - m_data_decI_1(2) );
       m_errorQ_2 = m_data_decQ_1(3)*( m_data_decQ_1(4) - m_data_decQ_1(2) );

       m_error1 = (m_errorI_1 + m_errorQ_1 + m_errorI_2 + m_errorQ_2) / 2;

       for m_k=m_d:-1:2
           %环路输出缓存移位
           m_err_delay_chain(m_k)=m_err_delay_chain(m_k-1);
       end
       %环路滤波
       %m_sum = m_sum + (2^-15) * m_error1;
       %m_loop_filter_mid = (m_sum) + m_error1*(2^-8);
       m_sum = m_sum + (2^-14) * m_error1;
       m_loop_filter_mid = (m_sum) + m_error1*(2^-7);
       m_err_delay_chain(1) = m_loop_filter_mid;

       loop_acc(m_count2) = -m_sum;
       
       m_loop_filter_out = m_err_delay_chain(m_d);
       m_loop_filter(m_count2) = m_loop_filter_out;

       m_count2 = m_count2+1;

       m_u =  - m_loop_filter_out;
   
      for j=1:N_Parallel
          if enable_out(j)==1           
              u_out(m_count1) = Mu_interpolation(j); 
              m_count1 = m_count1+1;
          end
       end
       
    end        
        
end
% figure(1);
% plot( u_out );
% 
% figure(2);
% set( gca, 'FontSize', 20 );
% plot( -m_loop_filter, 'k', 'LineWidth', 2);
% %xlabel('运算次数', 'FontSize',24);
% %ylabel('环路滤波器输出', 'FontSize',24);
% title('正反相间重复法环路滤波器输出', 'FontSize',20);