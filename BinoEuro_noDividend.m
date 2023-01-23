function [S,P_Call,P_Put] = BinoEuro_noDividend(S0,K,r,T,N,sigma)

% 计算相关参数
deltaT=T./N;
u=exp(sigma.*sqrt(deltaT));
d=1./u;
q=(exp(r.*deltaT)-d)./(u-d);

% 创建标的资产价格、欧式看涨期权价格零矩阵
S=zeros(N+1,N+1);
P_Call=zeros(N+1,N+1);
P_Put=zeros(N+1,N+1);

% 计算标的资产价格二叉树
for i=1:N+1
    for j=i:N+1     %i<=j,故j从i开始取值
        S(i,j)=u.^(j-i).*d.^(i-1)*S0;
    end
end

% 计算欧式看涨期权价格二叉树
% 因为是欧式期权，所以直接比较最后一期股价和行权价的大小即可
for i=1:N+1
    P_Call(i,N+1)=max(S(i,N+1)-K,0);
end
% 从最后一列逐步折现回第0期
for j=N:-1:1        % 从第N列开始，步长-1，回到第1列（即第0期）
    for i=1:j
        % 若直接从最后一列乘以概率，则概率需要乘以组合数
        %但我们是逐步折现，需要重复计算的地方已经重复计算了，所以不用乘以组合数
        P_Call(i,j)=exp(-r.*deltaT).*(q.*P_Call(i,j+1)+(1-q).*P_Call(i+1,j+1));
    end
end


% 计算欧式看跌期权价格二叉树
% 因为是欧式期权，所以直接比较最后一期股价和行权价的大小即可
for i=1:N+1
    P_Put(i,N+1)=max(K-S(i,N+1),0);
end
% 从最后一列逐步折现回第0期
for j=N:-1:1        % 从第N列开始，步长-1，回到第1列（即第0期）
    for i=1:j
        % 若直接从最后一列乘以概率，则概率需要乘以组合数
        %但我们是逐步折现，需要重复计算的地方已经重复计算了，所以不用乘以组合数
        P_Put(i,j)=exp(-r.*deltaT).*(q.*P_Put(i,j+1)+(1-q).*P_Put(i+1,j+1));
    end
end
end