%-------------------------------------------------------------------------%
% File: lineOrder
% Version: 1.0
%    Wei Xing, Feb.22,2019
% Function: 
%    - Order lines around a selected block in .mdl or slx
%    - Adjust height of block automatically
%    - Names of ports become the same as its corresponding inputs/outputs
%    - The color of constant become green
% Instructions:
%    - Complete the establishment of the corresponding .mdl or .slx
%    - Drag the objective block into suitable position and width by hand
%    - Keep the block selected and run this script
% Attention:
%    - Only valid for blocks with constant inport/outport, from/goto
%    ground/terminator or nothing. If other components exist, please
%    disconnect them firstly
%    - Only one block can be ordered each time
%    - Sometimes there might be deviations. Run again if it occurrs
%-------------------------------------------------------------------------%
%%
clear
clc

%---test only---
const1=1;
const2const2const2const2=2;
%---------------

%% Parameters
boundInLeft=-130;
boundInRight=-100;
boundOutLeft=100;
boundoutRight=130;


%% open system
modelBlock = gcb;
modelBlock_num = strfind(modelBlock,'/');
modelBlock(modelBlock_num(end):end) = [];
modelName=modelBlock;
open_system(modelName)

%% Collect information of all components
InportList = find_system(gcb,'SearchDepth',1,'BlockType','Inport');
OutportList = find_system(gcb,'SearchDepth',1,'BlockType','Outport');

h_blkToConnectList=get_param(gcb,'PortHandles');

FirstInportList = find_system(modelName,'SearchDepth',1,'BlockType','Inport');
FirstOutportList = find_system(modelName,'SearchDepth',1,'BlockType','Outport');
FromList=find_system(modelName,'SearchDepth',1,'BlockType','From');
GotoList=find_system(modelName,'SearchDepth',1,'BlockType','Goto');
GroundList=find_system(modelName,'SearchDepth',1,'BlockType','Ground');
TerminatorList=find_system(modelName,'SearchDepth',1,'BlockType','Terminator');
ConstantList=find_system(modelName,'SearchDepth',1,'BlockType','Constant');

BlockLineHandles=get_param(gcb,'LineHandles');
FirstInportLineHandles=get_param(FirstInportList,'LineHandles');
FirstOutportLineHandles=get_param(FirstOutportList,'LineHandles');
FromLineHandles=get_param(FromList,'LineHandles');
GotoLineHandles=get_param(GotoList,'LineHandles');
GroundLineHandles=get_param(GroundList,'LineHandles');
TerminatorLineHandles=get_param(TerminatorList,'LineHandles');
ConstantLineHandles=get_param(ConstantList,'LineHandles');

%% Adjust the size of gcb
newHight=max(length(InportList),length(OutportList))*40;%hight of main block
gcbSize=get_param(gcb,'Position');
gcbSize(4)=gcbSize(2)+newHight;
if gcbSize(4)>32767
    gcbSize(2)=gcbSize(2)-(gcbSize(4)-32767);
    gcbSize(4)=32767;
end
set_param(gcb,'Position',gcbSize);

