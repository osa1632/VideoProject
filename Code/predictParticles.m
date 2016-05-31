function S_next = predictParticles(S_next_tag)

S_next= S_next_tag;
N=size(S_next_tag,2);
S_next(1:2,:)=S_next(1:2,:)+S_next(5:6,:);%S_next(5:6,:)
rand_c_v=normrnd(0,1,[6 N]);%2*(rand(6,N)-0.5);
velocity=[mean(S_next_tag(5,:));mean(S_next_tag(6,:))];
%dcenter=[-1:1]*v
%dv=4*[-1:1]*v
dcenter=round(rand_c_v(1:2,:).*repmat(velocity,1,N));
new_rect=zeros(2,N);
new_velocity=4*round(rand_c_v(5:6,:));
noise=[dcenter;new_rect;new_velocity];
S_next=S_next+noise;



end

%ceil(2*(rand(2,N)-0.5)).*repmat([mean(S_next_tag(5,:));mean(S_next_tag(6,:))],1,N);

