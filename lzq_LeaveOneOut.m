function lzq_LeaveOneOut(InputDir,MaskFile,Folder1Name,Folder2Name,CovDataPath,OutputDir,direction)
% direction: 1 is Folder1-Folder2;  0 is Folder2-Folder1
[Folder1FileList, Folder1Filelength]=GetFolderLength([InputDir filesep Folder1Name]);
[Folder2FileList, Folder2Filelength]=GetFolderLength([InputDir filesep Folder2Name]);

for rpt=1:length(Folder2FileList)
    fprintf('Processing No%d step\n',rpt);
    StatsFile1=Folder1FileList;
    StatsFile2=Get_FileList(Folder2FileList,rpt);
    if direction==1
        DependentDir=Get_StasPath(InputDir,Folder1Name,Folder2Name,StatsFile1,StatsFile2);
    else
        DependentDir=Get_StasPath(InputDir,Folder2Name,Folder1Name,StatsFile2,StatsFile1);
    end
    
    ResultCovData=Get_CovFiles(CovDataPath,rpt,Folder1Name,Folder2Name,direction);
    
    if ~isempty(ResultCovData)
        OutPath=[OutputDir filesep num2str(rpt) '_' Folder1Name '_m_' Folder2Name '_Mask_Cov_Tmap'];
    else
        OutPath=[OutputDir filesep num2str(rpt) '_' Folder1Name '_m_' Folder2Name '_Mask_Tmap'];
    end
    
    y_TTest2_Image(DependentDir,OutPath, MaskFile,'',ResultCovData,'');
    fprintf('No.%d step was completed !!!\n',rpt);
    DependentDir={};
end
end

function [FileList, FileLength]=GetFolderLength(Folderpath)
FileList=dir_NameList(Folderpath);
FileLength=length(FileList);
end

function ResultsFile=Get_FileList(FolderList,ExcludeNum)
results_idx=1;
 for Num_idx=1:length(FolderList)
     if ExcludeNum==Num_idx
          continue;
     else
         ResultsFile{results_idx}=FolderList{Num_idx};
         results_idx=results_idx+1;
     end
 end
end

function Results=Get_StasPath(InputDir,Folder1Name,Folder2Name,StatsFile1,StatsFile2)
        for depend_idx1=1:length(StatsFile1)
            Results{1,1}{depend_idx1,1}=[InputDir filesep Folder1Name filesep StatsFile1{depend_idx1}];
        end
        for depend_idx2=1:length(StatsFile2)
            Results{2,1}{depend_idx2,1}=[InputDir filesep Folder2Name filesep StatsFile2{depend_idx2}];
        end
end

function ResultCovData=Get_CovFiles(CovFilePath,rpt,Folder1Name,Folder2Name,direction)
Folder1Cov=dir_4RegExp(CovFilePath,[Folder1Name '.txt']);
Folder2Cov=dir_4RegExp(CovFilePath,[Folder2Name '.txt']);
if ~isempty(Folder1Cov) && ~isempty(Folder2Cov)
    temppathCov1=[CovFilePath filesep Folder1Cov{1}];
    temppathCov2=[CovFilePath filesep Folder2Cov{1}];
    CovData1=load(temppathCov1); 
    CovData2=load(temppathCov2); 
    [row1,col1]=size(CovData1);
    [row2,col2]=size(CovData2);
    
    ResultsCov1=CovData1;
    
    result_idx=1;
    for i=1:row2
        if i==rpt
            continue;
        else
            ResultsCov2(result_idx,:)=CovData2(i,:);
            result_idx=result_idx+1;
        end
    end
    if direction==1
        ResultCovData{1,1}=ResultsCov1;
        ResultCovData{2,1}=ResultsCov2;
    else
        ResultCovData{2,1}=ResultsCov1;
        ResultCovData{1,1}=ResultsCov2;
    end

else
    error('CovData is not exist!!!');
end
end