% %-----------------------------------input---------------------------------%
% %-------------------------------------------------------------------------%
% %% Order: Constant
% %Match
% xListExs={};
% InportList_x={};
% h_blk_IO=[];
% lena=length(InportList);
% lenb=length(ConstantLineHandles);
% ii=1;
% jj=1;
% while ii<=lena
%     while jj<=lenb
%         if ConstantLineHandles{jj,1}.Outport==BlockLineHandles.Inport(ii)
%             xListExs(end+1,1)=ConstantList(jj);%save:existing outside Constant ports
%             InportList_x(end+1,1)=InportList(ii);%save: Constant ports on block
%             h_blk_IO(end+1,1)=h_blkToConnectList.Inport(ii);%save: info for position
%             
%             ConstantList(jj)=[];
%             ConstantLineHandles(jj)=[];
%             InportList(ii)=[];
%             BlockLineHandles.Inport(ii)=[];
%             h_blkToConnectList.Inport(ii)=[];
%             
%             lena=lena-1;
%             lenb=lenb-1;
%             ii=ii-1;
%             break
%         else
%             jj=jj+1;
%         end
%     end
%     jj=1;
%     ii=ii+1;
% end
% 
% %Get the length of the longest tag
% lgst=0;
% for ii=1:length(xListExs)
%     lgst=max(lgst,strlength(get_param(xListExs{ii},'Value')));
% end
% 
% %order
% for ii=1:length(xListExs)
%     i_in=get_param(h_blk_IO(ii),'Position');
%     i_iny=i_in(2);
%     i_inx=i_in(1);
%     val=get_param(xListExs{ii},'Value');
%     val_len=strlength(val);
%     set_param(xListExs{ii},'Position',[i_inx+boundInLeft-lgst*5 i_iny-10 i_inx+boundInRight i_iny+10]);
%     
% %     set_param(xListExs{ii},'Name',val);%branch name
% %     set_param(InportList_x{ii},'Name',val);%block name
% %     Charac_num = strfind(xListExs{ii,1},'/');
% %     xListExs{ii,1}=[xListExs{ii,1}(1:Charac_num(end)),val];
% 
%     set_param(xListExs{ii},'BackgroundColor','green');
%     h=get_param(xListExs{ii},'LineHandles');
%     try
%         delete_line(h.Outport(1)); % If there has been a line, redraw it; 
%                                    % otherwise draw one directly.
%     end
%     h=get_param(xListExs{ii},'PortHandles');
%     add_line(modelName,h.Outport(1),h_blk_IO(ii),'autorouting','on');
% 
% end
% 
% %% Order: Ground
% %Match
% xListExs={};
% InportList_x={};
% h_blk_IO=[];
% lena=length(InportList);
% lenb=length(GroundLineHandles);
% ii=1;
% jj=1;
% while ii<=lena
%     while jj<=lenb
%         if GroundLineHandles{jj,1}.Outport==BlockLineHandles.Inport(ii)
%             xListExs(end+1,1)=GroundList(jj);%save:existing outside ground ports
%             InportList_x(end+1,1)=InportList(ii);%save: ground ports on block
%             h_blk_IO(end+1,1)=h_blkToConnectList.Inport(ii);%save: info for position
%             
%             GroundList(jj)=[];
%             GroundLineHandles(jj)=[];
%             InportList(ii)=[];
%             BlockLineHandles.Inport(ii)=[];
%             h_blkToConnectList.Inport(ii)=[];
%             
%             lena=lena-1;
%             lenb=lenb-1;
%             ii=ii-1;
%             break
%         else
%             jj=jj+1;
%         end
%     end
%     jj=1;
%     ii=ii+1;
% end
% 
% %Order
% for ii=1:length(xListExs)
%     i_in=get_param(h_blk_IO(ii),'Position');
%     i_iny=i_in(2);
%     i_inx=i_in(1);
%     %-If block name should follow branch name, uncomment following two lines-%
% %     nm=get_param(xListExs{ii},'Name');
% %     set_param(InportList_x{ii},'Name',nm);%block name
%     %------------------------------------------------------------------------%
%     set_param(xListExs{ii},'Position',[i_inx+boundInLeft i_iny-10 i_inx+boundInRight i_iny+10])
%     h=get_param(xListExs{ii},'LineHandles');
%     try
%         delete_line(h.Outport(1)); % If there has been a line, redraw it; 
%                                    % otherwise draw one directly.
%     end
%     h=get_param(xListExs{ii},'PortHandles');
%     add_line(modelName,h.Outport(1),h_blk_IO(ii),'autorouting','on');
% 
% end
% 
% %% Order: FirstInport
% %Match
% xListExs={};
% InportList_x={};
% h_blk_IO=[];
% lena=length(InportList);
% lenb=length(FirstInportLineHandles);
% ii=1;
% jj=1;
% while ii<=lena
%     while jj<=lenb
%         if FirstInportLineHandles{jj,1}.Outport==BlockLineHandles.Inport(ii)
%             xListExs(end+1,1)=FirstInportList(jj);%save:existing outside FirstInport ports
%             InportList_x(end+1,1)=InportList(ii);%save: FirstInport ports on block
%             h_blk_IO(end+1,1)=h_blkToConnectList.Inport(ii);%save: info for position
%             
%             FirstInportList(jj)=[];
%             FirstInportLineHandles(jj)=[];
%             InportList(ii)=[];
%             BlockLineHandles.Inport(ii)=[];
%             h_blkToConnectList.Inport(ii)=[];
%             
%             lena=lena-1;
%             lenb=lenb-1;
%             ii=ii-1;
%             break
%         else
%             jj=jj+1;
%         end
%     end
%     jj=1;
%     ii=ii+1;
% end
% 
% %Order
% for ii=1:length(xListExs)
%     i_in=get_param(h_blk_IO(ii),'Position');
%     i_iny=i_in(2);
%     i_inx=i_in(1);
%     %-If block name should follow branch name, uncomment following two lines-%
% %     nm=get_param(xListExs{ii},'Name');
% %     set_param(InportList_x{ii},'Name',nm);%block name
%     %------------------------------------------------------------------------%
%     set_param(xListExs{ii},'Position',[i_inx+boundInLeft i_iny-8 i_inx+boundInRight i_iny+8])
%     h=get_param(xListExs{ii},'LineHandles');
%     try
%         delete_line(h.Outport(1)); % If there has been a line, redraw it; 
%                                    % otherwise draw one directly.
%     end
%     h=get_param(xListExs{ii},'PortHandles');
%     add_line(modelName,h.Outport(1),h_blk_IO(ii),'autorouting','on');
% 
% end
% 
% 
% %% Order: From
% %Match
% xListExs={};
% InportList_x={};
% h_blk_IO=[];
% lena=length(InportList);
% lenb=length(FromLineHandles);
% ii=1;
% jj=1;
% while ii<=lena
%     while jj<=lenb
%         if FromLineHandles{jj,1}.Outport==BlockLineHandles.Inport(ii)
%             xListExs(end+1,1)=FromList(jj);%save:existing outside From ports
%             InportList_x(end+1,1)=InportList(ii);%save: From ports on block
%             h_blk_IO(end+1,1)=h_blkToConnectList.Inport(ii);%save: info for position
%             
%             FromList(jj)=[];
%             FromLineHandles(jj)=[];
%             InportList(ii)=[];
%             BlockLineHandles.Inport(ii)=[];
%             h_blkToConnectList.Inport(ii)=[];
%             
%             lena=lena-1;
%             lenb=lenb-1;
%             ii=ii-1;
%             break
%         else
%             jj=jj+1;
%         end
%     end
%     jj=1;
%     ii=ii+1;
% end
% 
% %Get the length of the longest tag
% lgst=0;
% for ii=1:length(xListExs)
%     lgst=max(lgst,strlength(get_param(xListExs{ii},'GotoTag')));
% end
% 
% %order
% for ii=1:length(xListExs)
%     i_in=get_param(h_blk_IO(ii),'Position');
%     i_iny=i_in(2);
%     i_inx=i_in(1);
%     tg=get_param(xListExs{ii},'GotoTag');
%     set_param(xListExs{ii},'Position',[i_inx+boundInLeft-lgst*8 i_iny-10 i_inx+boundInRight i_iny+10]);
% %     set_param(InportList_x{ii},'Name',tg);%block name
%     h=get_param(xListExs{ii},'LineHandles');
%     try
%         delete_line(h.Outport(1)); % If there has been a line, redraw it; 
%                                    % otherwise draw one directly.
%     end
%     h=get_param(xListExs{ii},'PortHandles');
%     add_line(modelName,h.Outport(1),h_blk_IO(ii),'autorouting','on');
% 
% end



