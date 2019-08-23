intr=365;
nperday=8;
!csh get_eta.sh

fileID = fopen('eta.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

t=datetime(2000,4,15)+3*hours(1:length(x));

figure(1)
plot(t,x)
grid on
ylabel('eta [m]')
print -djpeg figs/TS_ETA


fileID = fopen('sst.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(2)
plot(t,x)
grid on
ylabel('sst [DegC]')
print -djpeg figs/TS_SST


fileID = fopen('theta.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(3)
plot(t,x)
grid on
ylabel('theta [DegC]')
print -djpeg figs/TS_THETA


fileID = fopen('salt.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(4)
plot(t,x)
grid on
ylabel('salt [psu]')
print -djpeg figs/TS_SALT


fileID = fopen('sss.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(5)
plot(t,x)
grid on
ylabel('sss [DegC]')
print -djpeg figs/TS_SSS


fileID = fopen('area.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(6)
plot(t,x.*6370000^2*4*pi*0.7021)
grid on
ylabel('area [m^2]')
print -djpeg figs/Ice_TS_AREA


fileID = fopen('heff.txt');
x1=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

fileID = fopen('area.txt');
x2=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(7)
plot(t,x1./x2)
grid on
ylabel('heff [m]')
print -djpeg figs/Ice_TS_HEFF

fileID = fopen('heff.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(8)
plot(t,x.*6370000^2*4*pi*0.7021)
grid on
ylabel('volume [m^3]')
print -djpeg figs/Ice_TS_VOLICE


fileID = fopen('hsnow.txt');
x1=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

fileID = fopen('area.txt');
x2=cell2mat(textscan(fileID,'%f'));
fclose(fileID);


figure(9)
plot(t,x1./x2)
grid on
ylabel('hsnow [m]')
print -djpeg figs/Ice_TS_HSNOW

