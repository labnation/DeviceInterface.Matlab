%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SmartScopeAnalogOutput - Uploads a custom analog waveform to the
% SmartScope and activates the analog output
%
% Prerequisites:
% - make sure SmartScopeConnect was executed succesfully first
%
% Usage:
% - just run this script
% - adjust the customWave contents and GeneratorSamplePeriod to your liking

% defines the content of the analog wave (directly in Voltages), making sure all values are withing the
% [0V, 3.3V] boundaries
% this code creates a simple multisine of 1000 points
customWave = sin(2*pi/1000*(1:1000)) + sin(4*pi/1000*(1:1000));
customWave = (customWave+2)/4*3.3;

%to be safe: first disable all outputs
scope.GeneratorToDigitalEnabled = 0;
scope.GeneratorToAnalogEnabled = 0;

%upload custom wave
scope.GeneratorDataDouble = customWave;

%set output frequency (in seconds)
scope.GeneratorSamplePeriod = 0.0000001;

%CommitSettings must be called to make the samplePeriod setting effective
scope.CommitSettings

%enable analog output
scope.GeneratorToAnalogEnabled = 1;