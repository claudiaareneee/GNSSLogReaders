# GnssLogReaders
Gnss Log Readers is a short repo with MATLAB files that read log files from the RinexOn observation and GNSS Logger applications for SNR and CNO.

## Features
* Use ```runCN0(gnssFile)``` when you want to plot CN0 versus time
* Use ```runCN0andRinex(gnssFile, rinexFile)``` when you want to plot the CN0's of a GNSS log file against the CN0's of a Rinex file
* Use ```runOrientation(fileFolder)``` when you want to plot orientation versus time
* Use ```runOrientationAndCN0(fileFolder)``` when you want to plot orientation and cn0 vs time
* Use ```run2cn0s(AFile, BFile)``` when you want to plot the CN0 from two files on the same chart

### Notes: 
* Input parameters should be strings of the full path to data. 
* These scripts will save plots into *.fig* and *.png* files in the parent directory of the log files.

### Examples: 
Orientation
```
fileFolder = "C:\Users\foo\bar\MyGnssLogs\data";
runOrientation(fileFolder);
```
CN0's
```
fileOne = "C:\Users\foo\bar\MyGnssLogs\data\aFile.txt";
fileTwo = "C:\Users\foo\bar\MyGnssLogs\data\bFile.txt";
run2cn0s(fileOne, fileTwo);
```
