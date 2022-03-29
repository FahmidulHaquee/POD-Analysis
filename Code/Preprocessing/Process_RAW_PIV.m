%the purpose of this code is as follows:
%1.process the RAW piv data analysis into a recognisable array
%2.normalize x and y coordinates into a 0-1 scale
%3.re-organize matrix of data and average avalues
%4.create an individual probe cell-array of tables
%5.Calculate Velocity Magnitude (x and y vectors)

%5.b Adjust to match CFD image set
%6. Calculate RMS value
%7. Calculate TKE value
%8.save the resulting workplace data variables


        %CHECK PREDETERMINED VARIABLES (MODIFY IF REQUIRED):

%adjust PIV images to match CFD count (Yes or No)
adjust = 'No';  
adjustVal = 500;       
        
        
%number of images acquired
n = [];
%define starting number of your images or vec files
io = 0;
%save location
savefilepath = 'C:\Users\Fahmidul\Research Project\Data\Processed PIV';   
%Determine permanent run P value or leave blank for prompt:
Pval = [];
%diameter of impeller (m)
dImp = 0.1;
%dynamic viscosity of water
dynVisc = [];
%tank inner diameter
tankDia = [];


        %END OF PREDETERMINED VARIABLES
        
        
%check if savefile path is valid, if not request new filepath
if exist(savefilepath, 'dir')
else
    promptFail = 'Save filepath does not exist (line 19), please enter a valid save location: ';
    savefilepath = input(promptFail, 's');
end
%main directory request: changes based on current experiment
%example of directory path: F:\PhD Working Files\Experiments\PIV\March 2020 - Igor\100RPM CT1_3 h20 no baffles\Analysis
promptfolder = 'Input analysis folder path (example line 33): ';
folder = input(promptfolder,'s');

%name of experiment: changes based on current experiment
%example of run name: 100RPM CT1_3 h20 no baffles
promptrun = 'Input run name (example line 38): ';
run = input(promptrun,'s');

%rotation of impeller
promptRPM = 'Input RPM: ';
RPM = input(promptRPM,'s');

%determine if number of images is entered    
if isempty(n)
   promptnstr = 'Enter number of images:  ';
   nstr = input(promptnstr, 's');
   n = str2double(nstr);
   imageC = n;
else
end


%determine if value of P has been entered, if not requests P value    
if isempty(Pval)
   promptPval = 'Enter value of P (permanent entry line 21):  ';
   Pval = input(promptPval, 's');
