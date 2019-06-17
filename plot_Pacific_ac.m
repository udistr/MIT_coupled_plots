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
collection='state_3d_set1';
filo=dir(['../mit_output/' collection '*.data']);
units='[DegC]';
msk=mygrid.mskC(:,:,1).*mygrid.RAC; msk(isnan(msk))=0;
%  niter0=0;
%dt=4; %time steps per file
N=length(filo);
th=0.001;
fignum=1;
XC=convert2gcmfaces(mygrid.XC);
YC=convert2gcmfaces(mygrid.YC);
RAC=convert2gcmfaces(mygrid.RAC);
lons=[130:179 -180:-80];
L=length(lons);
fld=zeros(12,L);
LIM=5; % (box meridional limit)
for mn=1:12
  for var=2
    fdate=fdate0;
  %  startdate=datetime(2006,4,14,21,0,0);
  %  enddtate=datetime(2007,4,14,21,0,0);
    i=1;
    n=0;
    while isbetween(fdate,fdate,enddate)
      if isbetween(fdate,startdate,enddate) & i<=length(filo) & month(fdate)==mn
        sst=convert2gcmfaces(read_bin(['../mit_output/' filo(i).name],var,1));
        for j=1:L
          inds=YC<LIM & YC>-LIM & XC>lons(j) & XC<(lons(j)+1) & sst~=0;
          fld(mn,j)=fld(mn,j)+sum(sst(inds).*RAC(inds))./sum(RAC(inds));
        end
        fdate 
        n=n+1;
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
    fld(mn,:)=fld(mn,:)./n;

  end


end

fld2=fld;
fld2=fld2-repmat(mean(fld2(:,:),1),[12 1]);
fld2(13,:)=0;

map=jet(30);
mmap=map([1:10 21:30],:);
colormap(mmap);

h=contourf(fld2,-3:0.3:3);
%set(h, 'EdgeColor', 'none');
colorbar('xtick',-3:0.3:3)
caxis([-3 3])
set(gca,'Xtick',11:20:L)
%set(gca,'XtickLabel',lons(11:20:L))
set(gca,'XtickLabel',{'140E','160E','180','160W','140W','120W','100W','80W'})
set(gca,'Ytick',1.5:1:12.5)
set(gca,'YtickLabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
title('Equatorial Pacific Annual Cycle')

pname=['figs/sst_lev_eq_ac.png'];
print(pname,'-dpng')

figure
plot(mean(fld,1))
set(gca,'Xtick',11:20:L)
set(gca,'XtickLabel',{'140E','160E','180','160W','140W','120W','100W','80W'})
grid on
pname=['figs/sst_eq_am.png'];
print(pname,'-dpng')

