function Stability_test_GRF(InputMapsPath,voxelp,clusterp,Istwotailed,MaskFile,OutDir)
if isempty(MaskFile)
    Maskpath=fileparts(which('restplus'));
    MaskFile=[Maskpath filesep 'mask' filesep 'BrainMask_05_61x73x61.img'];
end
[Path,FileName,ext]=fileparts(InputMapsPath);
strvoxelp=num2str(voxelp);
% OutDir=[Path filesep 'GRF_Correction_p' strvoxelp(strfind(strvoxelp,'.')+1:end)];
% mkdir(OutDir);

Tmaps=dir_4RegExp(InputMapsPath,'*Tmap.nii');
for Tmap_idx=1:length(Tmaps)
    idx=min(strfind(Tmaps{Tmap_idx},'.'));
    Tmap_NameList=Tmaps{Tmap_idx}(1:idx-1);
    TmapPath=[InputMapsPath filesep Tmaps{Tmap_idx}];
    OutputName=[OutDir filesep Tmap_NameList '_GRF_' strvoxelp(3:end)];
    [Data_Corrected, ClusterSize, Header]=y_GRF_Threshold(TmapPath,voxelp,Istwotailed,clusterp,OutputName,MaskFile);
    
    Z_ClusterFiles=dir_4RegExp(OutDir,['Z_Cluster*' Tmap_NameList '_GRF_' strvoxelp(3:end) '*.nii']);
    for zfile_idx=1:length(Z_ClusterFiles)
            ZCluster_tempPath=[OutDir filesep Z_ClusterFiles{zfile_idx}];
            [AllVolume_GRF,voxelsize,FileList,Header]=y_ReadAll(ZCluster_tempPath);
            [AllVolume_Tmap,voxelsize,FileList,Header]=y_ReadAll(TmapPath);
            MaskAllVolume=AllVolume_GRF ./ AllVolume_GRF;
            nanpos=isnan(MaskAllVolume);
            MaskAllVolume(nanpos)=0;
            AllVolume_Results=AllVolume_Tmap.*MaskAllVolume;
            y_Write(AllVolume_Results,Header,[OutputName '_ZtoT.nii']);
    end
end