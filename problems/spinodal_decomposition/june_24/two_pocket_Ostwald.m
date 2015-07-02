%standard version for layer creation
grid_dimension = 50
Y = (1:grid_dimension)' ;
Matrix = ones(grid_dimension);
%if the coefficient is too high, it may have a convergence problem in MOOSE
   
r = 1;
Nx = 20;
Ny=Nx;
x = linspace(-1,1,Nx);
y = linspace(-1,1,Ny);
[X,Y] = meshgrid(x,y);
R = sqrt(X.^2 + Y.^2);
numel(R);

for idx = 1:numel(R)
  element=R(idx);
   if element > 1
      R(idx)=1;
   elseif element <1
       R(idx) = -1;
  end
end
Matrix(1:1+Nx-1,1:1+Nx-1) =R
%bubble2
r = 1;
Nx = 5;
Ny=Nx;
x = linspace(-1,1,Nx);
y = linspace(-1,1,Ny);
[X,Y] = meshgrid(x,y);
R = sqrt(X.^2 + Y.^2);
numel(R);

for idx = 1:numel(R)
  element=R(idx);
   if element > 1
      R(idx)=1;
   elseif element <1
       R(idx) = -1;
  end
end

R
z = 25
Matrix(z:z+Nx-1,z:z+Nx-1) =R
Matrix


Y = (1:grid_dimension)' ;
M1 = cat(2,Y,Matrix);

X = (1:grid_dimension+1);
X(grid_dimension+1) = 0;
z = int2str(i)
Final = cat(1,X, M1);
w = 'double_bubble'
csvwrite(strcat('~/projects/mantis/problems/spinodal_decomposition/june_25_milestone?/',w),Final)
