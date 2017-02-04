clc; clear all;

% acquire data from csv file
fileName = "Sensor_record_19700102_091331_AndroSensor.csv";
csvVal = csvread(fileName);
timeVal = csvVal(2:end,4);
magValX = csvVal(2:end,1).*10;
magValY = csvVal(2:end,2).*10;
magValZ = csvVal(2:end,3).*10;

% acquire upper and lower trim points by mouse clicks
figure();
plot(magValX);
hold on;
plot(magValY);
cuttingPoints = ginput(2);
lowerCut = ceil(cuttingPoints(1));
upperCut = floor(cuttingPoints(2));

% plot trimmed x and y values
close();
figure();
plot(magValX(lowerCut:upperCut), magValY(lowerCut:upperCut), 'r*', "markersize", 0.5);
axis("square");

% calculate fitting ellipse
results = fitellipse(magValX(lowerCut:upperCut), magValY(lowerCut:upperCut));
centerX = results(1);
centerY= results(2);
axisX = results(3);
axisY = results(4);
orientation = results(5);
if(axisX > axisY)
eccentricity = sqrt(1- (axisY^2) / (axisX^2));
error = distancePointToEllipse(magValX(lowerCut:upperCut), magValY(lowerCut:upperCut), axisX, axisY, centerX, centerY, orientation, 10^-6);
else
eccentricity = sqrt(1- (axisX^2) / (axisY^2));
error = distancePointToEllipse(magValX(lowerCut:upperCut), magValY(lowerCut:upperCut), axisY, axisX, centerX, centerY, orientation, 10^-6);
end
error = sum(error)/length(magValX(lowerCut:upperCut));

% draw fitting ellipse curve
hold on;
t = linspace(0, 2*pi, 1000);
x = axisX * cos(t); 
y = axisY * sin(t);
nx = x*cos(orientation)-y*sin(orientation) + centerX; 
ny = x*sin(orientation)+y*cos(orientation) + centerY;
plot(nx,ny);