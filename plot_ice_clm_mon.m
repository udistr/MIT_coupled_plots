if ~exist('p')
  p = genpath('~/MATLAB/');
  addpath(p);

  %load nctiles_grid in memory:
  fout='~/data/geos5/MITGRID/llc90/';
  grid_load(fout,5,'compact',0,0)
  %displays list of grid variables:
  gcmfaces_global;% disp(mygrid);
end
V={'SIarea' 'SIheff' 'SIhsnow' 'sIceLoad' 'SIuice' 'SIvice' 'SItaux' 'SItauy'};
collection='iceDiag';
filo=dir(['../mit_output/' collection '*.data']);
units='[m]';
msk=mygrid.mskC(:,:,1).*mygrid.RAC; msk(isnan(msk))=0;
%  niter0=0;
%dt=4; %time steps per file
N=length(filo);
th=0.001;
fignum=1;
for mn=[3 9]
for var=2:4
  fdate=fdate0;
%  startdate=datetime(2006,4,14,21,0,0);
%  enddtate=datetime(2007,4,14,21,0,0);
  fld=read_bin(['../mit_output/' filo(1).name],1,1)*0;
  area2=read_bin(['../mit_output/' filo(1).name],2,1)*0;
  i=1;
  n=0;
  while isbetween(fdate,fdate,enddate)
    if isbetween(fdate,startdate,enddate) & i<=length(filo) & month(fdate)==mn
      area=read_bin(['../mit_output/' filo(i).name],1,1);
      area2=area2+area;      
      if var<=4; fld=fld+(read_bin(['../mit_output/' filo(i).name],1,var)./area); end
      if var>4; fld=fld+(read_bin(['../mit_output/' filo(i).name],1,var)); end
      fld(area<=th)=0;
      fdate 
      [V{var} ' ' num2str(i) ' ' num2str(nansum(fld.*msk)./nansum(msk))]
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
  area2(area2./n<=th)=NaN;
  area=area2/n;
  area2(area2./n>=th)=1;
  fld=fld./n.*area2;
  h1=figure('Position',[60   259   560   420]);
  m_map_gcmfaces(fld,2)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
    if var==2 ; caxis([0 4]); end
    if var==3 ; caxis([0 1]); end
    if var==4 ; caxis([0 8e3]); end
  end
  nansum(fld.*msk)./nansum(msk)
  pname=['figs/Ice_' V{var} '_np_' num2str(mn)];
  print(pname,'-dpng')

  h2=figure('Position',[640   259   560   420]);
  m_map_gcmfaces(fld,3)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  for j=1:length(a) % for each subplot
    if var==2 ; caxis([0 4]); end
    if var==3 ; caxis([0 1]); end
    if var==4 ; caxis([0 8e3]); end
  end
  nansum(fld.*msk)./nansum(msk)
  pname=['figs/Ice_' V{var} '_sp_' num2str(mn)];
  print(pname,'-dpng')

  eval(['fld_' V{var} '_' num2str(mn) '=fld;'])

end


  h1=figure('Position',[60   259   560   420]);
  m_map_gcmfaces(area,2)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  caxis([0 1]);
  nansum(area.*msk)./nansum(msk)
  pname=['figs/Ice_SIarea_np_' num2str(mn)];
  print(pname,'-dpng')

  h2=figure('Position',[640   259   560   420]);
  m_map_gcmfaces(area,3)

  a=findall(gcf,'type','axes'); % Get each subplot in the figure
  caxis([0 1]);
  nansum(area.*msk)./nansum(msk)
  pname=['figs/Ice_SIarea_sp_' num2str(mn)];
  print(pname,'-dpng')

  area(isnan(area))==0;

  eval(['fld_SIarea_' num2str(mn) '=area;'])

	
end