%-----------------------------------output---------------------------------%
%--------------------------------------------------------------------------%
%% Order: Terminator
%Match
xListExs={};
OutportList_x={};
h_blk_IO=[];
lena=length(OutportList);
lenb=length(TerminatorLineHandles);
ii=1;
jj=1;
while ii<=lena
    while jj<=lenb
        if TerminatorLineHandles{jj,1}.Inport==BlockLineHandles.Outport(ii)
            xListExs(end+1,1)=TerminatorList(jj);%save:existing outside Terminator ports
            OutportList_x(end+1,1)=OutportList(ii);%save: Terminator ports on block
            h_blk_IO(end+1,1)=h_blkToConnectList.Outport(ii);%save: info for position
            
            TerminatorList(jj)=[];
            TerminatorLineHandles(jj)=[];
            OutportList(ii)=[];
            BlockLineHandles.Outport(ii)=[];
            h_blkToConnectList.Outport(ii)=[];
            
            lena=lena-1;
            lenb=lenb-1;
            ii=ii-1;
            break
        else
            jj=jj+1;
        end
    end
    jj=1;
    ii=ii+1;
end

%Order
for ii=1:length(xListExs)
    i_out=get_param(h_blk_IO(ii),'Position');
    i_outy=i_out(2);
    i_outx=i_out(1);
        %-If block name should follow branch name, uncomment following two lines-%
