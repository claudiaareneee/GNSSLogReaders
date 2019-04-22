function satInfo = getInfo(uniqueSatID, frequency)
    satInfo.id = getSatID(uniqueSatID);
    satInfo.signalType = getSignalType(uniqueSatID, frequency);
end


function mTitle = getSatID(uniqueSatID)

uniqueSatID = num2str(uniqueSatID);

% Constellations: 1. GPS, 2. SBAS, 3. GLONASS, 4. QZSS, 5. BEIDUO, 6.Galileo
switch(uniqueSatID(1))
    case "1"
        mTitle = "GPS ";
    case "2"
        mTitle = "SBAS ";
    case "3"
        mTitle = "GLONASS ";
    case "4"
        mTitle = "QZSS ";
    case "5"
        mTitle = "BEIDUO ";
    case "6"
        mTitle = "Galileo ";
    otherwise
        mTitle = "Unknown ";
end
    mTitle = strcat(mTitle, uniqueSatID(2:end));

end

function signaltype = getSignalType(uniqueSatID, frequency)
% Constellations: 1. GPS, 2. SBAS, 3. GLONASS, 4. QZSS, 5. BEIDUO, 6.Galileo
frequency = frequency*1000;
frequency = floor(frequency);

uniqueSatID = mat2str(uniqueSatID);
uniqueSatID = uniqueSatID(1);

if(frequency == 1575)
    signaltype = "L1";
elseif (frequency == 1176)
    signaltype = "L5";
elseif (frequency == 1000) % This is a placeholder value for signals without carrier frequencies
    signaltype = "";
else
    signaltype = num2str(frequency);
end

switch(uniqueSatID)
    case "3"
        if(frequency == 1600 || frequency == 1602)
            signaltype = "L1";
        end
    case "5"
        if(frequency == 1561 || frequency == 1589)
            signaltype = "L1";
        elseif(frequency == 1207)
            signaltype = "E5";
        end
    case "6"
        if(frequency == 1561)
            signaltype = "L1";
        elseif(frequency == 1207)
            signaltype = "E5";
        end
end
end

