function signaltype = getSignalType(sat, frequency)
% Constellations: 1. GPS, 2. SBAS, 3. GLONASS, 4. QZSS, 5. BEIDUO, 6.Galileo
frequency = frequency*1000;
frequency = floor(frequency);

if(frequency == 1575)
    signaltype = "L1";
elseif (frequency == 1176)
    signaltype = "L5";
else
    signaltype = num2str(frequency);
end

switch(sat)
    case 1
        signaltype = strcat("GPS ", signaltype);
    case 2
        signaltype = strcat("SBAS ", signaltype);
    case 3
        if(frequency == 1600 || frequency == 1602)
            signaltype = "L1";
        end
        
        signaltype = strcat("GLONASS ", signaltype);
    case 4
        signaltype = strcat("QZSS ", signaltype);
    case 5
        if(frequency == 1561 || frequency == 1589)
            signaltype = "L1";
        elseif(frequency == 1207)
            signaltype = "E5";
        end
        signaltype = strcat("BEIDOU ", signaltype);
        
    case 6
        if(frequency == 1561)
            signaltype = "L1";
        elseif(frequency == 1207)
            signaltype = "E5";
        end
        signaltype = strcat("Galileo ", signaltype);
end
end


