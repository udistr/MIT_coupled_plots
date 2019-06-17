if ~exist('p')
  p = genpath('~/MATLAB/');
  addpath(p);
end
if ~exist('mygrid')
  %load nctiles_grid in memory:
  fout='~/data/geos5/MITGRID/llc90/';
  grid_load(fout,5,'compact',0,0)
  %displays list of grid variables:
  gcmfaces_global;% disp(mygrid);
end

fdate0=datetime(2000,4,14,0,0,0); % initialization date
startdate=datetime(2000,5,1,0,0,0); % beginning of climatology calculation
enddate=datetime(2010,4,31,0,0,0); % end of climatology calculation
timerange=[datestr(datetime(startdate,'Format','dd.MM.yyyy')) ' to ' datestr(datetime(enddate,'Format','dd.MM.yyyy'))]
NDT=1;
DT='day';
% plot time sereis of global properties
ts
% plot heat, water and salt flux maps
plot_flux
plot_flux_ECCO
% plot momentum flux map
plot_tau

% zonal mean of tempearatue and saliniy
plot_zonal_TS
% Meridional transport and stream functions
plot_MeridionalTransport

% ice velocity
plot_uvice
% ice fraction and thickness

plot_ice

%startdate=datetime(2004,5,1,0,0,0); % beginning of climatology calculation
plot_ice_clm_mon
plot_ice_clm_ECCO_mon
plot_ice_clm
plot_ice_clm_ECCO



