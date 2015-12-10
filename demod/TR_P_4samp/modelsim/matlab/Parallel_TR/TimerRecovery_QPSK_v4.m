%****************************************************************
%时间：2008.8.6
%作用：对四倍以上的采样数据进行时钟恢复，并输出I、Q两路各符号判决点数值（前后会丢弃几个点）
%参数说明：
%       m_input_data...............输入待解调的数据，必须保证大于4，小于4.125(?)
%       m_repeat_num...............数据重复次数
%       m_joint....................重复数据的衔接位置
%
%       m_result...................输出采样点数据
%       m_loop_filter..............环路滤波器输出,可以反应收敛过程
%****************************************************************
function [m_result,m_loop_filter,ob_u,loop_acc]=TimerRecovery_QPSK_v4(datain,u,loop_filter)

% [m_row,m_column]=size(m_input_data);
% if m_row==2
%     m_input_data=m_input_data';
% elseif m_column~=2
%     %如果输入不是I、Q两路数据，则返回0值
%     m_result=0;
%     m_loop_filter=0;
%     return;
% end
m_input_data(:,1) = real(datain);
m_input_data(:,2) = imag(datain);

%幅度归一化
m_data_inputI=m_input_data(:,1)'/max(m_input_data(:,1));
m_data_inputQ=m_input_data(:,2)'/max(m_input_data(:,2));
% m_data_inputI=m_input_data(:,1)';
% m_data_inputQ=m_input_data(:,2)';

%找衔接点
% m_initial_phase=mod(length(m_data_inputI),4)+1;
% if m_initial_phase==0
%     m_initial_phase=1;
% end
% m_initial_phase=m_joint;
% m_data_inputI_repeat=m_data_inputI(m_initial_phase:length(m_data_inputI));
% %plot(m_data_inputI_repeat,'b*-')
% m_data_inputQ_repeat=m_data_inputQ(m_initial_phase:length(m_data_inputQ));
% for m_i=1:m_repeat_num %数据重复
%     m_data_inputI=[m_data_inputI,m_data_inputI_repeat];
%     m_data_inputQ=[m_data_inputQ,m_data_inputQ_repeat];
% end


%滤波
% m_w=window(@blackman,65);
% m_h=firrcos(64,0.5,0.15,2,'rolloff','sqrt',32,m_w);
% % plot(m_data_inputI,'b*-')
% m_data_inputI=conv(m_h,m_data_inputI);
% m_data_inputQ=conv(m_h,m_data_inputQ);

% hold on;
% plot(m_data_inputI,'r*-')
m_data_long=length(m_data_inputI);

%时钟恢复
m_loop_filter_mid=0;
m_loop_filter_out=0;
m_count1=1;%四倍采样率数据对应的指针
m_count2=1;%环路滤波器输出对应的指针
m_count3=1;%四倍采样率数据两倍抽取后对应的指针
m_count4=1;%输出最佳采样点对应的指针
m_u=u;
%ob_u=zeros(1,m_data_long-3);
m_error1=0;
m_sum=loop_filter;
m_d=6;  %环路滤波器的延时周期
m_err_delay_chain=zeros(1,m_d);%用于缓存环路滤波器输出，以仿真不同环路延时情况下的锁定效果
% m_data_inputI=[0,0,0,m_data_inputI,0,0,0];
% m_data_inputQ=[0,0,0,m_data_inputQ,0,0,0];
% plot(m_data_inputI(m_data_long-length(m_data_inputI_repeat)*m_repeat_num+3:length(m_data_inputI)),'b*-')
%for m_i=4:m_data_long
over_flag = 0;
less_flag = 0;
m_i = 3;
while m_i<=m_data_long-3,
    m_i = m_i+1;
    % 得到当前参与插值运算的数据
    m_dataI_1=m_data_inputI(m_i-1:m_i+2);
    m_dataQ_1=m_data_inputQ(m_i-1:m_i+2);
    
    if abs(m_u)<1 
        if m_u<0 
           %如果u值小于零，则转化为正数，对应的参与插值运算的数据后退一位
            m_dataI_1=m_data_inputI(m_i-2:m_i+1);
            m_dataQ_1=m_data_inputQ(m_i-2:m_i+1);
            m_data_outputI(m_count1)=CubicInterpolate(1+m_u,m_dataI_1);
            m_data_outputQ(m_count1)=CubicInterpolate(1+m_u,m_dataQ_1);
            m_u = m_u + 1;
            m_i = m_i-1;
            less_flag = less_flag+1;
        else
            m_data_outputI(m_count1)=CubicInterpolate(m_u,m_dataI_1);
            m_data_outputQ(m_count1)=CubicInterpolate(m_u,m_dataQ_1);
        end
        
        
        %数据2倍抽取
        if mod(m_count1,2)==1
            m_data_decI_1(m_count3)=m_data_outputI(m_count1);
            m_data_decQ_1(m_count3)=m_data_outputQ(m_count1);

            %if m_i>m_data_long-length(m_data_inputI_repeat)
                %记录最后一帧作为输出数据
                if mod(m_count3,2)==0 
