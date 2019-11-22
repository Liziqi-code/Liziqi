function Stability_batch()
InputDir='E:\Data_Analysis\C00012\YuYang_Dynamic_Analysis\2019_07_11_Final_Results\Results_AddMeanBack\Results_Data\PerAF';
MaskFile='D:\matlab_toolbox\DPABI_V4.0_190305\DPABI_V4.0_190305\Templates\aal_mask_Resliced617361\CalculatorResult_AAL_mask.nii';
Folder1Name='MCI_ND';
Folder2Name='MCI_D';
direction=0; 
CovDataPath='E:\Data_Analysis\C00012\YuYang_Dynamic_Analysis\2019_07_11_Final_Results\2019_07_11_Final_ClassifyData';
TmapOutputDir='E:\Data_Analysis\C00012\YuYang_Dynamic_Analysis\2019_07_11_Final_Results\MCID_MCIND\LeaveOneOut\LeaveOneOut_PerAF\Tmaps';
GRFOutDir='E:\Data_Analysis\C00012\YuYang_Dynamic_Analysis\2019_07_11_Final_Results\MCID_MCIND\LeaveOneOut\LeaveOneOut_PerAF\GRF_p05';
voxelp=0.05;
clusterp=0.05;
Istwotailed=1;
lzq_LeaveOneOut(InputDir,MaskFile,Folder1Name,Folder2Name,CovDataPath,TmapOutputDir,direction);
GRFInputDir=TmapOutputDir;
Stability_test_GRF(GRFInputDir,voxelp,clusterp,Istwotailed,MaskFile,GRFOutDir);
OverlapInputDir=GRFOutDir;
Stability_test_Overlap(OverlapInputDir);
end