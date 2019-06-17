if ~exist('p')
  p = genpath('~/MATLAB/');
  addpath(p);

  %load nctiles_grid in memory:
  fout='~/data/geos5/MITGRID/llc90/';
  grid_load(fout,5,'compact',0,0)
  %displays list of grid variables:
  gcmfaces_global;% disp(mygrid);
end
V={'SALT','THETA','UVELMASS','VVELMASS','WVELMASS','GM_PsiX ','GM_PsiY ',};
%var=2
%level=1
collection='state_3d_set1';
filo=dir(['../mit_output/' collection '*.data']);
%WGHT=read_bin('iceInst.0000475836.data',9,0);
%WGHT(WGHT<1.)=NaN;
WGHT=1;
msk=mygrid.mskC(:,:,1).*mygrid.RAC.*WGHT; msk(isnan(msk))=0;

%  niter0=0;
%dt=4; %time steps per file
N=length(filo);

fignum=1;
for var=2:2
  fdate=fdate0;
%  startdate=datetime(2006,4,14,21,0,0);
%  enddtate=datetime(2007,4,14,21,0,0);
  fld=read_bin(['../mit_output/' filo(1).name],1,1)*0;
  i=1;
  n=0;
  while isbetween(fdate,fdate,enddate)
    if isbetween(fdate,startdate,enddate) & i<=length(filo)
      fld=read_bin(['../mit_output/' filo(i).name],var,1);
      fdate 
      [V{var} ' ' num2str(i) ' ' num2str(sum(fld.*msk)./sum(msk))]
      n=n+1;
      x(n)=sum(fld.*msk)./sum(msk);
    end
    i=i+1;
    if strcmp(DT,'hour')
     	fdate=fdate+hours(NDT);
    elseif strcmp(DT,'day')
     	fdate=fdate+days(NDT);
    elseif strcmp(DT,'month')
     	fdate=fdate+calmonths(NDT);
    elseif strcmp(DT,'year')
     	fdate=fdate+calyears(NDT);
    end  
  end
end

figure(1)
plot(x)
grid on
xlabel('time [Days from 14/04/2000]')
ylabel('sst [DegC]')
set(gca,'xtick',0:intr*nperday:length(x))
set(gca,'xticklabel',0:intr:length(x))
print -djpeg figs/TS_SST



	


