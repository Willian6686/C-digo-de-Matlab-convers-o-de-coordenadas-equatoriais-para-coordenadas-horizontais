clc 
clear all
close all



% Acrux
A = 2023; 
M = 12; 
D = 19;
Hora = 20;
Min = 00;
Seg = 00;
fuso = -3;
AR = 12.442813888888889;
Declinacao = -63.094166666666666;
longitude = -51.62455420400137;
latitude = -30.0065;
m = 3.075;
n = 20.04;                     
nn = 1.336;



   
    







   pause(0.1);
    tic;
  
    utc = [A M D Hora-fuso Min Seg];
   
    % Dia juliano
    
  if (M==1|M==2)
    M=M+12;                                                                 
    A=A-1;
  else                          
    M=M;                                                                    
    A+A;
  end   

 if utc(1) > 1582
    aux = 1;
elseif utc(1) == 1582
    if utc(2) > 10
        aux = 1;
    elseif utc(2) == 10
            if utc(3) >= 15 
               aux = 1;
            else
                aux = 0;
                
            end
    else
            aux = 0;
     end
 else
    aux = 0;
 end

if aux == 1
    A = floor(A/100);                                                           
    B = 2 - A + floor(A/4);
else
    B = 0;
end





JD = floor(365.25*(utc(1)+4716))+floor(30.6001*(utc(2)+1)) + utc(3) + B - 1524.5;


% Século Juliano

T = (JD - 2451545)/36525;


% Tempo Sideral Greenwich Zero Hora

TSG_zero_hora = 100.46061837 + 36000.770053608*T + 0.000387933*T^2 - T^3/38710000;  
TSG_zero_hora_frac = TSG_zero_hora/360;


% Tempo Sideral Greenwich Qualquer Instante

UT = (Hora+3 + Min/60 + Seg/3600);
TSG_qualq_hora = ((UT)/24)*1.00273790935 + TSG_zero_hora_frac;
TSG_q_h_int = floor(TSG_qualq_hora);
TSG_qualq_hora_frac = (TSG_qualq_hora - TSG_q_h_int)*24;


% Tempo Sideral Local

LST = TSG_qualq_hora_frac + longitude/15;


% Ângulo Horário




% Correção das coordenadas
    ar2000 = AR;
    d2000 = abs(Declinacao);
   
        
    
    delta_ano = utc(1)-2000 + utc(2)/12 + utc(3)/31;
    
    Narr = ((m + nn * sin(deg2rad(ar2000)) * tan(deg2rad(d2000))) * delta_ano)/3600;
    Ndd = (n * cos(deg2rad(ar2000)) * delta_ano)/3600;
    
    
    AR = ar2000 + Narr;
    if Declinacao>0
        Declinacao = d2000 + Ndd;
    else
        Declinacao = -(d2000 + Ndd);
    end

Hgraus = (LST-AR)*15;
H = deg2rad(Hgraus);

% Azimute

phi = deg2rad(latitude);
delta = deg2rad(Declinacao);


A_num = (sin(H)); 
A_den = (cos(H)*sin(phi)-tan(delta)*cos(phi));
Azimute_rad = atan2(A_num,A_den);
Azimute = rad2deg(Azimute_rad)+180;


Az = floor(Azimute);
Azgraus = abs(Azimute-Az);
Azmin = Azgraus*60;
Azmin2 = floor(Azmin);
Azseg = abs(Azmin-Azmin2);
Azseg2 = Azseg*60;
Azseg3 = floor(Azseg2);


% float Azimute_graus = [Az Azmin2 Azseg3];


% Altura

h = sin(delta)*sin(phi)+cos(delta)*cos(phi)*cos(H);  
Altura_rad = asin(h);
Altura = rad2deg(Altura_rad); 

Alt = floor(Altura);
Altgraus = abs(Altura-Alt);
Altmin = Altgraus*60;
Altmin2 = floor(Altmin);
Altseg = abs(Altmin-Altmin2);
Altseg2 = Altseg*60;
Altseg3 = floor(Altseg2);

  elapsedTime = toc;

% float Altura_graus = [Alt Altmin2 Altseg3];
  disp(['Dia juliano: ' num2str(JD)]);
  disp(['Século juliano: ' num2str(T)]);
  disp(['Tempo universal: ' num2str(UT)]);
  disp(['Tempo sideral de Greenwich qualquer hora: ' num2str(TSG_qualq_hora_frac)]);
  disp(['Tempo sideral local: ' num2str(LST)]);
  disp(['Ângulo horário: ' num2str(Hgraus/15)]);

  

  

   disp(['Azimute: ' num2str(Az) '° ' num2str(Azmin2) ''' ' num2str(Azseg3) '"']);
   
    disp(['Altura: ' num2str(Alt) '° ' num2str(Altmin2) ''' ' num2str(Altseg3) '"']);
 
  
    Alt = floor(AR);
    Altgraus = abs(AR-Alt);
    Altmin = Altgraus*60;
    Altmin2 = floor(Altmin);
    Altseg = abs(Altmin-Altmin2);
    Altseg2 = Altseg*60;
    Altseg3 = floor(Altseg2);

    Nart2 = [ Alt Altmin2 Altseg3];

    Alt = floor(abs(Declinacao));
    Altgraus = abs(Declinacao)-Alt;
    Altmin = Altgraus*60;
    Altmin2 = floor(Altmin);
    Altseg = abs(Altmin-Altmin2);
    Altseg2 = Altseg*60;
    Altseg3 = floor(Altseg2);
    
     if Declinacao>0
        Ndc2 = [Alt Altmin2 Altseg3];
     else
        Ndc2 = [-Alt Altmin2 Altseg3];
     end

    disp(['Ascensão Reta: ' num2str(Nart2(1)) 'h ' num2str(Nart2(2)) 'm ' num2str(Nart2(3)) 's']);
    disp(['Declinação: ' num2str(Ndc2(1)) '° ' num2str(Ndc2(2)) ''' ' num2str(Ndc2(3)) '"']);

  
    pause(0.1);
    disp(['t_start: ' num2str(tic)]);
    microseconds = elapsedTime * 1e6;
    disp(['t_stop: ' num2str(toc)]);
    disp(['Tempo de execução: ' num2str(microseconds) ' microsegundos']);
    
    
    
   