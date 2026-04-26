function [ f ] = inputManual( t )
	% Write your own equation here.
	
	%---------- This is an example of something you could do to create a discontinuous function.
	  
    if (t <= 0)
		f = 0;
	else
		f = 1;
    end
	%-----------
end
