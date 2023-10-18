function [OmnivoryIndex, fname_OmnivoryIndex] = f_OmnivoryIndex_01272023(TL, DIET)
% calculate omnivory index for each group in an EwE model
% by Jim Ruzicka

fname_OmnivoryIndex     = mfilename; % save name of this m-file to keep in saved model results

[num_grps, ~]           = size(DIET);

if num_grps ~= length(TL)
    error('ERROR: TL and DIET do not have the same number of groups')
end

repmat_TL_p             = repmat(TL, [1, num_grps]); % replicate TL across clms; (2D matrix: num_grps X num_grps)
repmat_TL_c             = repmat(TL', [num_grps, 1]); % replicate TL down rows; (2D matrix: num_grps X num_grps); NOTE transpose

OmnivoryIndex_matrix	= (repmat_TL_p - (repmat_TL_c - 1)).^2 .* DIET;
OmnivoryIndex           = sum(OmnivoryIndex_matrix)'; % NOTE transpose to vertical vector

% end m-file***************************************************************