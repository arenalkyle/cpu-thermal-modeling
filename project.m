clc; clear;

% Simulation Parameters
n = 1000;               % Amount of times simulation is ran
totalTime = 500;        % How long the load is tested
dt = 0.01;              % Accurate real-life behavior would be in the range of milliseconds (0.001 - 0.01)

% CPU Specs (I chose an i7-12700k to model this after with a low end cooling system)
freq = 3.6;             % CPU frequency in GHz
freqBase = 3.6;         % Base CPU frequency
powerIdle = 30;         % Power (W) it consumes while idle (0%)
powerMax = 190;         % Max power consumed by the system

% CPU Specs (My own Ryzen 7 7800x3D)
%freq = 3.6;
%freqBase = ;
%powerIdle = ;
%powerMax = ;

% Thermal Values
roomTemp = 24;          % Room temperature (Celcius -> 24C = 75.2F)
idleTemp = 35;          % CPU's idle temp
maxTemp = 100;          % Max temperature before it throttles (~100 degrees Celcius for most CPUs)
throttleToTemp = 90;    % What temperature do you want to throttle down to before providing CPU full power again
tau = 10;               % Thermal time constant (Low-end cooler 5-15, mid-range 15-25, high-end cooler 25-40)
thermalResist = 0.42;   % Thermal resistance (Low-end cooler 0.30-0.50, mid-range 0.20-0.30, high-end cooler 0.10-0.20)


thermalResistanceValues = thermalResist * (1 + 0.1 * randn(n, 1));
roomTempSamples = roomTemp + 2 * randn(n, 1);
loadProfile = @(t) calculateLoad(t);


%% Create memory for results
tempMaxArray = zeros(n, 1);
loadMaxArray = zeros(n, 1);
throttleTimes = zeros(n, 1);


%% Monte Carlo loop
for i = 1:n
    
    % Find maximum safe load for this Monte Carlo sample using bisection
    loadMax = bisection(@(L) eqTemp(L, freq, freqBase, powerIdle, powerMax, thermalResistanceValues(i), roomTempSamples(i)) - maxTemp, 0, 1, 1e-3, 50);
    loadMaxArray(i) = loadMax;
    
    % Simulate temperature over time under a sample load profile
    [T,timeToThrottle] = eulerTempSim(loadProfile, totalTime, dt, powerIdle, powerMax, thermalResistanceValues(i), roomTempSamples(i), idleTemp, maxTemp, throttleToTemp, freq, freqBase, tau);
    
    % Record maximum temperature and throttle duration
    tempMaxArray(i) = max(T);
    throttleTimes(i) = timeToThrottle;
end


%% Display Monte Carlo summary
fprintf('Max Temperature: Mean = %.2f C, Std = %.2f C\n', mean(tempMaxArray), std(tempMaxArray));
fprintf('Max Safe Load: Mean = %.2f, Std = %.2f\n', mean(loadMaxArray), std(loadMaxArray));
fprintf('Throttle Duration: Mean = %.2f s, Std = %.2f s\n', mean(throttleTimes), std(throttleTimes));


%% Plot example simulation for first Monte Carlo run
figure;
[T_example, ~, timeVec] = eulerTempSim(loadProfile, totalTime, dt, powerIdle, powerMax, thermalResist, roomTemp, idleTemp, maxTemp, throttleToTemp, freq, freqBase, tau);
plot(timeVec,T_example, 'LineWidth', 1.5);
xlabel('Time (s)'); 
ylabel('CPU Temperature (C)');
title('CPU Temperature Over Time - Example Run');
grid on;

