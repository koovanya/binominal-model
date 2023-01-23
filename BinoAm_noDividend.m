function [S,P_Call,P_Put] = BinoAm_noDividend(S0,K,r,T,N,sigma)

% 计算相关参数
deltaT=T./N;
u=exp(sigma.*sqrt(deltaT));
d=1./u;
q=(exp(r.*deltaT)-d)./(u-d);

% 创建标的资产价格、美式看涨和看跌期权价格零矩阵
S=zeros(N+1,N+1);
P_Call=zeros(N+1,N+1);
P_Put=zeros(N+1,N+1);

% 计算标的资产价格二叉树
for i=1:N+1
    for j=i:N+1     %i<=j,故j从i开始取值
        S(i,j)=u.^(j-i).*d.^(i-1)*S0;
    end
end

% 计算美式看涨期权价格二叉树
for i=1:N+1
    for j=i:N+1
        P_Call(i,j)=max(S(i,j)-K,0);
    end
end
% 比较是当期payoff大还是后一期payoff的加权平均的折现值大，取较大值
for j=N:-1:1
    for i=1:j
        P_Call(i,j)=max(P_Call(i,j),exp(-r.*deltaT).*(q.*P_Call(i,j+1)+(1-q).*P_Call(i+1,j+1)));
    end
end

% 计算美式看跌期权价格二叉树
for i=1:N+1
    for j=i:N+1
        P_Put(i,j)=max(K-S(i,j),0);
    end
end
% 比较是当期payoff大还是后一期payoff的加权平均的折现值大，取较大值
for j=N:-1:1
    for i=1:j
        P_Put(i,j)=max(P_Put(i,j),exp(-r.*deltaT).*(q.*P_Put(i,j+1)+(1-q).*P_Put(i+1,j+1)));
    end
end

end