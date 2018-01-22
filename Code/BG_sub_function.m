function  BG_sub_function(StableVidName,OutFolder,TH_H,TH_S,TH_V,handles)
%% =======================    Calc Background BG  ===========================================
    if nargin <5  
        TH_H=0.8;TH_S=0.6;TH_V=0.35;% to HSV min TH=[0.95,0.08,0.05] rubat [1,0.2,0.15]
        StableVidName='../../Code_2/stabi_vid_me_f.avi';
        OutFolder='./';
    end
    if (nargin<6)
        useH=false;
    else
        useH=true;
    end
    inputVid = VideoReader(StableVidName);
    sampling_ratio=10;
    [xf,yf,cf]=size(inputVid.read(1));
    VidArr=(zeros(xf,yf,cf,sampling_ratio));
    jj=1;
    for ii=linspace(1,inputVid.NumberOfFrames,sampling_ratio)
        progress=jj/(sampling_ratio+1);
        if (useH)
            axes( handles.axes2);
            patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
            patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);
            set(handles.progress,'String',sprintf('init complete %d%%',round(progress*100)));
        else
            progress_bar=waitbar(progress,sprintf('init complete %d%%',round(progress*100)));
        end
        VidArr(:,:,:,jj) = im2double(4*(inputVid.read(ii)/4));
        jj=jj+1;
    end
    %%make BG
    if (~useH)
        close(progress_bar);
    end
    BG=median(VidArr,4);
    %     load('meBG')
    
    clear VidArr
    TH=[TH_H,TH_S,TH_V];
    
    % BG=median(VidArr,4);
    BinaryOutName=strcat(OutFolder,'binary.avi');
    maskVid = VideoWriter(BinaryOutName);
    maskVid.Quality = 75;
    open(maskVid);
    
    ExtractedName=strcat(OutFolder,'extracted.avi');
    outputVid = VideoWriter(ExtractedName);
    outputVid.Quality = 75;
    open(outputVid);
    
    %do each frame
    
    for ii=1:inputVid.NumberOfFrames;
        progress=ii/inputVid.NumberOfFrames;
        if (useH)
            axes( handles.axes2);
            patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
            patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);
            set(handles.progress,'String',sprintf('complete %d%%',round(progress*100)));
        else
            progress_bar=waitbar(progress,sprintf('complete %d%%',round(progress*100)));
        end
        
        %%
        %nighbor pixle comper
        im=4*(inputVid.read(ii)/4);
        
        BW=any(abs(double(rgb2hsv(im)-double(rgb2hsv(BG))))>repmat(reshape(TH,[1 1 3]),[xf,yf,1]),3);
        BW=imerode(imdilate(BW,strel('disk',15)),strel('disk',15));
        CC=bwconncomp(BW,8);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [~,p_maxVal]=max(numPixels);
        BW2=zeros(size(BW));
        BW2(CC.PixelIdxList{p_maxVal})=1;
        BW2=imfill(BW2,8,'holes');
        maskVid.writeVideo(double(BW2));
        outputVid.writeVideo(im2double(im).*double(repmat(BW2,[1 1 3])));
    end
    if (~useH)
        close(progress_bar);
    end
    close(outputVid);
    close(maskVid);
end