%                     test
%                     if m_count3>8000
%                         pause(0.2);
%                     end
                    m_result(m_count4,:)=[m_data_decI_1(m_count3),m_data_decQ_1(m_count3)];
                    m_count4=m_count4+1;
                end
            %end
            m_count3=m_count3+1;
        end
        m_count1=m_count1+1;
        
    else
        %丢点，所以不进行插值运算
        if m_u>0 
            m_u=m_u-floor(m_u);
            over_flag = over_flag + 1;
        else
            m_u=m_u+floor(abs(m_u));
        end
    end;
    
    ob_u(m_i)=m_u;

%     if m_count3-1>=2 & mod(m_count3-1,2)==1
    if m_count3-1>=3 & mod(m_count3-1,2)==0
        %计算误差信号
        m_errorI_1=m_data_decI_1(m_count3-2)*(m_data_decI_1(m_count3-1)-m_data_decI_1(m_count3-3));
        m_errorQ_1=m_data_decQ_1(m_count3-2)*(m_data_decQ_1(m_count3-1)-m_data_decQ_1(m_count3-3));       
            m_error1=-m_errorI_1-m_errorQ_1;

%            m_errorI_1=( m_data_decI_1(m_count3-2) -(m_data_decI_1(m_count3-1)+m_data_decI_1(m_count3-3))/2 ) *(m_data_decI_1(m_count3-1)-m_data_decI_1(m_count3-3));
%            m_errorQ_1=( m_data_decQ_1(m_count3-2) -(m_data_decQ_1(m_count3-1)+m_data_decQ_1(m_count3-3))/2 ) *(m_data_decQ_1(m_count3-1)-m_data_decQ_1(m_count3-3));       
%             m_error1=-m_errorI_1-m_errorQ_1;
        
        for m_k=m_d:-1:2
            %环路输出缓存移位
            m_err_delay_chain(m_k)=m_err_delay_chain(m_k-1);
        end
        %环路滤波
%         m_sum=m_sum+(2^-16)*m_error1;
%         m_loop_filter_mid=(m_sum)+m_error1*(2^-7);
        m_sum=m_sum+(2^-14)*m_error1;
        m_loop_filter_mid=(m_sum)+m_error1*(2^-6);
        loop_acc(m_count2) = m_sum;
        m_err_delay_chain(1)=m_loop_filter_mid;
        
        m_loop_filter_out=m_err_delay_chain(m_d);
        m_loop_filter(m_count2)=m_loop_filter_out;
        
        m_count2=m_count2+1;
        
%         m_u=m_u+m_loop_filter_out;
    end
     m_u=m_u+m_loop_filter_out;
    
%     m_data_long-length(m_data_inputI_repeat)+3
end

pause(0.2);

