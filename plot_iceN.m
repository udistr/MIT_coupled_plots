if ~exist('p')
  p = genpath('/home/estrobac/MATLAB/');
  addpath(p);

  %load nctiles_grid in memory:
  fout='~/data/MITgcm/';
  grid_load(fout,5,'compact',0,0)
  %displays list of grid variables:
  gcmfaces_global;% disp(mygrid);
end
V={'SIareaN' 'SIheffN' 'SIhsnowN'};
%var=2
%level=1

collection='iceNcat';
filo=dir(['../mit_output/' collection '*.data']);

ndays=10;
N=floor(length(filo)/24/ndays)*24*ndays
fld=repmat(read_bin(['../mit_output/' filo(1).name],2,1),[1 1 24*ndays])*0;
a=[0 0.7 ; 0.6 1.45 ; 1.35 2.5 ; 2.4 4.6 ; 4.5 15];
for var=2:3
  for level=5:-1:1  
    for i=1:(N/24/ndays)
	    for j=1:(24*ndays)
		    fld(:,:,j)=read_bin(['../mit_output/' filo((i-1)*24*ndays+j).name],1,5*(var-1)+level)./read_bin(['../mit_output/' filo((i-1)*24*ndays+j).name],1,level);
		    [V{var} ' ' num2str(level) ' ' num2str(i) ' ' num2str(j) ' ' num2str(max(fld(:,:,j)))]
	    end
	    figure(i)
	    m_map_gcmfaces(mean(fld,3),1.2)
      caxis(a(level,:))
	    title([V{var} ' level ' num2str(level) ' day ' num2str((i-1)*ndays+5) 'max: ' num2str(max(mean(fld,3)))])
      pname=['figs/' V{var} '_level_' num2str(level) '_day_' num2str((i-1)*ndays+5)];
      print(pname,'-dpng')
    end
  end
end

	


