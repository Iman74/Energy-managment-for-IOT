function [fitresult, gof] = createFit1(x1, x2, y)
%CREATEFIT1(X1,X2,Y)
%  Create a fit.
%
%  Data for 'EMfIOT' fit:
%      X Input : x1
%      Y Input : x2
%      Z Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 05-Jan-2021 22:02:25


%% Fit: 'EMfIOT'.
[xData, yData, zData] = prepareSurfaceData( x1, x2, y );

% Set up fittype and options.
ft = fittype( 'a + b*x   + c*x^2   + d*y + e*y^2', 'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.711885641051903 0.187599656508401 0.572722417351146 0.501095120626788 0.860988381295247];

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

% Plot fit with data.
figure( 'Name', 'EMfIOT' );
h = plot( fitresult, [xData, yData], zData );
legend( h, 'EMfIOT', 'y vs. x1, x2', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x1', 'Interpreter', 'none' );
ylabel( 'x2', 'Interpreter', 'none' );
zlabel( 'y', 'Interpreter', 'none' );
grid on
view( -90.8, -0.9 );

