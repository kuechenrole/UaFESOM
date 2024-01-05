vec = R(1:Nnodes).^2 + R(Nnodes+1:2*Nnodes).^2;
h = histogram(vec,10); h.Values
 ii = vec>=max(vec)-std(vec);
 vec(ii);
 x(ii); y(ii);
 %{ans =
%
   %1.0e+06 *

    %2.4507
    %2.4548


%ans =

   %1.0e+05 *

   %-7.8979
   %-7.9031
  