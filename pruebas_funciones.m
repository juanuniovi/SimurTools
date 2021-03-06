
addpath('Funciones\')
med_cal=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack\10-05-2019\Calibracion Robot_Shimmer.csv');
med_cam=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack\10-05-2019\Take 2019-05-10 12.55.42 PM.csv');
med_imu=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\10-05-2019\2019-05-10_12.51 (1).11_default_exp_SD_Session1\default_exp_Session1_idBFED_Calibrated_SD','BFED');
med_cam.Rigid_Body.RigidBody.Rotation=-[med_cam.Rigid_Body.RigidBody.Rotation(:,4), med_cam.Rigid_Body.RigidBody.Rotation(:,1:3)];
% med_imu.Quat=med_imu.Quat(:,5:8);
%med_cam.Rigid_Body.RigidBody.Rotation=-med_cam.Rigid_Body.RigidBody.Rotation;
%%
plot_camara_imu_2D(med_cam,{med_imu});
%%
med_imu_s=sincronizar_imus(med_cam,{med_imu},1);
plot_camara_imu_2D(med_cam,med_imu_s);
%%
med_imu_s=sincronizar_imus(med_cam,{med_imu},3950-1115);
%02-05-2019: 5804-911
%10-05-2019,12: 3233-1146
plot_camara_imu_2D(med_cam,med_imu_s);
%% calculo y aplicacion cambio de base entre espacios de camara y sensores imu
[mcb0,mcb1]=matriz_cambio_base(med_cal,med_imu_s{1},1,'Shimmer');

med_imu_s{1}=transformacion_cuaterniones(med_imu_s{1},mcb0,mcb1)

%%
% 
% sincronizar(med_cam,med_imu_s{1},1);
%%
plot_camara_imu_2D(med_cam,med_imu_s);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calibracion Sensor y calculo Quat

clc
clear all
addpath('Funciones\')
med_cam=cargar_datos_camara('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos optitrack\10-05-2019\Take 2019-05-10 12.55.42 PM.csv');
med_imu=cargar_datos_shimmer('G:\Mi unidad\Universidad\Doctorado\Mediciones\Datos shimmer\10-05-2019\2019-05-09_12.45.07_Session4_quat\default_exp_Session4_idBFED_Calibrated_SD.csv','BFED');
med_imu.Quat=med_imu.Quat(:,5:8);
%%

imus_calibrados=[];
[imus_calibrados]= calibracion_shimmer({med_imu});
% imus_calibrados={med_imu};
imus_calibrados{1}.Quat9DOF=quaternion_9DOF(imus_calibrados{1},mean(1./diff(med_imu.tiempo)*1000));

% [mcb0,mcb1]=matriz_cambio_base(med_cal,imus_calibrados{1},1,'Shimmer');
% med_imu_s{1}=transformacion_cuaterniones(imus_calibrados{1},mcb0,mcb1)
plot_camara_imu_2D(med_cam,imus_calibrados);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo configuracion Sensores 
SensorMacros = SetEnabledSensorsMacrosClass;    
configuracion_shimmer('5',100,{SensorMacros.LNACCEL,SensorMacros.GYRO,SensorMacros.MAG,'Quat'})
