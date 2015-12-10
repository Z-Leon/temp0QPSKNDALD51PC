%****************************************************************
%ʱ�䣺2008.8.6
%���ã����ı����ϵĲ������ݽ���ʱ�ӻָ��������I��Q��·�������о�����ֵ��ǰ��ᶪ�������㣩
%����˵����
%       m_input_data...............�������������ݣ����뱣֤����4��С��4.125(?)
%       m_repeat_num...............�����ظ�����
%       m_joint....................�ظ����ݵ��ν�λ��
%
%       m_result...................�������������
%       m_loop_filter..............��·�˲������,���Է�Ӧ��������
%****************************************************************
function [m_result,m_loop_filter,ob_u,loop_acc]=TimerRecovery_QPSK_v4(datain,u,loop_filter)

% [m_row,m_column]=size(m_input_data);
% if m_row==2
%     m_input_data=m_input_data';
% elseif m_column~=2
%     %������벻��I��Q��·���ݣ��򷵻�0ֵ
%     m_result=0;
%     m_loop_filter=0;
%     return;
% end
m_input_data(:,1) = real(datain);
m_input_data(:,2) = imag(datain);

%���ȹ�һ��
m_data_inputI=m_input_data(:,1)'/max(m_input_data(:,1));
m_data_inputQ=m_input_data(:,2)'/max(m_input_data(:,2));
% m_data_inputI=m_input_data(:,1)';
% m_data_inputQ=m_input_data(:,2)';

%���νӵ�
% m_initial_phase=mod(length(m_data_inputI),4)+1;
% if m_initial_phase==0
%     m_initial_phase=1;
% end
% m_initial_phase=m_joint;
% m_data_inputI_repeat=m_data_inputI(m_initial_phase:length(m_data_inputI));
% %plot(m_data_inputI_repeat,'b*-')
% m_data_inputQ_repeat=m_data_inputQ(m_initial_phase:length(m_data_inputQ));
% for m_i=1:m_repeat_num %�����ظ�
%     m_data_inputI=[m_data_inputI,m_data_inputI_repeat];
%     m_data_inputQ=[m_data_inputQ,m_data_inputQ_repeat];
% end


%�˲�
% m_w=window(@blackman,65);
% m_h=firrcos(64,0.5,0.15,2,'rolloff','sqrt',32,m_w);
% % plot(m_data_inputI,'b*-')
% m_data_inputI=conv(m_h,m_data_inputI);
% m_data_inputQ=conv(m_h,m_data_inputQ);

% hold on;
% plot(m_data_inputI,'r*-')
m_data_long=length(m_data_inputI);

%ʱ�ӻָ�
m_loop_filter_mid=0;
m_loop_filter_out=0;
m_count1=1;%�ı����������ݶ�Ӧ��ָ��
m_count2=1;%��·�˲��������Ӧ��ָ��
m_count3=1;%�ı�����������������ȡ���Ӧ��ָ��
m_count4=1;%�����Ѳ������Ӧ��ָ��
m_u=u;
%ob_u=zeros(1,m_data_long-3);
m_error1=0;
m_sum=loop_filter;
m_d=6;  %��·�˲�������ʱ����
m_err_delay_chain=zeros(1,m_d);%���ڻ��滷·�˲���������Է��治ͬ��·��ʱ����µ�����Ч��
% m_data_inputI=[0,0,0,m_data_inputI,0,0,0];
% m_data_inputQ=[0,0,0,m_data_inputQ,0,0,0];
% plot(m_data_inputI(m_data_long-length(m_data_inputI_repeat)*m_repeat_num+3:length(m_data_inputI)),'b*-')
%for m_i=4:m_data_long
over_flag = 0;
less_flag = 0;
m_i = 3;
while m_i<=m_data_long-3,
    m_i = m_i+1;
    % �õ���ǰ�����ֵ���������
    m_dataI_1=m_data_inputI(m_i-1:m_i+2);
    m_dataQ_1=m_data_inputQ(m_i-1:m_i+2);
    
    if abs(m_u)<1 
        if m_u<0 
           %���uֵС���㣬��ת��Ϊ��������Ӧ�Ĳ����ֵ��������ݺ���һλ
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
        
        
        %����2����ȡ
        if mod(m_count1,2)==1
            m_data_decI_1(m_count3)=m_data_outputI(m_count1);
            m_data_decQ_1(m_count3)=m_data_outputQ(m_count1);

            %if m_i>m_data_long-length(m_data_inputI_repeat)
                %��¼���һ֡��Ϊ�������
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
        %���㣬���Բ����в�ֵ����
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
        %��������ź�
        m_errorI_1=m_data_decI_1(m_count3-2)*(m_data_decI_1(m_count3-1)-m_data_decI_1(m_count3-3));
        m_errorQ_1=m_data_decQ_1(m_count3-2)*(m_data_decQ_1(m_count3-1)-m_data_decQ_1(m_count3-3));       
            m_error1=-m_errorI_1-m_errorQ_1;

%            m_errorI_1=( m_data_decI_1(m_count3-2) -(m_data_decI_1(m_count3-1)+m_data_decI_1(m_count3-3))/2 ) *(m_data_decI_1(m_count3-1)-m_data_decI_1(m_count3-3));
%            m_errorQ_1=( m_data_decQ_1(m_count3-2) -(m_data_decQ_1(m_count3-1)+m_data_decQ_1(m_count3-3))/2 ) *(m_data_decQ_1(m_count3-1)-m_data_decQ_1(m_count3-3));       
%             m_error1=-m_errorI_1-m_errorQ_1;
        
        for m_k=m_d:-1:2
            %��·���������λ
            m_err_delay_chain(m_k)=m_err_delay_chain(m_k-1);
        end
        %��·�˲�
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

