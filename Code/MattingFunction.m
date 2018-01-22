function MattingFunction(StabVid_fn,MaskVid_fn,newBG_fn,OutFolder,WinSizeBGFG,Rho4Undecided,r,Def_NumberOfScribllePoints,handles)
    if (nargin<1)
        StabVid_fn='stabilized.avi';
    end
    if (nargin<2)
        MaskVid_fn='binary.avi';
    end
    if (nargin<3)
        newBG_fn='background.jpg';
    end
    if (nargin<4)
        OutFolder='./';
    end
    if (nargin<5)
        WinSizeBGFG=10;
        r=2;
        Rho4Undecided=25;
        Def_NumberOfScribllePoints=1000;
    end
    if (nargin<9)
        useH=false;
    else
        useH=true;
    end
    WinSize=3;
    progress=0;
    if (useH)
        axes( handles.axes2);
        patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
        patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);
        set(handles.progress,'String',sprintf('initialization- complete %d%%',round(progress*100)));
    else
        progress_bar=waitbar(0,sprintf('initialization- complete %d%%',round(progress*100)));
    end
    [B,StabVid,MaskVid,mattingVid,BG_density,FG_density]=initializiation(newBG_fn,StabVid_fn,MaskVid_fn,OutFolder,WinSizeBGFG,Def_NumberOfScribllePoints);
    progress=1 ;
    if (useH)
        axes( handles.axes2);
        patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
        patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);
        set(handles.progress,'String',sprintf('initializiton- complete %d%%',round(progress*100)));
    else
        waitbar(progress,progress_bar,sprintf('initializiton- complete %d%%',round(progress*100)));
        close(progress_bar);
    end
    F=StabVid.read(1);
    B=imresize(B,[size(F,1),size(F,2)]);
    progress=0;
    
    if (useH)
        axes( handles.axes2);
        patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
        patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);
        set(handles.progress,'String',sprintf('complete %d%%',round(progress*100)));
    else
        progress_bar=waitbar(0,sprintf('complete %d%%',round(progress*100)));
        
    end
    
    for ii=1:StabVid.NumberOfFrames
        try
            progress=(ii)/(StabVid.NumberOfFrames);
            
            if (useH)
                axes( handles.axes2);
                patch([0 1 1 0],[0 0 1 1],[1 1 1],'EdgeColor',[0 0 0]);hold on;
                patch([0 progress progress 0],[0 0 1 1],[0 0 1],'EdgeColor',[0 0 0]);            set(handles.progress,'String',sprintf('complete %d%%',round(progress*100)));
            else
                waitbar(progress,progress_bar,sprintf('complete %d%%',round(progress*100)));
            end
            F=StabVid.read(ii);
            F_HSV=rgb2hsv(F);
            F_VfromHSV=F_HSV(:,:,1);
            Mask=MaskVid.read(ii);
            Mask=double(Mask(:,:,1)~=0);
            
            F_VfromHSV=round(255*F_VfromHSV);
            Alpha=CreateTriMap(F_VfromHSV,Mask,BG_density,FG_density,Rho4Undecided);
            
            Alpha=RefinementMask(Alpha,F_VfromHSV,r);
            
            newF_VfromHSV=blendColor(F_VfromHSV,Alpha,WinSize);
            B_HSV=rgb2hsv(B);
            %         Alpha(Alpha>1)=1;
            %         Alpha(Alpha<0)=0;
            Alpha(Alpha<0)=0;
            Alpha(Alpha>1)=1;
            Alpha_hsv=repmat(Alpha,[1 1 3]);
            matHSV=Alpha_hsv.*F_HSV+(1-Alpha_hsv).*B_HSV;
            matHSV(:,:,1)=(Alpha.*newF_VfromHSV/255+(1-Alpha).*(B_HSV(:,:,1)));
            mat=hsv2rgb(matHSV);
            mattingVid.writeVideo(mat);
        catch
            break
        end
    end
    if (~useH)
        close(progress_bar);
    end
    close(mattingVid);
    
end


function [newBG,StabVid,MaskVid,mattingVid,BG_density,FG_density]=initializiation(newBG_fn,StabVid_fn,MaskVid_fn,OutFolder,WinSizeBGFG,Def_NumberOfScribllePoints)
    newBG=imread(newBG_fn);
    StabVid = VideoReader(StabVid_fn);
    MaskVid = VideoReader(MaskVid_fn);

    MattingVid_fn =strcat(OutFolder,'matted.avi');
    mattingVid = VideoWriter(MattingVid_fn);
    mattingVid.Quality = 75;
    open(mattingVid);
    
    im=StabVid.read(1);
    Mask1=MaskVid.read(1);
    Mask1=im2double(Mask1(:,:,1));
    [~,~,imV]=rgb2hsv(im);
    %Mask1Bg=imdilate(Mask1,strel('disk',WinSizeBG+WinSizeFG,8));

    Mask1BG=~imdilate(Mask1,strel('disk',WinSizeBGFG,8));
    BGImage=Mask1BG.*imV;
    
    Mask1FG = Mask1 & ~imdilate(bwperim(Mask1,8), strel('disk', WinSizeBGFG,8));
    FGImage=Mask1FG.*imV;
    BG_Scriblle = datasample(uint8(255*BGImage(:)),Def_NumberOfScribllePoints,'Weights',1*~Mask1FG(:));
    FG_Scriblle    = datasample(uint8(255*FGImage(:)),Def_NumberOfScribllePoints,'Weights',1*~Mask1BG(:));

    [~,BG_density,~,~]=kde(BG_Scriblle,256,0, 255);
    [~,FG_density,~,~]=kde(FG_Scriblle,256,0, 255);
    
