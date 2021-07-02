
clc
clear
tic
head1={"OCCULTATION TIME","SOLAR LONGITUDE","LOCAL TRUE SOLAR TIME OF OCCULTATION","SOLAR ZENITH ANGLE","LATITUDE","LONGITUDE","Alt (km)","PRESSURE (PASCAL)","SIGMA PRESSURE","TEMPERATURE(KELVIN)","SIGMA TEMPERATURE","NUMBER DENSITY (1 PER CUBIC CM)","SIGMA NUMBER DENSITY"};

D = 'Z:\2021 Temp Den Press Work Long term Var\MRO MCS Data\';
S = dir(fullfile(D,'*'));

N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of D.
headcombine12=[]; tempfdata=[]; obsdata=[]; thead=[];
for ii = 1:numel(N)
    T = dir(fullfile(D,N{ii},'*.TAB')); % improve by specifying the file extension.
    C = {T(~[T.isdir]).name}; % files in subfolder.
    for jj = 1:numel(C)
        jj
        F = fullfile(D,N{ii},C{jj});
        % do whatever with file F.
%         F= 'Z:\2021 Temp Den Press Work Long term Var\MRO MCS Data\MROM_2167\2011103100_DDR.TAB';
        filename = F;
        fname=F(66:end-4);
        delimiter = ',';
        %everything is string untill daemon wakes them 1-15
        formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
        % Open the text file.
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
        fclose(fileID);
        % Create output variable
        DDR = [dataArray{1:end-1}];
        % Clear temporary variables
        clearvars filename delimiter formatSpec fileID dataArray ans;
        % header of the titles
        head1=DDR(29,:);
        
        % header of the observed data
        head2=DDR(30,:);
        
        % header combined (title + obs data)
        headcombine12=[head1,head2];
        headcombine12=thead;
        % new tables for the analysis
        ddr1=DDR(31:end,:);
        
        clearvars DDR
        
        % number of rows in table
        len1=length(ddr1);
        
        % bifurcation of the each orbit data into 106 sets
        iter1=1:106:len1;
        
        % variable declaration to aggregate data
        tempfdata=[]; obsdata=[]; tempfdata=[];
        
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
            
            % final new daat table of all
            obsdata=[obsdata;obssort];
%             tempfdata=[tempfdata;tempfinal];
            clearvars obssort m11 j11 fddalt fddd index hkmnum hkm tempd2 temph2 temph3
            
        end
        clearvars ddr1
    
    end
end
% temphfdata=[headcombine12;tempfdata];
finaldata1=[thead;obsdata];


% imp1=[temphfdata(:,2),temphfdata(:,5),temphfdata(:,7),temphfdata(:,11:13),temphfdata(:,15),temphfdata(:,79:92)];
imp2=[finaldata1(:,2),finaldata1(:,5),finaldata1(:,7),finaldata1(:,11:13),finaldata1(:,15),finaldata1(:,79:92)];


% save('mrom2167','temphfdata','finaldata1','imp1','imp2')
save('try1','finaldata1','imp2')
        % clear
        

toc