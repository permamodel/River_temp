function Tw = River_temp(His,Hdl,Ta,Uw,rh,P,h,rivericeoff,rivericeon)  

% River water temperature model
% Irina Overeem, Lei Zheng, Kang Wang
% Institute of Arctic and Alpine Research
% CSDMS, Institute of Arctic and Alpine Research, University of Colorado
% Feb. 2019

%--------------------------Inputs---------------------------
% His: incident solar (shortwave) radiation (w m-2)
% Hdl: Downward thermal (Longwave) radiation (w m-2)
% Ta: Air temperature (°C)
% Uw:  Wind speed (m/s)
% rh: Relative humidity (0-1)
% P: Surface pressure (pa)
% h:  River stage (m)
% rivericeoff: First day of river induation (DOY)
% rivericeon: Last day of river induation (DOY)
% days: number of days of the input observations

%--------------------------Output---------------------------
% Tw: water temperature (°C)

%--------------------Declare constants---------------------- 
c      = 4210; % Heat capacity of fresh water (J kg-1 K-1)
rho    = 1000; % Density of fresh water (kg m-3)
R      = 0.2;  % White water albedo-McMahon et al., 2017
sigma  = 5.67e-8;% Stefan-Boltzmann constant (W m-2 K-4)
%               ----Riverbed module----
dz     = 1; % Each depth step is 1 meter
Nz     = 30; % Choose the number of depth steps
Nt     = 365; % Choose the number of time steps
dt     = (365*24*60*60)/Nt; % Length of each time step in seconds
K      = 2.3;  % Thermal conductivity of sediment ( W m-1 K-1 )
density= 1250; % Density of sediment(kg m-3)
C      = 660; % Heat capacity of sediment
dsoil  = 30; % Depth without soil temperature variations (m)
Tc     = -5 ;% Soil temperature keeps -5°C at dsoil (30 m)
T      = Tc*ones(Nz+1,Nt);  % Create ground temperature matrix with Nz+1 rows, and Nt+1 columns
r      = 0.6; % fraction of shortwave absorbed in water surface layer
d      = 0.2; % fraction of shortwave reflected by riverbed-Web and Zhang, 1997
f      = 0.05; % Attenuation coefficient (m-1)-Web and Zhang, 1997

%-------------------River inundation timing------------------
days=length(Ta);
DOY=[1:days];
riverice = zeros(length(DOY));
riverice_index = find(DOY>rivericeoff & DOY<rivericeon);
riverice(riverice_index) = 1;

%--------------------------DAILY WATER TEMPERATURE-------------------
Tw=zeros(1,days);
DeltaH=zeros(1,days); % Heat balance
wt=0;
for i = rivericeoff:rivericeon
    
    % -------------------Solar radiation heat gain-------------------
    Hsr(i)= (1-R)*His(i);
    
    % -------Longwave radiation heat (Gao and Merrick, 1996)---------
    Hlr(i)= Hdl(i)-(Tw(i)+273.15)^4*0.97*sigma;
    
    % ----------Evaporation heat gain (Hebert et al., 2011)----------
    % Saturated vapor pressure at the water temperature (mm Hg)
    Es    = 25.374*exp(17.62-5271/(Tw(i)+273.15));
    % Atmospheric water vapour pressure (mm Hg)
    Ea    = rh(i)*25.374*exp(17.62-5271/(Ta(i)+273.15));
    Hlh(i)= (3*Uw(i)+6)*(Ea-Es);
    
    % ----------Convective heat gain (Hebert et al., 2011)-----------
    Hsc(i)= (3.66+1.83*Uw(i)).*(P(i)*0.0075/1000).*(Ta(i)-Tw(i));

    % ---------riverbed heat conduction (Web and Zhang, 1997)--------
    T(1,i)= Tw(i); % First layer temperature (same as water temperature)
    %------------Finite difference approximations--------------------
    depth_2D     = (T(1:end-2,i-1)-2*T(2:end-1,i-1)+T(3:end,i-1))/dz^2;%|
    time_1D      = double(K/density/C).*double(depth_2D);%||||||||||||||||
    T(2:end-1,i) = time_1D*dt+ T(2:end-1,i-1);%||||||||||||||||||||||
    %----------------------------------------------------------------
    T(dsoil/dz,i)= Tc; % Enforce bottom BC
    % --------Riverbed heat transfer-------
    Hht(i)= -K*(T(1,i)-T(2,i))/dz;
    % -----Riverbed absorbed radiation-----
    Hba(i)= -(1-R)*(1-r)*(1-d)*Hsr(i)*exp(-f*h(i));
    % --------Riverbed heat balance---------
    Hbc(i)= Hht(i)+Hba(i);
    
    % -----------------------Total heat gain-------------------------
    DeltaH(i)  = Hsr(i)+Hlr(i)+Hlh(i)+Hsc(i)+Hbc(i);
    
    % -----------------------Water temperature----------------------- 
    dwt   = (1/((h(i)*rho*c)))*DeltaH(i)*riverice(i);
    wt    = wt + (dwt*24*3600);
    wt    = max(0,wt);
    if(riverice(i) == 0)
        wt=0;
    end
    Tw(i+1)= wt;
