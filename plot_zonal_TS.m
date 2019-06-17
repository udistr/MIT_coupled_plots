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
V={'SALT','THETA','UVELMASS','VVELMASS'};
%var=2
%level=1
collection='state_3d_set1';
filo=dir(['../mit_output/' collection '*.data']);
units='[m]';
msk=mygrid.mskC(:,:,1).*mygrid.RAC;
%  niter0=0;
%dt=4; %time steps per file
N=length(filo);
fignum=1;
fldT=read_bin(['../mit_output/' filo(1).name],2)*0;
fldS=read_bin(['../mit_output/' filo(1).name],1)*0;
for var=1:1
  fdate=fdate0; %datetime(2000,4,14,21,0,0);
%  startdate=datetime(2000,4,14,21,0,0);
%  enddtate=datetime(2000,7,14,21,0,0);
  i=1;
  while isbetween(fdate,fdate,enddate)
    if isbetween(fdate,startdate,enddate) & i<=length(filo)
      tmpT=read_bin(['../mit_output/' filo(i).name],2);
      tmpS=read_bin(['../mit_output/' filo(i).name],1);
      fldT=fldT+tmpT;
      fldS=fldS+tmpS;
      fdate 
      [V{var} ' ' num2str(i) ' ' num2str(max(fldT/i))]
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
  fldT=fldT/(i-1).*mygrid.mskC;
  fldS=fldS/(i-1).*mygrid.mskC;

    [fldTzonmean]=calc_zonmean_T(fldT);
    [fldSzonmean]=calc_zonmean_T(fldS);


    figureL; set(gcf,'Renderer','zbuffer');
    X=mygrid.LATS*ones(1,length(mygrid.RC)); Y=ones(length(mygrid.LATS),1)*(mygrid.RC');
    %T
%    subplot(2,1,1);
    fld=fldTzonmean;
    depthStretchPlot('pcolor',{X,Y,fld}); shading interp;
    cc1=[0 1 2 3 5 7 10 13 16 19 22 25 28];
    cbar1=gcmfaces_cmap_cbar(cc1); title({'zonal mean temperature',timerange});
    set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);

    pname='figs/Zonmean_THETA';
    print(pname,'-dpng')
    %S
%    subplot(2,1,2);
    figureL; set(gcf,'Renderer','zbuffer');
    X=mygrid.LATS*ones(1,length(mygrid.RC)); Y=ones(length(mygrid.LATS),1)*(mygrid.RC');
    fld=fldSzonmean;
    depthStretchPlot('pcolor',{X,Y,fld}); shading interp;
    cc2=[[31.5:0.5:34] [34.2:0.1:35] [35.2:0.2:35.6]];
    cbar2=gcmfaces_cmap_cbar(cc2); title({'zonal mean salinity',timerange});
    set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);


    pname='figs/Zonmean_SALT';
    print(pname,'-dpng')



end

	


