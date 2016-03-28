% parfor tests
N = 100;
parA = zeros(1,N);
tic;
rr = 0;
parfor i=1:N
   parA(i) = exp(i)*sin(i)+i;
   rr = i;
end
parT = toc;

A = zeros(1,N);

tic;
for i=1:N
    A(i) = exp(i)*sin(i)+i;
end
T = toc;