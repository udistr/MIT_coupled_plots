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
V={'SIarea' 'SIheff' 'SIhsnow' 'sIceLoad' 'SIuice' 'SIvice' 'SItaux' 'SItauy'};
%var=2
%level=1
collection='iceDiag';
filo=dir(['../mit_output/' collection '*.data']);
units='[m]';
msk=mygrid.mskC(:,:,1).*mygrid.RAC;
%  niter0=0;
%dt=4; %time steps per file
N=length(filo);
fignum=1;
fldTX=read_bin(['../mit_output/' filo(1).name],1,1)*0;
fldTY=read_bin(['../mit_output/' filo(1).name],1,1)*0;
area2=read_bin(['../mit_output/' filo(1).name],1,1)*0;
th=0.01;
for var=1:1
  fdate=fdate0; %datetime(2000,4,14,21,0,0);
%  startdate=datetime(2000,4,14,21,0,0);
%  enddtate=datetime(2010,4,14,21,0,0);
  i=1;
  while isbetween(fdate,fdate,enddate)
    if isbetween(fdate,startdate,enddate) & i<=length(filo)
      area=read_bin(['../mit_output/' filo(i).name],1,1);
      area(area<=th)=0;
      area(area>th)=1;
      area2=area2+area;
      fldTX=fldTX+read_bin(['../mit_output/' filo(i).name],1,5);
      fldTY=fldTY+read_bin(['../mit_output/' filo(i).name],1,6);
      area2=read_bin(['../mit_output/' filo(i).name],1,1);
      fdate 
      [V{var} ' ' num2str(i) ' ' num2str(max(fldTX/i))]
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
  fldTX=fldTX/(i-1).*mygrid.mskC(:,:,1);
  fldTY=fldTY/(i-1).*mygrid.mskC(:,:,1);
  [fldTZ,fldTM]=calc_UEVNfromUXVY(fldTX,fldTY);

    area2(area2==0)=NaN;
    area2(area2>0)=1;

    %zonal wind stress:
    fld=fldTZ.*area2;
    cc=[[-250:50:-100] [-75 -50] [-35:10:35] [50 75] [100:50:250]]/500; title0='zonal wind stress';
    figureL; m_map_gcmfaces(fld,2,{'myCaxis',cc},{'do_m_coast',1},{'myTitle',title0});
    x=get(gcf,'Children');
    x(2).Position=x(2).Position+[0 -0.15/2 0 0.15];
    x(1).Position=x(1).Position+[0 -0.05 0 0];
    y=get(gca);
    y.Title.Position=y.Title.Position+[0 0.05 0];
    title({'zonal ice velocity [m s^{-1}]',['mean=' num2str(round(nansum(fld.*msk)./nansum(msk)*1000)/1000) ]});

    pname='figs/Ice_SIuice_np';
    print(pname,'-dpng')

    %meridional wind stress:
    fld=fldTM.*area2;
    cc=[[-250:50:-100] [-75 -50] [-35:10:35] [50 75] [100:50:250]]/500; title0='meridional wind stress';
    figureL; m_map_gcmfaces(fld,2,{'myCaxis',cc},{'do_m_coast',1},{'myTitle',title0});
    x=get(gcf,'Children');
    x(2).Position=x(2).Position+[0 -0.15/2 0 0.15];
    x(1).Position=x(1).Position+[0 -0.05 0 0];
    y=get(gca);
    y.Title.Position=y.Title.Position+[0 0.05 0];
    title({'meridional ice velocity [m s^{-1}]',['mean=' num2str(round(nansum(fld.*msk)./nansum(msk)*1000)/1000) ]});

    pname='figs/Ice_SIvice_np';
    print(pname,'-dpng')


    %zonal wind stress:
    fld=fldTZ.*area2;
    cc=[[-250:50:-100] [-75 -50] [-35:10:35] [50 75] [100:50:250]]/2500; title0='zonal wind stress';
    figureL; m_map_gcmfaces(fld,3,{'myCaxis',cc},{'do_m_coast',1},{'myTitle',title0});
    x=get(gcf,'Children');
    x(2).Position=x(2).Position+[0 -0.15/2 0 0.15];
    x(1).Position=x(1).Position+[0 -0.05 0 0];
    y=get(gca);
    y.Title.Position=y.Title.Position+[0 0.05 0];
    title({'zonal ice velocity [m s^{-1}]',timerange,['mean=' num2str(round(nansum(fld.*msk)./nansum(msk)*1000)/1000) ]});

    pname='figs/Ice_SIuice_sp';
    print(pname,'-dpng')

    %meridional wind stress:
    fld=fldTM.*area2;
    cc=[[-250:50:-100] [-75 -50] [-35:10:35] [50 75] [100:50:250]]/2500; title0='meridional wind stress';
    figureL; m_map_gcmfaces(fld,3,{'myCaxis',cc},{'do_m_coast',1},{'myTitle',title0});
    x=get(gcf,'Children');
    x(2).Position=x(2).Position+[0 -0.15/2 0 0.15];
    x(1).Position=x(1).Position+[0 -0.05 0 0];
    y=get(gca);
    y.Title.Position=y.Title.Position+[0 0.05 0];
    title({'meridional ice velocity [m s^{-1}]',timerange,['mean=' num2str(round(nansum(fld.*msk)./nansum(msk)*1000)/1000) ]});

    pname='figs/Ice_SIvice_sp';
    print(pname,'-dpng')



end

	


