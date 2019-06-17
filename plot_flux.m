if ~exist('p')
  p = genpath('~/MATLAB/');
  addpath(p);

  %load nctiles_grid in memory:
  fout='~/data/geos5/MITGRID/llc90/';
  grid_load(fout,5,'compact',0,0)
  %displays list of grid variables:
  gcmfaces_global;% disp(mygrid);
end
%V={'oceQnet','oceQsw','oceFWflx','oceSflux','oceTAUX','oceTAUY','THETA','SALT','UVEL', 'VVEL'};
V={'oceTAUX','oceTAUY','oceFWflx','oceSflux','oceQnet','oceQsw',};
%var=2
%level=1
collection='state_2d_set1';
filo=dir(['../mit_output/' collection '*.data']);
units='[m]';
msk=mygrid.mskC(:,:,1).*mygrid.RAC; msk(isnan(msk))=0;
%  niter0=0;
%dt=4; %time steps per file
N=length(filo);

fignum=1;
for var=3:5
  fdate=fdate0;
%  startdate=datetime(2006,4,14,21,0,0);
%  enddtate=datetime(2007,4,14,21,0,0);
  fld=read_bin(['../mit_output/' filo(1).name],1,1)*0;
  i=1;
  n=0;
  while isbetween(fdate,fdate,enddate)
    if isbetween(fdate,startdate,enddate) & i<=length(filo)
      fld=fld+read_bin(['../mit_output/' filo(i).name],1,var);
      fdate 
      [V{var} ' ' num2str(i) ' ' num2str(sum(fld.*msk)./sum(msk))]
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
  fld=fld/n;
  figure
  if var==3 ; m_map_gcmfaces(fld*60*60*24,1.2) ; end
  if var==4 ; m_map_gcmfaces(fld*60*60*24,1.2) ; end
  if var==5 ; m_map_gcmfaces(fld,1.2) ; end

%  if var==3 ; title('Net fresh water flux [mm day^{-1}]'); end % oceFWflx
%  if var==4 ; title('Net salt flux [g m-2 s-1]'); end % oceSflux
%  if var==5 ; title('Net heat flux [W m-2]'); end % oceQflx

%mycmap = get(fig,'Colormap')
%set(fig,'Colormap',flipud(mycmap))

  if var==3; title({'Net fresh water flux [mm day^{-1}]',timerange,['mean=' num2str(round(nansum(fld*60*60*24.*msk)./nansum(msk)*1000)/1000) ]}); end
  if var==4; title({'Net salt flux [g m^{-2} day^{-1}]',timerange,['mean=' num2str(round(nansum(fld*60*60*24.*msk)./nansum(msk)*1000)/1000)]}); end
  if var==5; title({'Net heat flux [W m^{-2}]',timerange,['mean=' num2str(round(nansum(fld.*msk)./nansum(msk)*1000)/1000)]}); end

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
       if var==3 ; caxis(a(j),[-8,8]); end % oceFWflx
       if var==4 ; caxis(a(j),[-20,20]); end % oceSflux
       if var==5 ; caxis(a(j),[-200,200]); end % oceQflx
  end
  nansum(fld.*msk)./nansum(msk)
  pname=['figs/Flux_' V{var}];
  print(pname,'-dpng')

  eval(['fld_' V{var} '=fld;'])

end

	


