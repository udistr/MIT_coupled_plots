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
%var=2
%level=1
collection='state_2d_set1';
filo=dir(['../../ECCO_v4_r2_ERA/diags/' collection '*.data']);
units='[m]';
msk=mygrid.mskC(:,:,1).*mygrid.RAC; msk(isnan(msk))=0;
%  niter0=0;
%dt=4; %time steps per file
N=length(filo);

fignum=1;
  fdate00=datetime(1992,1,1,0,0,0);
for var=12:13
  fdate=fdate00;
%  startdate=datetime(2006,4,14,21,0,0);
%  enddtate=datetime(2007,4,14,21,0,0);
  fld=read_bin(['../../ECCO_v4_r2_ERA/diags/' filo(1).name],1,1)*0;
  i=1;
  n=0;
  while isbetween(fdate,fdate,enddate)
    if isbetween(fdate,startdate,enddate) & i<=length(filo)
      fld=fld+read_bin(['../../ECCO_v4_r2_ERA/diags/' filo(i).name],1,var);
      fdate 
      [V{var} ' ' num2str(i) ' ' num2str(sum(fld.*msk)./sum(msk))]
      n=n+1;
    end
    i=i+1;
    fdate=fdate+calmonths(1);
  end
  fld=fld/n;
  figure
  if var==13 ; m_map_gcmfaces(fld*60*60*24,1.2) ; end
  if var==12 ; m_map_gcmfaces(fld,1.2) ; end

  if var==13; title({'Net fresh water flux [mm day^{-1}]',timerange,['mean=' num2str(round(nansum(fld*60*60*24.*msk)./nansum(msk)*1000)/1000) ]}); end
  if var==12; title({'Net heat flux [W m^{-2}]',timerange,['mean=' num2str(round(nansum(fld.*msk)./nansum(msk)*1000)/1000)]}); end

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
       if var==13 ; caxis(a(j),[-8,8]); end % oceFWflx
       if var==12 ; caxis(a(j),[-200,200]); end % oceQflx
  end
  nansum(fld.*msk)./nansum(msk)
  pname=['figs/Flux_' V{var} '_ECCO'];
  print(pname,'-dpng')

  if var==13 ; eval(['fld2=fld_oceFWflx-fld;']) ; end
  if var==12 ; eval(['fld2=fld_oceQnet-fld;']) ; end

  figure
  if var==13 ; m_map_gcmfaces(fld2*60*60*24,1.2) ; end
  if var==12 ; m_map_gcmfaces(fld2,1.2) ; end

  if var==13; title({'Net fresh water flux [mm day^{-1}]',timerange,['mean=' num2str(round(nansum(fld*60*60*24.*msk)./nansum(msk)*1000)/1000) ]}); end
  if var==12; title({'Net heat flux [W m^{-2}]',timerange,['mean=' num2str(round(nansum(fld2.*msk)./nansum(msk)*1000)/1000)]}); end

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
       if var==13 ; caxis(a(j),[-8,8]); end % oceFWflx
       if var==12 ; caxis(a(j),[-200,200]); end % oceQflx
  end
  nansum(fld2.*msk)./nansum(msk)
  pname=['figs/Flux_' V{var} '_GEOS-ECCO'];
  print(pname,'-dpng')

end

