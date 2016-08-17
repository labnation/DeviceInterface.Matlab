%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SmartScopePlot - Fetches a couple of data sequences from the SmartScope
% and plots them in a graph. Also grabs some timing parameters.
%
% Prerequisites:
% - make sure SmartScopeConnect was executed succesfully first
%
% Usage:
% - just run this script
% - if 5000 frames are too much, hit Ctrl+C
%
% Good to know:
% - after running this script, type 'scope'
%   to see which parameters are exposed by the scope
% - after running this script, type 'scope.DataSourceScope.LatestDataPackage'
%   to see which parameters are exposed by the most recently acquired
%   datapackage

for i=1:1000
     %get latest ChannelData
     d = scope.DataSourceScope.LatestDataPackage.GetData(ChannelDataSourceScope.Viewport, AnalogChannel.ChA);

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
end