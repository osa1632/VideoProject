function w = compBatDist(p,q)
if (size(p,2)~=size(q,2))
    q=repmat(q,1,size(p,2));
end
w=exp(20.*sum(sqrt(q.*p)));


end