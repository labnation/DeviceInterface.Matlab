%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SmartScopePlot - Stops the scope and fetches the full contents 
% of the RAM and plots iot in a graph. 
% Also grabs some timing parameters.
%
% Prerequisites:
% - make sure SmartScopeConnect was executed succesfully first
%
% Usage:
% - just run this script
%
% Good to know:
% - after running this script, type 'scope'
%   to see which parameters are exposed by the scope
% - after running this script, type 'scope.DataSourceScope.LatestDataPackage'
%   to see which parameters are exposed by the most recently acquired
%   datapackage

% first start the scope
scope.Running = true;
scope.CommitSettings();

pause(0.01)

% now stop the scope. This will automatically cause the contents of the RAM
% being loaded into scope.LatestDataPackage
scope.Running = false;
scope.CommitSettings();

% the RAM transfer can take a couple of seconds. wait until the transfer is
% complete
while (scope.DataSourceScope.LatestDataPackage.FullAcquisitionFetchProgress < 1)
    pause(0.01)
end

 %get the full acquisition
 d = scope.DataSourceScope.LatestDataPackage.GetData(ChannelDataSourceScope.Acquisition, AnalogChannel.ChA);

 %convert .NET array to matlab numbers
 voltages = d.array.double;

 %extract timing data
 numberOfSamples = size(voltages,2);
 samplePeriod = d.samplePeriod;
 triggerOffset = scope.DataSourceScope.LatestDataPackage.Holdoff; %relative to beginning of data
 timeAxis=(0:samplePeriod:(numberOfSamples-1)*samplePeriod) - triggerOffset; 

 %plot
 plot(timeAxis, voltages)
 xlabel('Time relative to trigger position (s)')
 ylabel('Voltage (V)')
 drawnow
