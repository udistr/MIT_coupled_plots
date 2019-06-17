if ~exist('p')
  p = genpath('~/MATLAB/');
  addpath(p);

  %load nctiles_grid in memory:
  fout='~/data/geos5/MITGRID/llc90/';
  grid_load(fout,5,'compact',0,0)
  %displays list of grid variables:
  gcmfaces_global;% disp(mygrid);
end
V1={'DFxE_TH','DFyE_TH','ADVx_TH','ADVy_TH','DFxE_SLT','DFyE_SLT','ADVx_SLT','ADVy_SLT'};
collection1='state_3d_set2';
filo1=dir(['../mit_output/' collection1 '*.data']);
V2={'SALT','THETA','UVELMASS','VVELMASS','WVELMASS','GM_PsiX','GM_PsiY'};
collection2='state_3d_set1';
filo2=dir(['../mit_output/' collection2 '*.data']);

msk=mygrid.mskC(:,:,1).*mygrid.RAC;
N=length(filo1);

tmpU=read_bin(['../mit_output/' filo1(1).name],1)*0;
tmpV=read_bin(['../mit_output/' filo1(1).name],1)*0;

sltU=read_bin(['../mit_output/' filo1(1).name],1)*0;
sltV=read_bin(['../mit_output/' filo1(1).name],1)*0;

fldU=read_bin(['../mit_output/' filo1(1).name],1)*0;
fldV=read_bin(['../mit_output/' filo1(1).name],1)*0;

GMU=read_bin(['../mit_output/' filo1(1).name],1)*0;
GMV=read_bin(['../mit_output/' filo1(1).name],1)*0;


fdate=fdate0;%datetime(2000,4,14,21,0,0);
%startdate=datetime(2000,4,14,21,0,0);
%enddate=datetime(2001,4,14,21,0,0);
i=1;
while isbetween(fdate,fdate,enddate)
  if isbetween(fdate,startdate,enddate) & i<=length(filo1)

    ADVx_TH=read_bin(['../mit_output/' filo1(i).name],3);
    ADVy_TH=read_bin(['../mit_output/' filo1(i).name],4);
    DFxE_TH=read_bin(['../mit_output/' filo1(i).name],1);
    DFyE_TH=read_bin(['../mit_output/' filo1(i).name],2);
    tmpU=tmpU+(ADVx_TH+DFxE_TH);
    tmpV=tmpV+(ADVy_TH+DFyE_TH);

    ADVx_SLT=read_bin(['../mit_output/' filo1(i).name],7);
    ADVy_SLT=read_bin(['../mit_output/' filo1(i).name],8);
    DFxE_SLT=read_bin(['../mit_output/' filo1(i).name],5);
    DFyE_SLT=read_bin(['../mit_output/' filo1(i).name],6);
    sltU=(ADVx_SLT+DFxE_SLT);
    sltV=(ADVy_SLT+DFyE_SLT);

    fldU=fldU+read_bin(['../mit_output/' filo2(i).name],3).*mygrid.mskW;
    fldV=fldV+read_bin(['../mit_output/' filo2(i).name],4).*mygrid.mskS;

    GMU=GMU+read_bin(['../mit_output/' filo2(i).name],6).*mygrid.mskW;
    GMV=GMV+read_bin(['../mit_output/' filo2(i).name],7).*mygrid.mskS;

    fdate 
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
tmpU=tmpU/(i-1).*mygrid.mskW;
tmpV=tmpV/(i-1).*mygrid.mskS;

sltU=sltU/(i-1).*mygrid.mskW;
sltV=sltV/(i-1).*mygrid.mskS;

fldU=fldU/(i-1).*mygrid.mskW;
fldV=fldV/(i-1).*mygrid.mskS;

GMU=GMU/(i-1);
GMV=GMV/(i-1);

[fldUbolus,fldVbolus,fldWbolus]=calc_bolus(GMU,GMV);
fldUbolus=fldUbolus.*mygrid.mskW; fldVbolus=fldVbolus.*mygrid.mskS;
fldUres=fldU+fldUbolus; fldVres=fldV+fldVbolus;

for bb=1:3
  %mask : global, atlantic or Pac+Ind
  if bb==1;       mskC=mygrid.mskC; mskC(:)=1; kk1=1;
  elseif bb==2;   mskC=v4_basin({'atlExt'}); mskC=mk3D(mskC,fldU); kk2=find(mygrid.LATS<-35|mygrid.LATS>70);
  elseif bb==3;   mskC=v4_basin({'pacExt','indExt'}); mskC=mk3D(mskC,fldU); kk3=find(mygrid.LATS<-35|mygrid.LATS>65);
  end