%         nm=get_param(xListExs{ii},'Name');
%         set_param(OutportList_x{ii},'Name',nm);%block name
        %------------------------------------------------------------------------%
        set_param(xListExs{ii},'Position',[i_outx+boundOutLeft i_outy-10 i_outx+boundoutRight i_outy+10])
    h=get_param(xListExs{ii},'LineHandles'); %Handles of lines connected to block.
    try
        delete_line(h.Inport(1));  %
    end
    h=get_param(xListExs{ii},'PortHandles');
    add_line(modelName,h_blk_IO(ii),h.Inport(1),'autorouting','on')
    
end

%% Order: FirstOutport
%Match
xListExs={};
OutportList_x={};
h_blk_IO=[];
lena=length(OutportList);
lenb=length(FirstOutportLineHandles);
ii=1;
jj=1;
while ii<=lena
    while jj<=lenb
        if FirstOutportLineHandles{jj,1}.Inport==BlockLineHandles.Outport(ii)
            xListExs(end+1,1)=FirstOutportList(jj);%save:existing outside FirstOutport ports
            OutportList_x(end+1,1)=OutportList(ii);%save: FirstOutport ports on block
            h_blk_IO(end+1,1)=h_blkToConnectList.Outport(ii);%save: info for position
            
            FirstOutportList(jj)=[];
            FirstOutportLineHandles(jj)=[];
            OutportList(ii)=[];
            BlockLineHandles.Outport(ii)=[];
            h_blkToConnectList.Outport(ii)=[];
            
            lena=lena-1;
            lenb=lenb-1;
            ii=ii-1;
            break
        else
            jj=jj+1;
        end
    end
    jj=1;
    ii=ii+1;
end

%Order
for ii=1:length(xListExs)
    i_out=get_param(h_blk_IO(ii),'Position');
    i_outy=i_out(2);
    i_outx=i_out(1);
    %-If block name should follow branch name, uncomment following two lines-%
%     nm=get_param(xListExs{ii},'Name');
%     set_param(OutportList_x{ii},'Name',nm);%block name
    %------------------------------------------------------------------------%
    set_param(xListExs{ii},'Position',[i_outx+boundOutLeft i_outy-8 i_outx+boundoutRight i_outy+8]);
    h=get_param(xListExs{ii},'LineHandles'); %Handles of lines connected to block.
    try
        delete_line(h.Inport(1));  %
    end
    h=get_param(xListExs{ii},'PortHandles');
    add_line(modelName,h_blk_IO(ii),h.Inport(1),'autorouting','on')
    
end



%% Order: Goto
%Match
xListExs={};
OutportList_x={};
h_blk_IO=[];
lena=length(OutportList);
lenb=length(GotoLineHandles);
ii=1;
jj=1;
while ii<=lena
    while jj<=lenb
        if GotoLineHandles{jj,1}.Inport==BlockLineHandles.Outport(ii)
            xListExs(end+1,1)=GotoList(jj);%save:existing outside Goto ports
            OutportList_x(end+1,1)=OutportList(ii);%save: Goto ports on block
            h_blk_IO(end+1,1)=h_blkToConnectList.Outport(ii);%save: info for position
            
            GotoList(jj)=[];
            GotoLineHandles(jj)=[];
            OutportList(ii)=[];
            BlockLineHandles.Outport(ii)=[];
            h_blkToConnectList.Outport(ii)=[];
            
            lena=lena-1;
            lenb=lenb-1;
            ii=ii-1;
            break
        else
            jj=jj+1;
        end
    end
    jj=1;
    ii=ii+1;
end

%Get the length of the longest tag
lgst=0;
for ii=1:length(xListExs)
    lgst=max(lgst,strlength(get_param(xListExs{ii},'GotoTag')));
end

%Order
for ii=1:length(xListExs)
    i_out=get_param(h_blk_IO(ii),'Position');
    i_outy=i_out(2);
    i_outx=i_out(1);
    tg=get_param(xListExs{ii},'GotoTag');
    set_param(xListExs{ii},'Position',[i_outx+boundOutLeft i_outy-10 i_outx+boundoutRight+lgst*8 i_outy+10]);
%     set_param(OutportList_x{ii},'Name',tg);
    h=get_param(xListExs{ii},'LineHandles'); %Handles of lines connected to block.
    try
        delete_line(h.Inport(1));  %
    end
    h=get_param(xListExs{ii},'PortHandles');
    add_line(modelName,h_blk_IO(ii),h.Inport(1),'autorouting','on')
    
end



