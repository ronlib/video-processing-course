function [du, dv] = LucasKanadeStep(I1, I2, WindowSize)

		[ix, iy] = gradient(I2);
		ixx = imfilter(ix.*ix, ones(WindowSize));
		iyy = imfilter(iy.*iy, ones(WindowSize));
		ixy = imfilter(ix.*iy, ones(WindowSize));
		it = I2 - I1;

		ixt = imfilter(ix.*it, ones(WindowSize));
		iyt = imfilter(iy.*it, ones(WindowSize));
		detA = ixx.*iyy -ixy.^2;
		du = -(iyy.*ixt-ixy.*iyt)./detA;
		dv = -(-ixy.*ixt + ixx.*iyt)./detA;
		du(isnan(du)) = 0;
		dv(isnan(dv)) = 0;

end