%compute meridional heat transports:
fldMT_H(:,bb)=1e-15*4e6*calc_MeridionalTransport(tmpU.*mskC(:,:,1:size(ADVx_TH{1},3)),tmpV.*mskC(:,:,1:size(ADVx_TH{1},3)),0);
%compute meridional fresh water transports:
fldMT_FW(:,bb)=1e-6*calc_MeridionalTransport(fldU.*mskC,fldV.*mskC,1);
%compute meridional salt transports:
fldMT_SLT(:,bb)=1e-6*calc_MeridionalTransport(sltU.*mskC(:,:,1:size(ADVx_TH{1},3)),sltV.*mskC(:,:,1:size(ADVx_TH{1},3)),0);

%compute overturning: eulerian contribution
fldOV(:,:,bb)=calc_overturn(fldU.*mskC,fldV.*mskC);
%compute overturning: eddy contribution
fldOVbolus(:,:,bb)=calc_overturn(fldUbolus.*mskC,fldVbolus.*mskC);
%compute overturning: residual overturn
fldOVres(:,:,bb)=calc_overturn(fldUres.*mskC,fldVres.*mskC);

end


msk1=ones(size(mygrid.LATS)); msk1(kk1,:)=NaN;
msk2=ones(size(mygrid.LATS)); msk2(kk2,:)=NaN;
msk3=ones(size(mygrid.LATS)); msk3(kk3,:)=NaN;

figureL;
fld=fldMT_H(:,1).*msk1;
plot(mygrid.LATS,fld,'LineWidth',2);
atl=fldMT_H(:,2).*msk2;
pacind=fldMT_H(:,3).*msk3;
hold on; 
plot(mygrid.LATS,atl,'r','LineWidth',2);
plot(mygrid.LATS,pacind,'g','LineWidth',2);
legend('global','Atlantic','Pacific+Indian','Location','SouthEast');
set(gca,'FontSize',14); grid on; %axis([-90 90 -2 2]);
title('Meridional Heat Transport (in PW)');

pname='figs/MeridionalTransport_heat';
print(pname,'-dpng')


figureL;
fld=fldMT_FW(:,1).*msk1;
plot(mygrid.LATS,fld,'LineWidth',2);
atl=fldMT_FW(:,2).*msk2;
pacind=fldMT_FW(:,3).*msk3;
hold on;
plot(mygrid.LATS,atl,'r','LineWidth',2);
plot(mygrid.LATS,pacind,'g','LineWidth',2);
legend('global','Atlantic','Pacific+Indian','Location','SouthEast');
set(gca,'FontSize',14); grid on; %axis([-90 90 -1.5 2.0]);
title({'Meridional Freshwater Transport (in Sv)',timerange});

pname='figs/MeridionalTransport_water';
print(pname,'-dpng')

figureL;
fld=fldMT_SLT(:,1).*msk1;
plot(mygrid.LATS,fld,'LineWidth',2);
atl=fldMT_SLT(:,2).*msk2;
pacind=fldMT_SLT(:,3).*msk3;
hold on;
plot(mygrid.LATS,atl,'r','LineWidth',2);
plot(mygrid.LATS,pacind,'g','LineWidth',2);
legend('global','Atlantic','Pacific+Indian','Location','SouthEast');
set(gca,'FontSize',14); grid on; %axis([-90 90 -50 50]);
title({'Meridional Salt Transport (in psu.Sv)',timerange});

pname='figs/MeridionalTransport_salt';
print(pname,'-dpng')


%meridional streamfunction (Eulerian) :
fld=fldOV(:,:,1).*repmat(msk1,1,size(fldOV(:,:,1),2)); fld(fld==0)=NaN;
X=mygrid.LATS*ones(1,length(mygrid.RF)); Y=ones(length(mygrid.LATS),1)*(mygrid.RF');
cc=[[-50:10:-30] [-24:3:24] [30:10:50]]; title0={'Meridional Stream Function',timerange};
figureL; set(gcf,'Renderer','zbuffer'); %set(gcf,'Units','Normalized','Position',[0.05 0.1 0.4 0.8]);
depthStretchPlot('pcolor',{X,Y,fld}); shading interp; cbar=gcmfaces_cmap_cbar(cc); title(title0);
set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);

