% -------------------------------------------------------------------------
%%% STABILIZE VIDEO
function Stabilize_function( inputVidFN,OutputFolder,  L,handles )
    if (nargin<4)
        useH=false;
    else
        useH=true;
    end
inputVid=VideoReader(inputVidFN);
outputVid=VideoWriter(strcat(OutputFolder,'stabilized.avi'));
outputVid.Quality = 75;
outputVid.open();
N = inputVid.NumberOfFrames;
vidH=inputVid.Height;
vidW=inputVid.Width;
roi=zeros(vidH,vidW);
m=10;
roi(m:vidH-m,m:vidW-m)=ones(vidH-2*m+1,vidW-2*m+1);
%%% ESTIMATE PAIRWISE MOTION
Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];
 progress=0;
    if (useH)
        axes( handles.axes2);
        patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
        patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);
        set(handles.progress,'String',sprintf('complete %d%%',round(progress*100)));
    else
        progress_bar=waitbar(0,sprintf('complete %d%%',round(progress*100)));
    end
    
currFrame=rgb2hsv(inputVid.read(1));
stableCurrFrame(:,:,1)=currFrame(:,:,1);
stableCurrFrame(:,:,2)=currFrame(:,:,2);
stableCurrFrame(:,:,3)=currFrame(:,:,3);

outputVid.writeVideo(hsv2rgb(stableCurrFrame));
    prevFrame=currFrame;

for ii = 2 : N
    
    try
        
  %  prevFrame=currFrame;
    currFrame=rgb2hsv(inputVid.read(ii));
[A,T] = optical_flow( currFrame(:,:,3), prevFrame(:,:,3), roi, L );
%[Acum,Tcum] = accumulate_warp( Acum, Tcum, A, T );
%roi = warp( roi, A, T );
stableCurrFrame = warp( currFrame, A,T);%Acum, Tcum );
% stableCurrFrame(:,:,2) = warp( currFrame(:,:,2), Acum, Tcum );
% stableCurrFrame(:,:,3) = warp( currFrame(:,:,3), Acum, Tcum );
%roiRGB=repmat(roi,[1 1 3]);
outputVid.writeVideo(hsv2rgb(stableCurrFrame));
% imshow(hsv2rgb(stableCurrFrame))
        progress=ii/inputVid.NumberOfFrames ;

        if (useH)
            axes( handles.axes2);
            patch([0,progress,progress,0],[0,0,1,1],'b');
            set(handles.progress,'String',sprintf('complete %d%%',round(progress*100)));
        else
            waitbar(progress,progress_bar,sprintf('complete %d%%',round(progress*100)));
        end
% if (mod(k,10)==0)
%     figure
%     imshow(hsv2rgb(stableCurrFrame));title(num2str(k));
% end
 catch
        break
    end
end
close(outputVid)
    if (~useH)
    close(progress_bar);
    end
% %%% STABILIZE TO LAST FRAME
% stable(N).im = frames(N).im;
% Acum = [1 0 ; 0 1];
% Tcum = [0 ; 0];
% for k = N-1 : -1 : 1
%     disp(k)
% [Acum,Tcum] = accumulate_warp( Acum, Tcum, motion(k).A, motion(k).T );
% stable(k).im = warp( frames(k).im, Acum, Tcum );
% end
% -------------------------------------------------------------------------
%%% ALIGN TWO FRAMES (f2 to f1)
function[ Acum, Tcum ] = optical_flow( f1, f2, roi, L )
f2orig = f2;
Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];
for k = L : -1 : 0
%%% DOWN-SAMPLE
f1d = down( f1, k );
f2d = down( f2, k );
ROI = down( roi, k );
%%% COMPUTE MOTION
[Fx,Fy,Ft] = space_time_deriv( f1d, f2d );
[A,T] = compute_motion( Fx, Fy, Ft, ROI );
T = 2^k * T;
[Acum,Tcum] = accumulate_warp( Acum, Tcum, A, T );
%%% WARP ACCORDING TO ESTIMATED MOTION
f2 = warp( f2orig, Acum, Tcum );
end
% -------------------------------------------------------------------------
%%% COMPUTE MOTION
function[ A, T ] = compute_motion( fx, fy, ft, roi )
[ydim,xdim] = size(fx);
[x,y] = meshgrid( [1:xdim]-xdim/2, [1:ydim]-ydim/2 );
%%% TRIM EDGES
fx = fx( 3:end-2, 3:end-2 );
fy = fy( 3:end-2, 3:end-2 );
ft = ft( 3:end-2, 3:end-2 );
roi = roi( 3:end-2, 3:end-2 );
x = x( 3:end-2, 3:end-2 );
y = y( 3:end-2, 3:end-2 );
ind = find( roi > 0 );
x = x(ind); y = y(ind);
fx = fx(ind); fy = fy(ind); ft = ft(ind);
xfx = x.*fx; xfy = x.*fy; yfx = y.*fx; yfy = y.*fy;
k = ft + xfx + yfy;
M=[xfx yfx xfy yfy fx fy].'*[xfx yfx xfy yfy fx fy];
b=k.'*[xfx yfx xfy yfy fx fy];
try
v = M\ b.';
catch
    v = pinv(M)* b.';
end
A = [v(1) v(2) ; v(3) v(4)];
T = [v(5) ; v(6)];

% -------------------------------------------------------------------------
%%% WARP IMAGE
function[ f2 ] = warp( f, A, T )
[ydim,xdim,channels] = size( f );
[xramp,yramp] = meshgrid( [1:xdim]-xdim/2, [1:ydim]-ydim/2 );
P = [xramp(:).' ; yramp(:).'];
P = A * P;
xramp2 = reshape( P(1,:), ydim, xdim ) + T(1);
yramp2 = reshape( P(2,:), ydim, xdim ) + T(2);
f2=zeros(size(f));
for ch=1:channels
f2(:,:,ch) = interp2( xramp, yramp, f(:,:,ch), xramp2, yramp2, 'linear' ); % warp
end
ind = find( isnan(f2) );
f2(ind) = 0;
% -------------------------------------------------------------------------
%%% BLUR AND DOWNSAMPLE (L times)
function[ f ] = down( f, L );
blur = [1 2 1]/4;
for k = 1 : L
f = conv2( conv2( f, blur, 'same' ).', blur, 'same' );
f = f(1:2:end,1:2:end);
end
% -------------------------------------------------------------------------
%%% SPACE/TIME DERIVATIVES
function[ fx, fy, ft ] = space_time_deriv( f1, f2 )
%%% DERIVATIVE FILTERS
pre = [0.5 0.5];
deriv = [0.5 -0.5];
%%% SPACE/TIME DERIVATIVES
fpt = pre(1)*f1 + pre(2)*f2; % pre-filter in time
fdt = deriv(1)*f1 + deriv(2)*f2; % differentiate in time
fx = conv2( conv2( fpt, pre', 'same' ), deriv, 'same' );
fy = conv2( conv2( fpt, pre, 'same' ), deriv', 'same' );
ft = conv2( conv2( fdt, pre', 'same' ), pre, 'same' );
% -------------------------------------------------------------------------
%%% ACCUMULATE WARPS
function[ A2, T2 ] = accumulate_warp( Acum, Tcum, A, T )
A2 = A * Acum;
T2 = A*Tcum + T;