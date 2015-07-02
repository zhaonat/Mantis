file_name = 'RTI.txt'
grid_dimension = 10
fid = fopen(file_name,'w');
Matrix = [];

thickness = grid_dimension/layer_number
counter = 0;
l = grid_dimension/2
for z = 1:grid_dimension
sub = ones(grid_dimension,grid_dimension);
%layer formation
    r = 1;
    Nx = l;
    Ny = l;
    x = linspace(-1,1,Nx);
    y = linspace(-1,1,Ny);
    [X,Y] = meshgrid(x,y);
    R = sqrt(X.^2 + Y.^2);
    numel(R)

    for idx = 1:numel(R)
    element=R(idx);
        if element > 1
            R(idx)=1;
         elseif element <1
            R(idx) = -1;
        end
    end
    R;
    sub(10:10+l-1,10:10+l-1)=R
   


sub

counter = counter +1
if (counter>=2*thickness)
    counter = 0;
end

Matrix = cat(1,Matrix,sub);
dlmwrite(file_name,Matrix, ' ');

M = csvread(file_name);
dlmwrite(file_name, M, 'delimiter', ' ', 'precision', '%ld');
end



%%layer formation complete