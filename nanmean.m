function y=nanmean(x,dim)

switch nargin
  case 1

		x(isnan(x))=0;
		msk=x;
		msk(~isnan(x))=1;
		y=sum(x.*msk)./sum(msk);

	case 2

		x(isnan(x))=0;
		msk=x;
		msk(~isnan(x))=1;
		y=sum(x.*msk,dim)./sum(msk,dim);

end

end
