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
%var=2
%level=1
collection='iceDiag';
filo=dir(['../mit_output/' collection '*.data']);
units='[m]';
%  niter0=0;
%dt=3; %time steps per file (hours)
N=length(filo);
fignum=1;
for var=1:1
  fdate=fdate0; %datetime(2000,4,14,21,0,0);
  i=1;
  th=0.01;
  while i<=N
		if ~isbetween(fdate,startdate,enddate)
			if strcmp(DT,'hour')
			 	fdate=fdate+hours(NDT);
			ndt=24;
			elseif strcmp(DT,'day')
			 	fdate=fdate+days(NDT);
			ndt=1;
			elseif strcmp(DT,'month')
			 	fdate=fdate+calmonths(NDT);
			elseif strcmp(DT,'year')
			 	fdate=fdate+calyears(NDT);
			end  
			i=i+1;
		else
		  fld=read_bin(['../mit_output/' filo(i).name],1,1)*0;
		  area2=read_bin(['../mit_output/' filo(i).name],1,1)*0;
		  n=1;
		  fmonth=month(fdate);
		  fyear=year(fdate);
		  m=fmonth;
		  fmonths=sprintf('%02d',fmonth);
		  while m==fmonth && i<=N
		    area=read_bin(['../mit_output/' filo(i).name],1,1);
		    area(area<=th)=NaN;
		    area2=area2+area;      
		    if var<=4&&var>1
		      fld=fld+(read_bin(['../mit_output/' filo(i).name],1,var)./area);
		    else 
		      fld=fld+(read_bin(['../mit_output/' filo(i).name],1,var)); 
		    end
		    [V{var} ' ' num2str(i) ' ' num2str(n) ' ' datestr(fdate) ' ' num2str(max(fld/n))]
				if strcmp(DT,'hour')
				 	fdate=fdate+hours(NDT);
				ndt=24;
				elseif strcmp(DT,'day')
				 	fdate=fdate+days(NDT);
				ndt=1;
				elseif strcmp(DT,'month')
				 	fdate=fdate+calmonths(NDT);
				elseif strcmp(DT,'year')
				 	fdate=fdate+calyears(NDT);
				end  
		    m=month(fdate);
		    n=n+1;
		    i=i+1;
		  end
		  n-1
		  if ((n-1)/(ndt/NDT)==eomday(fyear,fmonth))
		    area2(area2./n<=th)=NaN;
		    area2(area2./n>=th)=1;
		    fld=fld./n.*area2;
		    h1=figure('Visible','off','Position',[60   259   560   420]);
		    %set(h1,'Visible','off')
		    y=mean(fld,3);
		    m_map_gcmfaces(y,2)
		    varname=V{var};
		    if var==1 ; caxis([0 1]); end
		    if var==2 ; caxis([0 4]); end
		    if var==3 ; caxis([0 1]); end
		    if var==4 ; caxis([0 8e3]); end
		    if var==5 ; caxis([-0.5 0.5]); end
		    if var==6 ; caxis([-0.5 0.5]); end
		    if var==7 ; caxis([-0.1 0.1]); end
		    if var==8 ; caxis([-0.1 0.1]); end

		    title({[varname ' ' units ' ' num2str(fyear) '-' num2str(fmonths)],' '}) % ' max: ' num2str(max(y))
		    pname=['figs/Ice_' varname '_np_' num2str(fyear) '_' num2str(fmonths)];
		    print(pname,'-dpng')
		    close(h1)
		    h2=figure('Visible','off','Position',[640   259   560   420]);
		    %set(h1,'Visible','on')
		    y=mean(fld,3);
		    m_map_gcmfaces(y,3)
		    if var==1 ; caxis([0 1]); end
		    if var==2 ; caxis([0 3]); end
		    if var==3 ; caxis([0 1]); end
		    if var==4 ; caxis([0 4e3]); end
		    if var==5 ; caxis([-0.5 0.5]); end
		    if var==6 ; caxis([-0.5 0.5]); end
		    if var==7 ; caxis([-0.1 0.1]); end
		    if var==8 ; caxis([-0.1 0.1]); end
		    title({[varname ' ' units ' ' num2str(fyear) '-' num2str(fmonths)],' '}) % ' max: ' num2str(max(y))
		    pname=['figs/Ice_' varname '_sp_' num2str(fyear) '_' num2str(fmonths)];
		    print(pname,'-dpng')
		    fignum=fignum+2;
		    close(h2)
		  end
		end
  end
  system(['./mov_list.sh Ice_' varname])
end


	


