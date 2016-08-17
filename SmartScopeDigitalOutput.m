%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SmartScopeDigitalOutput - Uploads a custom digital waveform to the
% SmartScope and activates the digital output
%
% Prerequisites:
% - make sure SmartScopeConnect was executed succesfully first
%
% Usage:
% - just run this script
% - adjust the customWave contents, GeneratorSamplePeriod and digital
% output voltage to your liking


% defines content of digital wave.
% first all 4 outputs separately will generate 2 pulses, afterwards all 4
% outputs will simultaneously generate 1 longer pulse
customWave = [0 1 0 1 0 2 0 2 0 4 0 4 0 8 0 8 0 0 0 15 15 15 15 15 0 0 0];

%to be safe: first disable all outputs
scope.GeneratorToDigitalEnabled = 0;
scope.GeneratorToAnalogEnabled = 0;

%upload custom wave
scope.GeneratorDataByte = customWave;

%set output frequency
scope.GeneratorSamplePeriod = 0.000005;

%set output voltage to 3V or 5V
scope.SetDigitalOutputVoltage(DigitalOutputVoltage.V3_0);

%CommitSettings must be called to make the samplePeriod setting effective
scope.CommitSettings

%enable digital output
scope.GeneratorToDigitalEnabled = 1;