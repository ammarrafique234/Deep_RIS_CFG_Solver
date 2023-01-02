# Deep_RIS_CFG_Solver

Code to generate dataset and train Deep CNN for Reconfigurable Intelligent Surface configuration finding from radiation pattern.

### The code is part of material related to paper "An Efficient Deep Learning Approach for Surface Level Design of Reconfigurable Intelligent Surface".

### 1. Final Radiation patterns for results section

FinalResults/Ref/<br>
FinalResults/GA/<br>
FinalResults/DNN/

### 2.1 NN training code

DNN/"deepNN_dataset_gen.m" dataset generation file<br>
DNN/"deepCNNCreateANDConnect.m" cnn architecture making file<br>
DNN/"deepRIS_train.m" training file<br>
DNN/"deepRIS_testOnly.m" testing file<br>
DNN/lib/: dependecies

### 2.2 The big file

DNN/lib/"metaatom_data_uv_s1.mat" it has unit-cell data link "https://drive.google.com/file/d/1IL_Rv7RjAxR43AEBeZ66JwPhv0BRAUIS/view?usp=sharing"<br>
"train_test_sets.mat" sample training and testing data :regenerate from code<br>
"myCNN01.mat" it has DNN network :regenerate from code
