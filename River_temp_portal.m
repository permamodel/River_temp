% River_temp_portal 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% River water temperature model
% Irina Overeem, Lei Zheng, Kang Wang
% Institute of Arctic and Alpine Research
% CSDMS, Institute of Arctic and Alpine Research, University of Colorado
% Feb. 2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Mfile: file with meteorological observations including 
% His: Incident solar (shortwave) radiation (w m-2)
% Hdl: Downward thermal (Longwave) radiation (w m-2)
% Ta: Air temperature (°C)
% Uw:  Wind speed (m/s)
% rh: Relative humidity (0-1)
% P: Surface pressure (pa)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sfile: file with river stage observations
% h:  River stage (m)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters
% rivericeoff: First day of river iceoff (inundation starts)(DOY)
% rivericeon: First day of river iceon (inundation ends) (DOY)
% days: number of days of the input observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load Mfile (meteorological observations)
Mfile=importdata('Mfile.txt');
DOY=Mfile.data(:,1);
His=Mfile.data(:,2); %Downward solar (shortwave) radiation (w m-2)
Hdl=Mfile.data(:,3); %Downward thermal (Longwave) radiation (w m-2)
Ta=Mfile.data(:,4); %Air temperature (C)
Uw=Mfile.data(:,5);  %Wind speed (m/s)
rh=Mfile.data(:,6); %Relative humidity (0-1)
P=Mfile.data(:,7); %Surface pressure (pa)

% Load Sfile (River stage observations)
Sfile=importdata('Sfile.txt');
h=Sfile.data(:,1);

%%%%%
rivericeoff=135;
rivericeon=316;

%--------------------Simulate water temperature-----------------
Twater=River_temp(His,Hdl,Ta,Uw,rh,P,h,rivericeoff,rivericeon);









