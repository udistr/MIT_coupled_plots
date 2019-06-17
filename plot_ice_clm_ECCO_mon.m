if ~exist('p')
  p = genpath('~/MATLAB/');
  addpath(p);

  %load nctiles_grid in memory:
  fout='~/data/geos5/MITGRID/llc90/';
  grid_load(fout,5,'compact',0,0)
  %displays list of grid variables:
  gcmfaces_global;% disp(mygrid);
end
V={ 'ETAN' 'SIarea' 'SIheff' 'SIhsnow' 'DETADT2' 'PHIBOT' 'sIceLoad' 'MXLDEPTH' 'oceSPDep' 'SIatmQnt' 'SIatmFW' 'oceQnet' 'oceFWflx' 'oceTAUX' 'oceTAUY' 'ADVxHEFF' 'ADVyHEFF' 'DFxEHEFF' 'DFyEHEFF' 'ADVxSNOW' 'ADVySNOW' 'DFxESNOW' 'DFyESNOW' 'SIuice' 'SIvice'};
collection='state_2d_set1';
filo=dir(['../../ECCO_v4_r2_ERA/diags/' collection '*.data']);
units='[m]';
msk=mygrid.mskC(:,:,1).*mygrid.RAC; msk(isnan(msk))=0;
%  niter0=0;
%dt=4; %time steps per file
N=length(filo);
th=0.001;
fignum=1;
fdate00=datetime(1992,1,1,0,0,0);
for mn=[3 9]
for var=[3 4 7];
  fdate=fdate00;
%  startdate=datetime(2006,4,14,21,0,0);
%  enddtate=datetime(2007,4,14,21,0,0);
  i=1;
  n=0;
  fld=read_bin(['../../ECCO_v4_r2_ERA/diags/' filo(1).name],1,1)*0;
  area2=read_bin(['../../ECCO_v4_r2_ERA/diags/' filo(i).name],1,2)*0;
  while isbetween(fdate,fdate,enddate)
    if isbetween(fdate,startdate,enddate) & i<=length(filo) & month(fdate)==mn
      area=read_bin(['../../ECCO_v4_r2_ERA/diags/' filo(i).name],1,2);
      area2=area2+area;      
      if var<=4; fld=fld+(read_bin(['../../ECCO_v4_r2_ERA/diags/' filo(i).name],1,var)./area); end
      if var>4; fld=fld+(read_bin(['../../ECCO_v4_r2_ERA/diags/' filo(i).name],1,var)); end
      fld(area<=th)=0;
      fdate 
      [V{var} ' ' num2str(i) ' ' num2str(nansum(fld.*msk)./nansum(msk))]
      n=n+1;
    end
    i=i+1;
    fdate=fdate+calmonths(1);
  end
  area2(area2./n<=th)=NaN;
  area=area2/n;
  area2(area2./n>=th)=1;
  fld=fld./n.*area2;
  h1=figure('Position',[60   259   560   420]);
  m_map_gcmfaces(fld,2)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
    if var==3 ; caxis([0 4]); end
    if var==4 ; caxis([0 1]); end
    if var==7 ; caxis([0 8e3]); end
  end
  nansum(fld.*msk)./nansum(msk)
  pname=['figs/Ice_' V{var} '_np_' num2str(mn) '_ECCO'];
  print(pname,'-dpng')

  h2=figure('Position',[640   259   560   420]);
  m_map_gcmfaces(fld,3)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
    if var==3 ; caxis([0 4]); end
    if var==4 ; caxis([0 1]); end
    if var==7 ; caxis([0 8e3]); end
  end
  nansum(fld.*msk)./nansum(msk)
  pname=['figs/Ice_' V{var} '_sp_' num2str(mn) '_ECCO'];
  print(pname,'-dpng')

  fld(isnan(fld))==0;
  eval(['fld2=fld_' V{var} '_' num2str(mn) '-fld;'])

  h1=figure('Position',[60   259   560   420]);
  m_map_gcmfaces(fld2,2)
  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
    if var==3 ; caxis([-4 4]); end
    if var==4 ; caxis([-1 1]); end
    if var==7 ; caxis([-8e3 8e3]); end
  end
  nansum(fld2.*msk)./nansum(msk)
  pname=['figs/Ice_' V{var} '_np_' num2str(mn) '_GEOS-ECCO'];
  print(pname,'-dpng')

  h2=figure('Position',[640   259   560   420]);
  m_map_gcmfaces(fld2,3)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
    if var==3 ; caxis([-4 4]); end
    if var==4 ; caxis([-1 1]); end
    if var==7 ; caxis([-8e3 8e3]); end
  end
  nansum(fld2.*msk)./nansum(msk)
  pname=['figs/Ice_' V{var} '_sp_' num2str(mn) '_GEOS-ECCO'];
  print(pname,'-dpng')


end


  h1=figure('Position',[60   259   560   420]);
  m_map_gcmfaces(area,2)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  caxis([0 1]);
  nansum(area.*msk)./nansum(msk)
  pname=['figs/Ice_SIarea_np_' num2str(mn) '_ECCO'];
  print(pname,'-dpng')

  h2=figure('Position',[640   259   560   420]);
  m_map_gcmfaces(area,3)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  caxis([0 1]);
  nansum(area.*msk)./nansum(msk)
  pname=['figs/Ice_SIarea_sp_' num2str(mn)  '_ECCO'];
  print(pname,'-dpng')

  eval(['fld2=fld_SIarea_' num2str(mn) '-area;'])

  h1=figure('Position',[60   259   560   420]);
  m_map_gcmfaces(fld2,2)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  caxis([-1 1]);
  nansum(fld2.*msk)./nansum(msk)
  pname=['figs/Ice_SIarea_np_' num2str(mn) '_GEOS-ECCO'];
  print(pname,'-dpng')

  h2=figure('Position',[640   259   560   420]);
  m_map_gcmfaces(fld2,3)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  caxis([-1 1]);
  nansum(fld2.*msk)./nansum(msk)
  pname=['figs/Ice_SIarea_sp_' num2str(mn) '_GEOS-ECCO'];
  print(pname,'-dpng')

	
end

