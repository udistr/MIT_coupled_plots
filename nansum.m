function y=nansum(x,dim)

switch nargin
  case 1

    msk=x;
		msk(~isnan(x))=1;
	  msk(isnan(x))=0;
		x(isnan(x))=0;
		y=sum(x.*msk);


	case 2

		msk=x;
		msk(~isnan(x))=1;
		msk(isnan(x))=0;
		x(isnan(x))=0;
		y=sum(x.*msk,dim);

end

end
