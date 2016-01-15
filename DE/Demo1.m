% Demo 1

nAgents = 20;
maxIter = 100;
CR = 0.5;
F = 1.5;
seed = 123;

optimStruct = generateOptimStruct(nAgents,maxIter,CR,F,seed);

% example 1
f = @(x) x.^4 - x.^2;
[obj1,par1] = DEoptim(f,optimStruct,[-5,-2]);

% example 2
f = @(x) x(:,1).^4 - x(:,1).^2 + abs(x(:,1)+x(:,2)) + sin(x(:,2));
[obj2,par2] = DEoptim(f,optimStruct,[-5,5],[-5,5],'example2.csv');

% example 3
f = @(x) abs(x) + sin(x) - x.^2  + exp(abs(x));
[obj3,par3] = DEoptim(f,optimStruct,[-5,5],'example3.csv');

