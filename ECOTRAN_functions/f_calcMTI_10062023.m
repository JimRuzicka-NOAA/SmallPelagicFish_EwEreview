function [MTI_xy, tMTI] = f_calcMTI_10062023(DIET_pc, A_cp, biomass, looky_ANYdetritus, make_plot)
% Calculate the Mixed Trophic Impact matrix as described in
% Ulanowicz RE, Puccia CJ, 1990. Mixed trophic impacts in ecosystems. COENOSES 5(1): 7-16.
%
% takes:
%   DIET_pc             diet matrix                         (rows = p producers), columns = c consumers)
%   A_cp                TrophicMatrix                       (rows = c consumers), columns = p producers)
%   biomass             biomass                             (horizontal vector: 1 X num_grps)
%	looky_ANYdetritus   addresses of detritus groups (or any other passive receiving "consumer" pool)
%   make_plot           if 'y', plot MTI heatmap
%
% returns:
%   MTI_xy              Mixed Trophic Impact matrix         (rows = x impactor group, columns = y response group)
%   tMTI                total Mixed Trophic Impact     (rows = x impactor group)
%                                   tMTI = the relative effect of impactor group x on the whole ecosystem
%                                   (Pranovi et al. (2003) Marine Biology 143:393-403)
%
% revision date: 10/6/2023
%       9/26/2023   add calculation of totalMTI
%       10/1/2023   corrected div/0 NaN and inf errors
%       10/2/2023   modified tMTI to exclude impact on self
%       10/6/2023   diet of detritus columns to all 0
%       10/6/2023   set detritus as impactor in MTI_scaled to NaN (to help standardize percentile ranks in comparisons across models)



% *************************************************************************
% STEP 1: make sure matrices are square and of same size-------------------
[rows_DIET, clms_DIET]	= size(DIET_pc);
[num_grps, clms_A]    	= size(A_cp);

if rows_DIET ~= clms_DIET; error('DIET matrix must be square'); end
if num_grps ~= clms_A; error('TrophicMatrix A_cp must be square'); end
if rows_DIET ~= num_grps; error('DIET matrix and TrophicMatrix must have same dimensions'); end
% *************************************************************************



% *************************************************************************
% STEP 2: set row entries in A_cp to 0 for all detritus groups (or any other passive receiving "consumer" pool)
%         NOTE: as per Ulanowicz & Puccia (1990)
A_cp(looky_ANYdetritus, :)              = 0;
DIET_pc(:, looky_ANYdetritus)           = 0;
% *************************************************************************



% *************************************************************************
% STEP 3: calculate Mixed Trophic Impact matrix----------------------------
Q_xy     	= DIET_pc - A_cp;           % net impact matrix; NOTE transpose of A_cp!!!
I_xy        = eye(size(Q_xy));          % identity matrix; all zeros but 1s on diagonal
MTI_xy      = inv(I_xy - Q_xy) - I_xy;  % Mixed Trophic Impact matrix (rows = x impactor group, columns = y response group)
% *************************************************************************



% *************************************************************************
% STEP 4: calculate total Mixed Trophic Impact matrix----------------------
%         as per Pranovi et al. (2003) Marine Biology 143:393-403.
%         excluding imapct on self
zero_diagonal                           = 1+diag((ones(1, num_grps)*(-1)), 0); % 0 on diagonal
working_MTI_xy                          = MTI_xy .* zero_diagonal;

biomass_repmat                          = repmat(biomass, [num_grps, 1]);	% (2D matrix: num_grps X num_grps)
MTI_scaled                              = working_MTI_xy .* (1./biomass_repmat);	% (2D matrix: num_grps X num_grps)
MTI_scaled(isnan(MTI_scaled))           = 0; % correct div/0 error
MTI_scaled(isinf(MTI_scaled))        	= 0; % correct div/0 error

MTI_scaled(looky_ANYdetritus, :)        = NaN; % set detritus as impactor in MTI_scaled to NaN (to help standardize percentile ranks in comparisons across models)

tMTI                                    = sum(MTI_scaled, 2); % (vertical vector: num_grps (impactor group) X 1)
% *************************************************************************



% *************************************************************************
% STEP 5: plot MTI heatmap-------------------------------------------------
if strcmp(make_plot, 'y')

    max_MTI                 = max(MTI_xy(:));
    min_MTI                 = min(MTI_xy(:));

    right_color             = [1 1 1];
    left_color              = [1 0 0]; % red
    map_red                 = interp1([0 1], [left_color; right_color], linspace(0, 1, 255));

    right_color             = [0 0 1]; % blue
    left_color              = [1 1 1];
    map_blue                = interp1([0 1], [left_color; right_color], linspace(0, 1, 255));

    map_RedBlueGradient     = [map_red; map_blue];
    [grad_length, ~]        = size(map_RedBlueGradient);
    map_range               = (-1:(2/(grad_length-1)):1)';
    looky_TooPositive       = find(map_range > max_MTI);
    looky_TooNegative       = find(map_range < min_MTI);
    map_RedBlueGradient(looky_TooPositive, :) = [];
    map_RedBlueGradient(looky_TooNegative, :) = [];

    figure
    heatmap(MTI_xy, 'colormap', map_RedBlueGradient)
    
end
% *************************************************************************


% end m-file***************************************************************