end

function [Alpha]=CreateTriMap(F,Mask,BG,FG,Rho4Undecided)
        BG_im_Prob=BG(F(:)+1);
        FG_im_Prob=FG(F(:)+1);
        
   
        %calc probabilities
        BG_Prob=BG_im_Prob./(BG_im_Prob+FG_im_Prob);
        FG_Prob=FG_im_Prob./(BG_im_Prob+FG_im_Prob);
        

       Maske=imerode(Mask,strel('disk',round(Rho4Undecided/1.4),8));
        
        
        diffPerim = imdilate(Maske, strel('disk', Rho4Undecided,8))-Maske;%enlarge perim space by rho
        %diffPerim=Maskd-Maske;
        
        BG_Prob=reshape(BG_Prob,size(F));
        FG_Prob=reshape(FG_Prob,size(F));
        
        BG_Perim=diffPerim.*BG_Prob;
        FG_Perim=diffPerim.*FG_Prob;
    
        Perim_prob=FG_Perim./(FG_Perim+BG_Perim);
        Perim_prob(isnan(Perim_prob))=0;
        Perim_Ind=find(abs(Perim_prob)>min(2*abs(min(min(Perim_prob))),0.2*abs(max(max(Perim_prob)))));
        
        Alpha=Mask;
        Alpha(Perim_Ind)=Perim_prob(Perim_Ind);

end


function [Alpha,FG,BG]=RefinementMask(Mask,F,r)
    Alpha=Mask;
    MaskFG=(imdilate(Mask<1,ones(15))-(Mask<1));
    MaskBG=((Mask>0)-imerode(Mask>0,ones(15)));

    [~,FG,~,~]=kde(reshape(MaskFG.*F,[numel(F),1]),256,0, 255);
    [~,BG,~,~]=kde(reshape(MaskBG.*F,[numel(F),1]),256,0, 255);
    
    BG_im_dist=graydist(F,find(MaskBG));
    FG_im_dist=graydist(F,find(MaskFG));
    BG_im_Prob=BG_im_dist((Mask>0 & Mask<1)).^(-r).*BG(F(Mask>0 & Mask<1)+1);
    FG_im_Prob=FG_im_dist((Mask>0 & Mask<1)).^(-r).*FG(F(Mask>0 & Mask<1)+1);
    
    Alpha((Mask>0 & Mask<1))=FG_im_Prob./(BG_im_Prob+FG_im_Prob);
    
    Alpha(isnan(Alpha))=1;

    
end

function F=blendColor(F,Alpha,WinSize)
    [x1,y1]=ind2sub(size(Alpha),find(Alpha>0));
    [X,Y]=size(F);
    lc=max(min(x1),WinSize+1);
    rc=min(max(x1),X-WinSize);
    tc=max(min(y1),1+WinSize);
    bc=min(max(y1),Y-WinSize);
    cropF=F(lc-WinSize:rc+WinSize,tc-WinSize:bc+WinSize);
    cropAlpha=Alpha(lc-WinSize:rc+WinSize,tc-WinSize:bc+WinSize);
    nhoodF=zeros([size(cropF),(2*WinSize+1).^2]);
    nhoodF_tofindmax=zeros([size(cropF),2*WinSize+1]);
    [NR,NC]=meshgrid(-WinSize:WinSize,-WinSize:WinSize);
    for ii=1:(2*WinSize+1)
        nhoodF(:,:,ii)=cropAlpha.*imshift(cropF,NR(ii),NC(ii));
        nhoodF_tofindmax(:,:,ii)=cropAlpha-(cropAlpha.*imshift(cropF,NR(ii),NC(ii)));
    end
    
    
    [~,ind]=min(nhoodF_tofindmax,[],3);
    val_argmax=nhoodF(sub2ind([size(cropF,1)*size(cropF,2) 2*WinSize+1],1:size(cropF,1)*size(cropF,2) ,ind(:).'));
    F(lc-WinSize:rc+WinSize,tc-WinSize:bc+WinSize)=reshape(val_argmax,size(cropF)).*cropAlpha+~cropAlpha.*cropF;

end

