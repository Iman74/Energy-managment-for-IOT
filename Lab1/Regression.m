clc
%%
M= 1;
N = size(idleP,2);
x1= idleP(M,1:N-1);
x2= activeP(M,1:N-1);
y = idleP(M,2:N);

%% Fit
[xData, yData, zData] = prepareSurfaceData( x1, x2, y );
% Set up fittype and options.
ft = fittype( 'a + b*x   + c*x^2   + d*y^2', 'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.474662969993381 0.187584947206236 0.464466964322128 0.932089536286421];

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
fitresult
%%
%p = polyfitn([x1,x2],y,2)

%x1 = sort(x);
%y1 = polyval(p,x1);
%error=abs(y-y1)./y;
%sum(error)
%plot(x,y,'o')
%hold on
%plot(x1,y1)
%hold off