pname='figs/MOC_Global_eulerian';
print(pname,'-dpng')


%meridional streamfunction (residual) :
fld=fldOVres(:,:,1).*repmat(msk1,1,size(fldOV(:,:,1),2)); fld(fld==0)=NaN;
X=mygrid.LATS*ones(1,length(mygrid.RF)); Y=ones(length(mygrid.LATS),1)*(mygrid.RF');
cc=[[-50:10:-30] [-24:3:24] [30:10:50]]; title0={'Meridional Stream Function (incl. GM)',timerange};
figureL; set(gcf,'Renderer','zbuffer'); %set(gcf,'Units','Normalized','Position',[0.05 0.1 0.4 0.8]);
depthStretchPlot('pcolor',{X,Y,fld}); shading interp; cbar=gcmfaces_cmap_cbar(cc); title(title0);
set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);

pname='figs/MOC_Global_residual';
print(pname,'-dpng')

%meridional streamfunction (Eulerian) :
fld=fldOV(:,:,2).*repmat(msk2,1,size(fldOV(:,:,1),2)); fld(fld==0)=NaN;
X=mygrid.LATS*ones(1,length(mygrid.RF)); Y=ones(length(mygrid.LATS),1)*(mygrid.RF');
cc=[[-50:10:-30] [-24:3:24] [30:10:50]]; title0={'Atlantic Meridional Stream Function',timerange};
figureL; set(gcf,'Renderer','zbuffer'); %set(gcf,'Units','Normalized','Position',[0.05 0.1 0.4 0.8]);
depthStretchPlot('pcolor',{X,Y,fld}); shading interp; cbar=gcmfaces_cmap_cbar(cc); title(title0);
set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);

pname='figs/MOC_Atl_eulerian';
print(pname,'-dpng')

%meridional streamfunction (residual) :
fld=fldOVres(:,:,2).*repmat(msk2,1,size(fldOV(:,:,1),2)); fld(fld==0)=NaN;
X=mygrid.LATS*ones(1,length(mygrid.RF)); Y=ones(length(mygrid.LATS),1)*(mygrid.RF');
cc=[[-50:10:-30] [-24:3:24] [30:10:50]]; title0={'Atlantic Meridional Stream Function (incl. GM)',timerange};
figureL; set(gcf,'Renderer','zbuffer'); %set(gcf,'Units','Normalized','Position',[0.05 0.1 0.4 0.8]);
depthStretchPlot('pcolor',{X,Y,fld}); shading interp; cbar=gcmfaces_cmap_cbar(cc); title(title0);
set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);

pname='figs/MOC_Atl_residual';
print(pname,'-dpng')

%meridional streamfunction (Eulerian) :
fld=fldOV(:,:,3).*repmat(msk3,1,size(fldOV(:,:,1),2)); fld(fld==0)=NaN;
X=mygrid.LATS*ones(1,length(mygrid.RF)); Y=ones(length(mygrid.LATS),1)*(mygrid.RF');
cc=[[-50:10:-30] [-24:3:24] [30:10:50]]; title0={'Pac+Ind Meridional Stream Function',timerange};
figureL; set(gcf,'Renderer','zbuffer'); %set(gcf,'Units','Normalized','Position',[0.05 0.1 0.4 0.8]);
depthStretchPlot('pcolor',{X,Y,fld}); shading interp; cbar=gcmfaces_cmap_cbar(cc); title(title0);
set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);

pname='figs/MOC_PacInd_eulerian';
print(pname,'-dpng')

%meridional streamfunction (residual) :
fld=fldOVres(:,:,3).*repmat(msk3,1,size(fldOV(:,:,1),2)); fld(fld==0)=NaN;
X=mygrid.LATS*ones(1,length(mygrid.RF)); Y=ones(length(mygrid.LATS),1)*(mygrid.RF');
cc=[[-50:10:-30] [-24:3:24] [30:10:50]]; title0={'Pac+Ind Meridional Stream Function (incl. GM)',timerange};
figureL; set(gcf,'Renderer','zbuffer'); %set(gcf,'Units','Normalized','Position',[0.05 0.1 0.4 0.8]);
depthStretchPlot('pcolor',{X,Y,fld}); shading interp; cbar=gcmfaces_cmap_cbar(cc); title(title0);
set(gca,'Position',get(gca,'Position')+[0 -0.03 0 0]);

pname='figs/MOC_PacInd_residual';
print(pname,'-dpng')
