%Cubic 内插器
function output=CubicInterpolate(mu,m_data)
%cubic内插系数
kTapCubic3=[0 0 1 0];
kTapCubic2=[-1/6 1 -1/2 -1/3];
kTapCubic1=[0 1/2 -1 1/2];
kTapCubic0=[1/6 -1/2 1/2 -1/6];

m_branch0=sum(kTapCubic0(length(kTapCubic0):-1:1).*m_data);
m_branch1=sum(kTapCubic1(length(kTapCubic1):-1:1).*m_data);
m_branch2=sum(kTapCubic2(length(kTapCubic2):-1:1).*m_data);
m_branch3=sum(kTapCubic3(length(kTapCubic3):-1:1).*m_data);

output=((m_branch0*mu+m_branch1)*mu+m_branch2)*mu+m_branch3;
