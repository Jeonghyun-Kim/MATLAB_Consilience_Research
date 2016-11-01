function result = int_ellipse(r_x, r_y, y, rad)
result = real(sqrt((4 * r_x^2 * r_y^2 * (r_x^2 .* (cos(rad)).^2 + r_y^2 .* (sin(rad)).^2 - y.^2)) ./ ((r_x^2 .* (cos(rad)).^2 + r_y^2 .* (sin(rad)).^2).^2)));
end
