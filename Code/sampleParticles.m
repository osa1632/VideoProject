function S_next_tag = sampleParticles(S_prev, C)

N=size(S_prev,2);
r=rand(N,1);
t=repmat(C,N,1)>repmat(r,1,N);
[ro,co]=find(t);
S_next_tag=S_prev(:,accumarray(ro,co,[],@min));


end 
