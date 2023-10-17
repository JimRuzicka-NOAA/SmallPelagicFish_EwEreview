% CompileMetadata_09102023
% Use this function to:
%   1) read and organize metadata from all queried Ecobase models
% revision date: 9/10/2023


% *************************************************************************
% STEP 1: define model-set directories & save files------------------------
ReadFile_directory      = '/1_ECOBASE_queries/ECOBASE_Atlantic/';

% ReadFile_directory      = '/1_ECOBASE_queries/ECOBASE_Pacific/';

% ReadFile_directory      = '/1_ECOBASE_queries/ECOBASE_OtherRegions/';
% *************************************************************************



% *************************************************************************
% STEP 3: process each .mat model in ReadFile_directory--------------------
FolderContents      = dir([ReadFile_directory '*.mat']); % dir struct of all pertinent .mat files
num_models          = length(FolderContents); % count of .mat files

CompiledMetadata	= cell(num_models, 16); % initialize


for model_loop = 1:num_models

	% step 3a: load model parameters (dat) & perform an ECOTRAN conversion 
	ReadFile_name           = FolderContents(model_loop).name;
	ReadFile                = [ReadFile_directory ReadFile_name];    
    
	disp(['Processing file: ' ReadFile_name])
    
    load(ReadFile, 'PackedModel')

    model_number        = PackedModel.model_info_table{1, 2};
    model_name          = PackedModel.model_info_table{2, 2};
    model_country       = PackedModel.model_info_table{3, 2};
    model_area          = PackedModel.model_info_table{4, 2}; % (km2)
    model_box           = PackedModel.model_info_table{5, 2};
    ecosystem_type    	= PackedModel.model_info_table(6, 2);
    model_currency    	= PackedModel.model_info_table(7, 2);
    num_grps            = PackedModel.model_info_table{9, 2};
    num_fleets        	= PackedModel.model_info_table{10, 2};
    model_year        	= PackedModel.model_info_table{11, 2};
    model_period        = PackedModel.model_info_table{12, 2};
    model_citation      = PackedModel.model_info_table{13, 2};
    model_doi           = PackedModel.model_info_table{14, 2};

%         group_labels        = PackedModel.group_label_table;
    % -----------------------------------------------------------------


    % -----------------------------------------------------------------
    % parse lat and lon
    looky_preamble      = strfind(model_box, 'BOX(');
    model_box(looky_preamble:(looky_preamble+3))	= [];
    looky_postamble     = strfind(model_box, ')');
    model_box(looky_postamble)                      = [];
    looky_comma         = strfind(model_box, ',');
    first_pair          = model_box(1:(looky_comma-1));
    second_pair         = model_box((looky_comma+1):end);

    looky_space         = strfind(first_pair, ' ');
    lon1 = str2num(first_pair(1:(looky_space-1)));
    lat1 = str2num(first_pair((looky_space+1):end));

    looky_space         = strfind(second_pair, ' ');
    lon2 = str2num(second_pair(1:(looky_space-1)));
    lat2 = str2num(second_pair((looky_space+1):end));

    mean_lat = mean([lat1 lat2]);
    mean_lon = mean([lon1 lon2]);
    % -----------------------------------------------------------------


    % -----------------------------------------------------------------
    % build CompiledMetadata table
    CompiledMetadata{model_loop, 1}   = model_number;
    CompiledMetadata{model_loop, 2}   = model_name;
    CompiledMetadata{model_loop, 3}   = model_citation;
    CompiledMetadata{model_loop, 4}   = ecosystem_type;
    CompiledMetadata{model_loop, 5}   = mean_lat;
    CompiledMetadata{model_loop, 6}   = mean_lon;
    CompiledMetadata{model_loop, 7}   = model_year;
    CompiledMetadata{model_loop, 8}   = num_grps;
    CompiledMetadata{model_loop, 9}   = num_fleets;
    CompiledMetadata{model_loop, 10}	= model_area;
    CompiledMetadata{model_loop, 11}	= model_currency;
    CompiledMetadata{model_loop, 12}	= model_country;
    CompiledMetadata{model_loop, 13}	= lat1;
    CompiledMetadata{model_loop, 14}	= lon1;
    CompiledMetadata{model_loop, 15}	= lat2;
    CompiledMetadata{model_loop, 16}	= lon2;
    % -----------------------------------------------------------------

end % model_loop


% end m-file***************************************************************