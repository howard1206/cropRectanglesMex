function build_cropRectanglesMex( cudaRoot )
%build_cropRectanglesMex builds package cropRectanglesMex
%
% INPUT:
%   cudaRoot - path to the CUDA installation

% Anton Osokin, firstname.lastname@gmail.com, May 2015

if ~exist('cudaRoot', 'var')
    cudaRoot = '/usr/cuda-7.0' ;
end
nvccPath = fullfile(cudaRoot, 'bin', 'nvcc');
if ~exist(nvccPath, 'file')
    error('NVCC compiler was not found!');
end

root = fileparts( mfilename('fullpath') );

% compiling
compileCmd = [ '"', nvccPath, '"', ...
        ' -c ', fullfile(root,'cropRectanglesMex.cu'), ... 
        ' -I"', fullfile( matlabroot, 'extern', 'include'), '"', ...
        ' -I"', fullfile( matlabroot, 'toolbox', 'distcomp', 'gpu', 'extern', 'include'), '"', ...
        ' -I"', fullfile( cudaRoot, 'include'), '"', ...        
        ' -DNDEBUG -DENABLE_GPU', ...
        ' -Xcompiler', ' -fPIC', ...
        ' -o "', fullfile(root,'cropRectanglesMex.o'), '"'];
system( compileCmd );

% linking
mopts = {'-outdir', root, ...
         '-output', 'cropRectanglesMex', ...
         ['-L', fullfile(cudaRoot, 'lib64')], ...
         '-lcudart', '-lnppi', '-lnppc', '-lmwgpu', ...
         '-largeArrayDims', ...
         fullfile(root,'cropRectanglesMex.o') };
mex(mopts{:}) ;

delete( fullfile(root,'cropRectanglesMex.o') );
        