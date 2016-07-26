function [corrected_data]=APD_correction_function_ver2p1(APD_serial_num,bin_time_in_msec,raw_data,emission_band_center)

%****************************************************************************************************************************************************
% DATA_ZONE
% Photon detection efficiency data for SPCM-AQR-1X APDs
SPCM_AQR_photon_detection_efficiency=[[400:20:1000]',[8 14 22 30 36 42 48 52 56 58 60 62 64 65 65 66 65 64 62 60 56 52 47 43 39 34 30 26 22 18 14]'];

% Photon detection efficiency data for SPCM-AQRH-1X APDs
SPCM_AQRH_photon_detection_efficiency=[[400:20:1000]',[8 16 24 32 40 48 54 58 62 65 68 69 71 72 73 73 73 72 69 66 62 57 52 48 43 38 33 28 24 20 15]'];

%Correction factor data for different modules
%First column: count rate (Kc/sec)
%second column: correction factor
correcn_factor_18558_C1911=[[247 599.6 1442.1 2179.6 3243.4 4765.1 6655.1 9001 10343.1 11707 13188.8 14452.8 16159.9 17571.2 18931.8 20232 21436.3 22498.7 23482.2 24304.1 24945.1]',...
                            [1   1.03  1.08   1.13   1.21   1.31   1.48   1.73 1.9     2.11  1.36    2.71    3.05    3.53    4.13    4.86  5.77    6.93    8.35    10.16   12.46]'];

correcn_factor_13793_B1633=[[17.9 44.9 112.1 278.2 685.4 1633.5 2470.3 3648.3 5212 7127 9274 10145.8 10954.5 11675.1 12279.6 12759.2]',...
                            [1    1    1.01  1.02  1.04  1.09   1.15   1.23   1.37 1.58 1.93 2.22    2.59    3.06    3.66    4.43]'];  

correcn_factor_8501_9280  =[[7.9 20 49.6 123.2 309  758.1 1800.4 2707.2 3984.7 5636.9 6595.1 7633.3 8592.8 9543.4 10441.6 11266.1 11968.3 12565.2]',...
                            [1   1  1.01 1.02  1.02 1.05  1.11   1.17   1.25   1.41   1.51   1.65   1.84   2.09   2.4     2.8     3.32    3.98]'];

correcn_factor_6886_7592  =[[76.2 122.1 196.3 309.7 478.2 748.6 1174.8 1796.7 2661.2 3904.4 5524.5 6549.4 7650.7 8938.8 10311.5 11571.7 12760.5 13809.7 14748.5 15515.7 16175.4 16657 17013.1]',...
                            [1    .99   .98   .98   1.01  1.02  1.03   1.07   1.14   1.23   1.38   1.47   1.58   1.7    1.86    2.08    2.38    2.77    3.26    3.9     4.71    5.76  7.1]'];

correcn_factor_9913_A6602 =[[8.5 21.3 52.2 131.4 337 835.7 1968.4 3007.1 4310 5936.2 6897.3 7912.9 8996.3 9981.6 11042.3 12003.1 12764.8 13401.1 13903.1]',...
                            [1   1    1.03 1.02  1   1.02  1.08   1.12   1.24 1.43   1.55   1.7    1.88   2.14   2.43    2.82    3.33    4       4.85]'];

correcn_factor_9328_A1476 =[[8.2 20.9 51.2 128.3 320.6 782.1 1855.8 2791.4 4054.2 5725.7 6695.9 7751.4 8689.3 9595.9 10432.3 11205.5 11883.4 12426.4]',...
                            [1   .99  1.01 1.02  1.02  1.05  1.11   1.17   1.28   1.44   1.55   1.68   1.89   2.16   2.5     2.93    3.47    4.18]'];

correcn_factor_10103_A6906=[[7.7 19.3 48.2 119.4 298.1 743.6 1760 2679.8 3972 5632.5 6632.1 7703.1 8814.5 9982.5 11106.6 12152 12888.6 13485.1]',...
                            [1   1.01 1.01 1.03  1.03  1.04  1.11 1.15   1.23 1.38   1.47   1.59   1.75   1.95   2.21    2.54  3.01    3.62]'];

correcn_factor_10282_A7169=[[7.9 20  49.7 124.8 315.5 764.8 1839.4 2760.6 4029.2 5753 6785.8 7878.6 9100.1 10317.5 11605.8 12853.3 13843.5 14774.7 15522.7 16127.5]',...
                            [1   .99 1    1     1     1.03  1.08   1.14   1.24   1.38 1.47   1.59   1.74   1.93    2.16    2.45    2.87    3.38    4.05    4.91]'];

correcn_factor_24214_C8831=[[6.0 15.2 37.9 95.5 237.5 588.1 1446.8 2228.4 3325.1 4925.9 7070.3 9705.8 11173.6 12700.1 14274.5 15859.2 17439.1 18907.7 20380.2 21651.0 22804.6 23866.1 24740.4 25475.7]',...
                            [1 .99 1 1 1.01 1.02 1.05 1.08 1.14 1.22 1.35 1.56 1.71 1.89 2.12 2.40 2.74 3.19 3.72 4.41 5.27 6.34 7.70 9.42]'];

% Dark count data for different modules (Hz)    
dark_count_18558_C1911 = 250;
dark_count_13793_B1633 = 250;
dark_count_8501_9280 = 250; % Fiber receptacle APD (Green channel on mini optical setup)
dark_count_6886_7592 = 250;
dark_count_9913_A6602 = 300;
dark_count_9328_A1476 = 300;
dark_count_10103_A6906 = 250;
dark_count_10282_A7169 = 100; % SPCM_AQR_14
dark_count_24214_C8831 = 1500; % Latest APD on the mini optical setup (Orange channel)

%****************************************************************************************************************************************************    



%****************************************************************************************************************************************************
    %pick the right correcn_factor data and dark_count rate
    eval(['correcn_factor_data=correcn_factor_' APD_serial_num ';']);
    eval(['dark_count=dark_count_' APD_serial_num ';']);
    
    
    % Note SPCM-AQR-1X products are same as SPCM-CD2801 or CD2802 or CD2803 products  
    % use SPCM AQR photon detection efficiency data to calculate photon
    % detection efficiency for SPCM-AQR-1X modules
    if ~isempty(strmatch(APD_serial_num,{'13793_B1633';'8501_9280';'6886_7592';'9913_A6602';'9328_A1476';'10103_A6906';'10282_A7169'},'exact'))
        %Use linear interpolation in case data at emission band center is not available
        %Divide by 100 to convert percentage to fraction
        photon_detection_efficiency=interp1(SPCM_AQR_photon_detection_efficiency(:,1),SPCM_AQR_photon_detection_efficiency(:,2),emission_band_center)/100;
    elseif ~isempty(strmatch(APD_serial_num,{'18558_C1911';'24214_C8831'},'exact'))
        photon_detection_efficiency=interp1(SPCM_AQRH_photon_detection_efficiency(:,1),SPCM_AQRH_photon_detection_efficiency(:,2),emission_band_center)/100;
    end
    
    % Calculate correction_factor array containing correction factor for every single data point in the data array
    % correcn_factor_data has count rate in Kc/sec so no need to multiply raw_data/bin_time_in_msec by 1000 as this rate will be rate in Kc/sec
    % Use linear interpolation and use extrapolation for any isolated data points outside the range of correction factor data given
    correcn_factor_array=interp1(correcn_factor_data(:,1),correcn_factor_data(:,2),raw_data/bin_time_in_msec,'linear','extrap');
    % actual_count_rate=(raw_count_rate*correcn_factor-dark_count)/photon_detection_efficiency
    % dark_count*bin_time_in_msec/1000 converts dark count in count/sec to dark_count per bin
    corrected_data=(raw_data.*correcn_factor_array-dark_count*bin_time_in_msec/1000)/photon_detection_efficiency;
%****************************************************************************************************************************************************    