else
end
numericalIdentifier = ['.T000.D000.P',Pval,'.H000.L.vec']; 
filename = [folder,'\',run,'000000',numericalIdentifier];

%determine adjustment has been defined, if not request it    
% if matches (adjust,'Yes')
%   if isempty(adjustVal)
%    answer = questdlg('Adjust PIV image count to match CFD through averaging?','Yes','No');
%    switch answer
%        case 'Yes'
%            promptCFDsize = 'Enter CFD image set size:  ';
%            adjustVal = input(promptCFDsize);
%        case 'No'
%        adjust = 'No';
%        case 'Cancel'
%            return
%    end
%   end
% else
% end

        %1.Process RAW PIV
        

%call base variables and structures
yy(:,:,:) = csvread(filename,1,0);% 4 if 5 above; 8 if 9 above

szyy = size(yy);
npt = szyy(1,1);
baseValues = zeros(npt,5,n);

for i = 1 : n
    j=(io-1)+i;   %check T000.D000.P000 according to your imageor vec files
    if j <= 9
    filename = [folder,'\',run,'00000',int2str(j),numericalIdentifier];
    elseif 100 > j && j >= 10
    filename = [folder,'\',run,'0000',int2str(j),numericalIdentifier];
    elseif 1000 > j && j > 99
    filename = [folder,'\',run,'000',int2str(j),numericalIdentifier];
    else
    filename = [folder,'\',run,'00',int2str(j),numericalIdentifier];
    end
    baseValues(:,:,i) = csvread(filename,1,0,[1 0 npt 4]);% 4 if 5 above; 8 if 9 above
    CHC = baseValues(:,5,i);
    for val = 1 : npt
        if CHC(val)<=0
           baseValues(val,3,i) = nan;
           baseValues(val,4,i) = nan;
           CHC(val)= nan;
        end
    end
end

        %2.Normalize x and y coordinates
        
%create normalised base variable     
normalisedbaseValues = baseValues;        
%total amount of timesteps
n = size(normalisedbaseValues,3);
%calling cell to reduce computation time
CurrentArray = cell(1,n);

%maximum range and determination of origin direction
xin=-2000;
xout=2000;
yin=2000;
yout=-2000;

for j = 1:n
    
    CurrentArray{j} = normalisedbaseValues(:,:,j);
    CAx = CurrentArray{j}(:,1);
    CAy = CurrentArray{j}(:,2);
    
    xmin = min(CAx);
    xmax = max(CAx);
    ymin = min(CAy);
    ymax = max(CAy);
    
    
    sx=find(xin < CAx & CAx < xout);

    sxy=CAy(sx);

    sx=CAx(sx);
    sy=find(yout < sxy & sxy < yin);

    syx=sx(sy);
    syxmin=min(syx);
    syxmax=max(syx);
    syxadm=(syx-syxmin)/(syxmax-syxmin);


    sy=sxy(sy);
    symin=min(sy);
    symax=max(sy);
    syadm=(sy-symin)/(symax-symin);

    normalisedbaseValues(:,:,j) = [syxadm syadm CurrentArray{j}(:,3) CurrentArray{j}(:,4) CurrentArray{j}(:,5)];
    
end


        %3.Create table of average values
        
        
meanArray = nanmean(normalisedbaseValues,3);
meanTable = array2table(meanArray, 'VariableNames',{'x mm', 'y mm', 'avg vel x', 'avg vel y','CHC'});

        %4.Create cell-array of tables
        
        
%Permute normalisedbaseValues array
permBase = permute(normalisedbaseValues,[3,2,1]);

%total amount of individual probes
n = size(permBase,3);
%calling cell to reduce computation time
CellTableArray = cell(n,1);


for y = 1:n
     
    CellTableArray{y} = strcat('F', num2str(y));
    CellTableArray{y} = permBase(:,:,y);
    CellTableArray{y} = array2table(CellTableArray{y}, 'VariableNames', {'x mm', 'y mm', 'inst vel x', 'inst vel y', 'CHC'});
    
end

        %5. Calculate Velocity Magnitude
        
%acquire total amount of data points        
npt = size(baseValues,1);

%calculate Utip speed
RPMv = str2double(RPM);
Utip = (dImp*pi*RPMv)/60;

Mag = cell(npt,1);

for d = 1:npt
tempMagArray = table2array(CellTableArray{d}); 
Cnpt = size (tempMagArray,1);

tempnumX=find(tempMagArray(:,2)== tempMagArray(1,2));
sztempnumX = size(tempnumX);

numX=sztempnumX(1,1); 
numY=Cnpt/numX;

sz = size(tempMagArray);
sz = sz(1,1);

Mag{d}=zeros(sz,1);
Magx=zeros(sz,1);
Magy=zeros(sz,1);


for i = 1:sz
Magx(i,1) = tempMagArray(i,3);
Magy(i,1) = tempMagArray(i,4);
Mag{d}(i,1) = (((tempMagArray(i,3))^2)+((tempMagArray(i,4))^2))^(1/2);
end

sM=zeros(numY,numX);
sMx=zeros(numY,numX);
sMy=zeros(numY,numX);
X=tempMagArray(:,1);
Y=tempMagArray(:,2);
U=tempMagArray(:,3);
V=tempMagArray(:,4);


Xcount=X(1:numX,1);
Xcount=Xcount';
Ycount=Y(1:numX:sz,1);

Norm = (Mag{d}./Utip); %generates normalised velocity matrix
magmax = max(Norm);


szMy0=0;
j=numY;
for i=1:(numY-1)
    
    szMy=(szMy0+1);
    smy=tempMagArray(szMy,2);
    Ym=find(tempMagArray(:,2)==smy);
    MagM=Norm(Ym,1);
    MagMx=Magx(Ym,1);
    MagMy=Magy(Ym,1);
    sMx(j,:)=MagMx';
    sMy(j,:)=MagMy';
    sM(j,:)=MagM';
  j=numY-i;
szMy0=numX*i+1;
end
end
        %5.b. Adjust to match CFD image Set
        
if matches (adjust,'Yes')
 
avgAmount = imageC / adjustVal;
fp = 0;
    
%Magnitude variables creation    
Mag_adj = cell(npt,1);
magTot = zeros(avgAmount,1);

%Cell table array variables creation
Cell_adj = cell(npt,1);
szCellC = size(baseValues,2);
cellTot = zeros(avgAmount,szCellC);
CellTable_final = cell(npt,1);


for y = 1:npt
    
count = 1;
magTemp = Mag{y};
cellTemp = CellTableArray{y};

for d = 1:adjustVal
    
    for z = 1:avgAmount
    v = count + z - 1;
    
    magTot(z,1) =  magTemp(v,1);  
    cellTot = cellTemp(count:v,:);
    
    end
    
Mag_adj{y}(d,1) = mean(magTot);
placeholderCell = mean(cellTot{:,1:end});

Cell_adj{y}(d,:) = placeholderCell;

count = count + avgAmount;
    
end

CellTable_final{y,1} = array2table(Cell_adj{y}, 'VariableNames', {'x mm', 'y mm', 'inst vel x', 'inst vel y', 'CHC'});

fp = fp + 1;

fprintf('%d ', y);

end
else
end

        %6. Calculate RMS value
        
RMSArray = cell(npt,1);
tempRMS = zeros(imageC,2);
       
for t = 1:npt
    
    for k = 1:imageC
    xTemp = table2array(CellTableArray{t}(k,3));
    yTemp = table2array(CellTableArray{t}(k,4));
    
    rmsX = ((xTemp - (meanArray(t,3)))^2)^(1/2);
    rmsY = ((yTemp - (meanArray(t,4)))^2)^(1/2);
    
    tempRMS(k,:) = [rmsX rmsY];
    
    end
    
    RMSArray{t} = array2table(tempRMS, 'VariableNames', {'RMS X-Vel','RMS Y-Vel'});
    
end
        
        %7. Calculate TKE value
        
TKEArray = cell(npt,1);
tempTKE = zeros(imageC,1);
       
for t = 1:npt
    
    for k = 1:imageC
    xRMSTemp = table2array(RMSArray{t}(k,1));
    yRMSTemp = table2array(RMSArray{t}(k,2));
    
    TKEint = ((xRMSTemp)^2 + (yRMSTemp)^2) * (3/4);
    
    
    tempTKE(k,:) = TKEint;
    
    end
    
    TKEArray{t} = array2table(tempTKE, 'VariableNames', {'TKE value (z-estimate)'});
    
end    

        %8. Calculate Reynolds
        
        
        
        
        %8. Save Workplace Variables
        
%create save variable names
base = append('baseValues_',RPM);
assignin('base',base,baseValues);

normalBase = append('normalisedbaseValues_',RPM);
assignin('base',normalBase,normalisedbaseValues);

meanAr = append('meanArray_',RPM);
assignin('base',meanAr,meanArray);

meanTbl = append('meanTable_',RPM);
assignin('base',meanTbl,meanTable);

RMSTbl = append('RMSArray_',RPM);
assignin('base',RMSTbl,RMSArray);

TKETbl = append('TKEArray_',RPM);
assignin('base',TKETbl,TKEArray);

if matches (adjust,'Yes')
    
CTableAr = append('CellTableArray_',RPM);
assignin('base',CTableAr,CellTable_final);

else
CTableAr = append('CellTableArray_',RPM);
assignin('base',CTableAr,CellTableArray);
end

if matches (adjust,'Yes')

MagVal = append('Mag_',RPM);
assignin('base',MagVal,Mag_adj);

else    
MagVal = append('Mag_',RPM);
assignin('base',MagVal,Mag);
end
        
try        
savefilename = [savefilepath,'\','PIV_',run,'.mat'];   
save(savefilename,convertCharsToStrings(base),convertCharsToStrings(normalBase),convertCharsToStrings(meanAr),convertCharsToStrings(meanTbl),convertCharsToStrings(CTableAr),convertCharsToStrings(MagVal),convertCharsToStrings(RMSTbl),convertCharsToStrings(TKETbl));
successmessage = ['Process Completed: Workplace variables saved to ',savefilename];
    disp (successmessage);
catch
    disp ('Process partially completed: Attempt at saving workplace variables failed, invalid save filepath');
end
    
sound(sin(1:3000));