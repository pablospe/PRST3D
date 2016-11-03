%
% Volumen             % 3D Image
% rho_spacing = 5     % sampling translation
% theta_spacing = 5   % sampling orientation (in degree)
% phi_spacing = 5     % sampling translation (in degree)
%
function hough_space = compute_PRST_random_sampling(V,rho_spacing, ...
                                                    theta_spacing, ...
                                                    phi_spacing, ...
                                                    n_samples, ...
                                                    th_max, ...
                                                    phi_max, ...
                                                    type)

    % default arg: n_samples = 1000
    if ~exist('n_samples','var'), n_samples = 1000; end
%     if ~exist('th_max','var'), th_max = 90; end
%     if ~exist('phi_max','var'), phi_max = 360; end
    if ~exist('type','var'), type = ''; end

    % A function in a d-dimensional space
    f = V;

    % normalize f such as || f || = 1
    f_vec = double(f(:));
    f_norm = norm(f_vec);
    f = f / f_norm;

    % size
    n = size(f);

    % r_max = n*sqrt(2)
    r_max = round(max(n) * sqrt(2));

    % rho, theta and phi domains
    rho = -r_max:rho_spacing:r_max;
    th  = deg2rad(0:theta_spacing:th_max);
    phi = deg2rad(0:phi_spacing:phi_max);

    % compute PRST (Random Sampling)
    k = find(f);
    n_pts = length(k);
    rho_vector  = zeros(1,n_pts);
    th_vector   = zeros(1,n_pts);
    phi_vector  = zeros(1,n_pts);
    PRST_vector = zeros(1,n_pts);

    % find points where f is not '0'
    [x,y,z] = ind2sub(n, k);

    vertical_tol = deg2rad(theta_spacing);

    parfor i=1:n_samples
%     for i=1:n_samples
        % select two random points
        idx = randi([1 n_pts],2,1);
        [p_x, p_y, p_z] = ind2sub(n, k(idx));
        p1 = [p_x(1); p_y(1); p_z(1)];
        p2 = [p_x(2); p_y(2); p_z(2)];

        % find plane between them
        [rho_sample, th_sample, phi_sample] = plane_between_points_sph(p1,p2);

        % get closest index in discrete rho vector
        [~, rho_index] = min(abs(rho-rho_sample));
        rho_sample = rho(rho_index);

        % get closest index in discrete th vector
        [~, th_index] = min(abs(th-th_sample));
        th_sample = th(th_index);

        % Check if it is vertical, otherwise continue
        if(strcmp(type,'vertical') && abs(th_sample - pi/2) < vertical_tol || ~strcmp(type,'vertical'))
            % get closest index in discrete phi vector
            [~, phi_index] = min(abs(phi-phi_sample));
            phi_sample = phi(phi_index);

            % compute PRST for this two points
            f_refl = find_reflected_volume_fast(f, rho_sample, th_sample, ...
                                                phi_sample, x, y, z, n_pts);

            PRST = f(:)' * f_refl(:);
            rho_vector(i) = rho_index;
            th_vector(i)  = th_index;
            phi_vector(i) = phi_index;
            PRST_vector(i) = PRST;
        end
    end

    % hough transform
    hough_space = zeros(length(rho), length(th), length(phi));
    for j=1:n_samples
        if (rho_vector(j) == 0 || th_vector(j) == 0 || phi_vector(j) == 0)
            continue;
        end
        hough_space(rho_vector(j), th_vector(j), phi_vector(j)) = PRST_vector(j);
    end
end
