% function [m_imu]= transformacion_cuaterniones(m_imu,mcb0,mcb1)
%
% Funcion para la transformacion de los cuaterniones de un sensor mediante
% la aplicacion de la matriz de cambio de base (mbc0) entre el sistema de
% referencia de las c�maras y el del sensor, y la matriz de rotaci�n
% establecida entre el cuerpo rigido y el sensor (mcb1).
%
% quat_final = mcb1*quat*inv(mcb0)

function [m_imu]= transformacion_cuaterniones(m_imu,mcb0,mcb1)
    
    for t=1:length(m_imu.Quat)
        m_imu.Rotation(t,:)=(dcm2quat((mcb1)*quat2dcm(m_imu.Quat(t,:))*inv(mcb0)));
    end
    
end