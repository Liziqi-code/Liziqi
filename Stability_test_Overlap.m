function Stability_test_Overlap(InputGRFDir)
OutDir=[fileparts(InputGRFDir) filesep 'OverlapMap'];
mkdir(OutDir);
GRFFileList=dir_4RegExp(InputGRFDir,'*_ZtoT.nii');
ResultsVolume=zeros(61,73,61);
for File_idx=1:length(GRFFileList)
    temppath=[InputGRFDir filesep GRFFileList{File_idx}];
    [AllVolume_GRF,voxelsize,FileList,Header]=y_ReadAll(temppath);
    AllVolume_GRF=logical(AllVolume_GRF);
    ResultsVolume=ResultsVolume+AllVolume_GRF;
end
% ResultsVolume(find(ResultsVolume~=length(GRFFileList)))=0;
% ResultsVolume=logical(ResultsVolume);
OutputName=[OutDir filesep 'OverlapMap.nii'];
Header.fname=OutputName;
Header.descrip='OverlapMaps';
y_Write(ResultsVolume,Header,OutputName);
end