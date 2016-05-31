function TrackingFunction(filename,outfolder,N,handles)
    if (nargin<1)
        filename='matted.avi';
    end
    if (nargin<2)
        outfolder='./';
    end
    if (nargin<3)
        N=100;
    end
    if (nargin<4)
        useH=false;
    else
        useH=true;
    end
    inputVid = VideoReader(filename);
    trackedVid = VideoWriter(strcat(outfolder,'OUTPUT.avi'));
    trackedVid.Quality = 75;
    open(trackedVid);
    fixRect2S=[1 0 0.5 0;0 1 0 0.5;0 0 0.5 0;0 0 0 0.5];
    fixS2Rect=[1 0 -1 0;0 1 0 -1;0 0 2 0;0 0 0 2];
    
    progress=0;
    if (useH)
        axes( handles.axes2);
        patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
        patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);        set(handles.progress,'String',sprintf('complete %d%%',round(progress*100)));
    else
        progress_bar=waitbar(0,sprintf('complete %d%%',round(progress*100)));
    end
    FrameNumber=(inputVid.NumberOfFrames);
    
    I = inputVid.read(1);
    
    
    if (useH)
        axes( handles.axes1);
    else
        h=figure;
     end  
    imshow(I);title('please mark with rectangle');rect = getrect;
    if (useH)
        cla(handles.axes1);
    else
        close;
    end
        thisFrame = insertShape(I,'rectangle',rect,'color','red');
        trackedVid.writeVideo(thisFrame);
    s_initial =   [fixRect2S*rect.'; 0;0];%[rect 0 0]';
    
    S = predictParticles(repmat(s_initial, 1, N));
    q = compNormHist(I,s_initial);
    p=compNormHist(I,S);
    W=compBatDist(p,q);
    W=W./sum(W,2);
    C=cumsum(W);
    
    pos1=(fixS2Rect*[sum(repmat(W,[2 1]).*S(1:2,:),2);mean(S(3:4,:),2)]).';
    thisFrame = insertShape(I,'rectangle',pos1,'color','blue');
    trackedVid.writeVideo(thisFrame);
    
    for ii=2:FrameNumber
        try
        progress=(ii)/(FrameNumber);
        if (useH)
            axes( handles.axes2);
            patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
            patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);            set(handles.progress,'String',sprintf('complete %d%%',round(progress*100)));
        else
            waitbar(progress,progress_bar,sprintf('complete %d%%',round(progress*100)));
        end
        S_prev = S;
        I = inputVid.read(ii);
        S_next_tag = sampleParticles(S_prev,C);
        S_next = predictParticles(S_next_tag);
        p=compNormHist(I,S_next);
        W=compBatDist(p,q);
        W=W./sum(W,2);
        C=cumsum(W);
        S = sampleParticles(S_next,C);
        pos1=(fixS2Rect*[sum(repmat(W,[ 2 1]).*S(1:2,:),2);mean(S(3:4,:),2)]).';
        thisFrame = insertShape(I,'rectangle',pos1,'color','blue');
        trackedVid.writeVideo(thisFrame);
        catch
            break
        end
    end
    
    close(trackedVid);
    if (~useH)
        close(progress_bar);
    end
    
end