end

Tw(DOY<=rivericeoff | DOY>=rivericeon)=NaN;
h(DOY<=rivericeoff | DOY>=rivericeon)=NaN;
DeltaH(DOY<=rivericeoff | DOY>=rivericeon)=NaN;
Hbc(DOY<=rivericeoff | DOY>=rivericeon)=NaN;
Hlh(DOY<=rivericeoff | DOY>=rivericeon)=NaN;
Hsc(DOY<=rivericeoff | DOY>=rivericeon)=NaN;
Hsr(DOY<=rivericeoff | DOY>=rivericeon)=NaN;
Hlr(DOY<=rivericeoff | DOY>=rivericeon)=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Display%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%River stage
subplot(311)
plot(h,'k-','linewidth',2)
axis([121 335 0 3])
set(gca, 'XTick',[1,32,60,91,121,152,182,213,244,274,305,335,365],'Layer','top')
set(gca,'XTickLabel',{'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun'...
'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' 'Jan '}, 'FontName', 'Times New Roman','FontSize',10) ;
ylabel('River stage (m)')
legend('River stage (m)')
grid on;

%Heat budget components
subplot(312)
plot(Hlh,'linewidth',1)
hold on
plot(Hsc,'linewidth',1)
hold on
plot(Hlr,'linewidth',1)
hold on
plot(Hsr,'linewidth',1)
hold on
plot(Hbc,'linewidth',1)
hold on
plot(DeltaH,'linewidth',2)
axis([121 335 -300 300])
set(gca, 'XTick',[1,32,60,91,121,152,182,213,244,274,305,335,365],'Layer','top')
set(gca,'XTickLabel',{'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun'...
'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' 'Jan '}, 'FontName', 'Times New Roman','FontSize',10) ;
ylabel('Heat flux (W m^{-2})')
legend('Latent heat flux (H_{lh})','Convective flux (H_{ch})',...
    'Net longwave radiation (H_{lr})','Net solar radiation (H_{sr})',...
    'Streambed heat flux (H_{bh})','Heat balance (\DeltaH_w)')
grid on;

%Air and water temperature
subplot(313)
plot(Ta,'linewidth',2,'color',[0.3,0.3,0.3])
hold on
plot(Tw,'r-','linewidth',2)
legend('T_a','T_w')
axis([121 335 -15 25])
set(gca, 'XTick',[1,32,60,91,121,152,182,213,244,274,305,335,365],'Layer','top')
set(gca,'XTickLabel',{'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun'...
'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' 'Jan '}, 'FontName', 'Times New Roman','FontSize',10) ;
xlabel('Date')
ylabel('Temperature (°C)')

grid on;
end