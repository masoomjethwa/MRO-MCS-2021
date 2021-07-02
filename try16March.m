
clc
clear
tic


D = 'D:\MY33\';
S = dir(fullfile(D,'*'));

N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of D.
tempfdata=[];
% obsdata1=[];

obsdata1=strings(3000,154);
% obsdata=repmat(' ',5000000, 154); %ff=[];
headcombine12=[];
delimiter = ',';
%everything is string untill daemon wakes them 1-15
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
test=[];
for ii = 1:numel(N)
    T = dir(fullfile(D,N{ii},'*.TAB')); % improve by specifying the file extension.
    C = {T(~[T.isdir]).name}; % files in subfolder.
    for jj = 1:numel(C)
       disp(['LoopOrder', num2str(jj)])
        F = fullfile(D,N{ii},C{jj});
% do whatever with file F.
%         F= 'Z:\2021 Temp Den Press Work Long term Var\MRO MCS Data\MROM_2167\2011103100_DDR.TAB';
        filename = F;
        fname=F(69:end-4);
% Open the text file.
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
        fclose(fileID);
% Create output variable
        DDR = [dataArray{1:end-1}];
% Clear temporary variables
        clearvars filename fileID dataArray ans;
% header of the titles
        head1=DDR(1,:);
%         ff=[ff;head1];
% header of the observed data
        head2=DDR(2,:);
        
% header combined (title + obs data)
        headcombine12=[head1,head2];
% new tables for the analysis
        ddr1=DDR(3:end,:);
% number of rows in table
        len1=length(ddr1);
  
% bifurcation of the each orbit data into 106 sets
        iter1=1:106:len1;
% variable declaration to aggregate data
       rlen=length(iter1);
       obsdata=strings(rlen,154);
% final data analysis loop
        for ik=1:length(iter1)
% inceremt of 105 to take 106
            k=iter1(ik)+105;

% desired table to analyse
            temp1=ddr1(iter1(ik):k,:);
            
% exctraction of header values
            temph2=temp1(1,:);
            
% matching # of obs in 1 orbit reshaping head
            temph3=repmat(temph2,105,1);
            
% exctraction of obs table of 1 orbit
            tempd2=temp1(2:end,:);
            
% lookupdata after concat of head and obs
            tempfinal=[temph3,tempd2];
            
            hkm=tempfinal(:,90);
            
            hkmnum=str2double(hkm);
            
            index=(hkmnum > 0);
            
            fddd=tempfinal(index,:);
            fddalt=str2double(fddd(:,90));
            [m11, j11] = min(fddalt);
            obssort=fddd(j11,:);

%             [q1,q2]=size(obssort);
            % final new daat table of all
            obsdata(ik,:)=obssort;
%             tempfdata=[tempfdata;tempfinal];

        end
        test{jj,1}=obsdata;
        %[q1,q2]=size(obsdata);
       % obsdata1(1:q1,:)=obsdata;
        clearvars obssort m11 j11 fddalt fddd index hkmnum hkm tempd2 temph2 temph3
    end
    clearvars ddr1 iter1
    matname=F(4:7);
    save(matname,'headcombine12','test');
    clearvars test matname
end

toc