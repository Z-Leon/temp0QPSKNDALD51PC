%******************************************************************
%时间：2008.08.20
%作用：产生PN序列
%参数说明：
%      M：.................PN序列阶数   例如：9
%      Poly_coff：.........生成多项式系数 例如[1,0,0,0,1,0,0,0,0,1],
%                          表示x^9+x^4+1  (c4=1)
%      Len.................输出序列的长度
%      Int_phase.......初相位，例如[0,1,0,0,0,0,0,0,0]
%      PN_out..............输出结果
%*******************************************************************
function [ PN_out ] = PN_gen( M, Poly_coff, Len, Int_phase )

x=zeros(1,M);    %移位寄存器
x=Int_phase;
PN_out=zeros(1,Len);
PN_out(1:M)=x;

for i=1:Len-M
    PN_out(i)=x(1);
    temp=0;
    
    for k=M+1:-1:2
        if Poly_coff(k)==1
            temp=xor(temp,x(M+2-k));
        end
    end
    
    for j=1:M-1
        x(j)=x(j+1);
    end
    x(M)=temp;
end
PN_out(Len-M+1:Len)=x;