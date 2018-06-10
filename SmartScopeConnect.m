%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SmartScopeConnect - Connects and initializes the SmartScope using Matlab
%
% Prerequisites:
% - make sure the latest SmartScope software has been installed on this machine
% - make sure the first line of code refers to the correct location of LabNation.DeviceInterface.dll
% - make sure no other program is currently accessing the SmartScope
% - make sure a SmartScope is attached to this machine
%
% Usage:
% - just run the thing and you'll hear the SmartScope click hello
% - now hook up a 10kHz signal to ChA
% - run SmartScopePlot to see the results visualized in a graph
%
% Good to know:
% - you can only link to the .NET assembly and scope once (Matlab limitation). Therefore, that code is enclosed inside the if clause below
%
% Tested on Matlab R2014a_64b+Windows8_64b

libPath = 'C:\Program Files (x86)\LabNation\SmartScope\DeviceInterface.dll';

if (~exist('asm'))
    asm = NET.addAssembly(libPath);
    import LabNation.DeviceInterface.Devices.*
    import LabNation.DeviceInterface.DataSources.*    
end

%connect to the scope
disp ('Searching for SmartScope...')
devManager = LabNation.DeviceInterface.Devices.DeviceManager();
devManager.Start(false);

while (~devManager.SmartScopeConnected)
    pause(1);    
end
disp ('SmartScope found!')

scope = devManager.MainDevice;

%follow same initialisation script as the ConsoleDemo at https://github.com/labnation/console-demo
%ideally suited for any signal around 10kHz crossing the 0.5V level
scope.Running = false;
scope.CommitSettings();

scope.DataSourceScope.Start();

%define timebase and trigger position
scope.AcquisitionLength = 0.001; 
scope.TriggerHoldOff = 0.0005;  %relative to first sample

% set optimal configuration for analog scoping
scope.Rolling = false;
scope.SendOverviewBuffer = false;
scope.AcquisitionMode = AcquisitionMode.AUTO;
scope.PreferPartial = false;
scope.SetViewPort (0, scope.AcquisitionLength);

%define ChannelA input
scope.SetVerticalRange (AnalogChannel.ChA, -3, 3);
scope.SetYOffset (AnalogChannel.ChA, 0);
scope.SetCoupling (AnalogChannel.ChA, Coupling.DC);
AnalogChannel.ChA.SetProbe(LabNation.DeviceInterface.Devices.Probe.DefaultX1Probe);

%define ChannelB input
scope.SetVerticalRange (AnalogChannel.ChB, -3, 3);
scope.SetYOffset (AnalogChannel.ChB, 0);
scope.SetCoupling (AnalogChannel.ChB, Coupling.DC);
AnalogChannel.ChB.SetProbe(LabNation.DeviceInterface.Devices.Probe.DefaultX1Probe);

%define trigger
tv = TriggerValue();
tv.source = TriggerSource.Channel;
tv.channel = AnalogChannel.ChA;
tv.edge = TriggerEdge.RISING;
tv.level = 0.5;
scope.TriggerValue = tv;

%go!
scope.CommitSettings();
scope.Running = true;
scope.CommitSettings();