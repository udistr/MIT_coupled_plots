intr=365;
nperday=8;
!csh get_eta.sh

fileID = fopen('eta.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(1)
plot(x);
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('eta [m]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/TS_ETA


fileID = fopen('sst.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(2)
plot(x)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('sst [DegC]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/TS_SST


fileID = fopen('theta.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(3)
plot(x)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('theta [DegC]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/TS_THETA


fileID = fopen('salt.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(4)
plot(x)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('salt [psu]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/TS_SALT


fileID = fopen('sss.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(5)
plot(x)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('sss [DegC]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/TS_SSS


fileID = fopen('area.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(6)
plot(x.*6370000^2*4*pi*0.7021)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('area [m^2]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/Ice_TS_AREA


fileID = fopen('heff.txt');
x1=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

fileID = fopen('area.txt');
x2=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(7)
plot(x1./x2)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('heff [m]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/Ice_TS_HEFF

fileID = fopen('heff.txt');
x=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

figure(8)
plot(x.*6370000^2*4*pi*0.7021)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('volume [m^3]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/Ice_TS_VOLICE


fileID = fopen('hsnow.txt');
x1=cell2mat(textscan(fileID,'%f'));
fclose(fileID);

fileID = fopen('area.txt');
x2=cell2mat(textscan(fileID,'%f'));
fclose(fileID);


figure(9)
plot(x1./x2)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('hsnow [m]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/Ice_TS_HSNOW

