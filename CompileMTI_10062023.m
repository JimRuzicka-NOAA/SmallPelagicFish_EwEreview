% CompileMTI_10062023
% Harvest SPF group EwE parameters from queried Ecobase models
%   -- read matlab versions of ECOBASE models from lists (.mat), 
%   -- find small pelagic fish groups
%   -- calculate MTI matrix for resolved & aggregated food webs
%   -- save results as .mat file
% calls:
%       f_AggregateBiologicalModel_05132022		
%       ECOTRANheart_07222023		
%           f_ECOfunction_07212023	
%               f_RedistributeCannibalism_11202019
%               f_calcEE_05122022
%               f_calcPredationBudget_12102019
%       f_calcMTI_10062023
%
% revision date: 10/1/2023
%   9/29/2023   summarizing SPF across models as their tMTI percentile rank
%	10/1/2023   corrected div/0 NaN and inf errors
% 	10/2/2023   modified tMTI to exclude impact on self
%   10/6/2023   diet of detritus columns to all 0 in f_calcMTI_10062023
%   10/6/2023   set detritus as impactor in MTI_scaled to NaN in f_calcMTI_10062023 (to help standardize percentile ranks in comparisons across models)


% *************************************************************************
% STEP 1: define model-set directories & save files------------------------

ReadFile_directory	= '/3_Matlab_versions/Atlantic_MATLAB_versions/';
SaveFile_name     	= ['Compiled_MTI_Atlantic_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/Pacific_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_MTI_Pacific_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/OtherRegions_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_MTI_OtherRegions_' num2str(date)];

% ReadFile_directory      = '/3_Matlab_versions/LiteratureModels_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_MTI_LiteratureEntries_' num2str(date)];

SaveFile_directory      = '/5_Analyses/MTI/';
SaveFile                = [SaveFile_directory SaveFile_name];
% *************************************************************************





% *************************************************************************
% STEP 2: initialize variables---------------------------------------------
% step 2a: define functional group labels ---------------------------------
Grp_labels	= {
                    'PrimaryProducer'       % 1
                    'ALLzooplankton'        % 2
                    'BenthicInvertebrate'	% 3
                    'cephalopod'            % 4
                    'ALLfish'               % 5
                    'PELAGICfish_nonSPF'	% 6
                    'DEMERSALfish'          % 7
                    'ForageFish'            % 8
                    'MesopelagicFish'       % 9
                    'anchovy'               % 10
                    'BongaShad'             % 11
                    'FlyingFishEtc'         % 12
                    'herring'               % 13
                    'mackerelCarangidae'	% 14
                    'mackerelScombridae'	% 15
                    'menhaden'              % 16
                    'sardine'               % 17
                    'shad'                  % 18
                    'smelt'                 % 19
                    'sprat'                 % 20
                    'seabird'               % 21
                    'mammal'                % 22
                    'fleet'                 % 23
                };            
            
% num_targetGrps = length(Grp_labels); % recalculated later
% -------------------------------------------------------------------------


% step 2b: initialize CompiledMTI variable --------------------------------
parameterLabel	= {'model_number', 'percentile_tMTI', 'tMTI'};

CompiledMTI.TG1.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG1.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG1.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG1.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG2.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG2.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG2.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG2.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG3.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG3.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG3.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG3.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG4.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG4.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG4.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG4.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG5.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG5.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG5.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG5.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG6.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG6.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG6.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG6.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG7.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG7.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG7.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG7.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG8.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG8.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG8.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG8.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG9.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG9.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG9.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG9.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG10.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG10.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG10.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG10.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG11.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG11.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG11.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG11.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG12.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG12.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG12.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG12.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG13.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG13.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG13.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG13.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG14.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG14.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG14.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG14.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG15.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG15.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG15.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG15.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG16.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG16.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG16.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG16.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG17.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG17.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG17.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG17.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG18.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG18.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG18.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG18.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG19.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG19.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG19.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG19.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG20.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG20.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG20.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG20.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG21.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG21.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG21.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG21.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG22.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG22.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG22.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG22.parameterLabel      = parameterLabel; % initialize variable that will grow

CompiledMTI.TG23.label               = cell(1);      % initialize cell that will grow
CompiledMTI.TG23.text                = cell(1, 24);   % initialize cell that will grow
CompiledMTI.TG23.parameters          = zeros(1, 3); % initialize variable that will grow
CompiledMTI.TG23.parameterLabel      = parameterLabel; % initialize variable that will grow

fn                               	= fieldnames(CompiledMTI);
% -------------------------------------------------------------------------


% step 2c: initilize counters ---------------------------------------------
PositionCounter.CN1     = 0;
PositionCounter.CN2     = 0;
PositionCounter.CN3     = 0;
PositionCounter.CN4     = 0;
PositionCounter.CN5     = 0;
PositionCounter.CN6     = 0;
PositionCounter.CN7     = 0;
PositionCounter.CN8     = 0;
PositionCounter.CN9     = 0;
PositionCounter.CN10    = 0;
PositionCounter.CN11    = 0;
PositionCounter.CN12    = 0;
PositionCounter.CN13    = 0;
PositionCounter.CN14    = 0;
PositionCounter.CN15    = 0;
PositionCounter.CN16    = 0;
PositionCounter.CN17    = 0;
PositionCounter.CN18    = 0;
PositionCounter.CN19    = 0;
PositionCounter.CN20    = 0;
PositionCounter.CN21    = 0;
PositionCounter.CN22    = 0;
PositionCounter.CN23    = 0;
PositionCounter.CN24    = 0;

cn                      = fieldnames(PositionCounter);
% *************************************************************************




% *************************************************************************
% STEP 3: process each .mat model in ReadFile_directory--------------------
FolderContents          = dir([ReadFile_directory '*.mat']); % dir struct of all pertinent .mat files
num_files               = length(FolderContents); % count of .mat files

for model_loop = 1:num_files
    
    % step 3a: load model and perform an ECOTRAN conversion ---------------
	ReadFile_name           = FolderContents(model_loop).name; 
    ReadFile                = [ReadFile_directory ReadFile_name];    
    disp(['Processing file: ' ReadFile_name])
    
    load(ReadFile, 'dat')
    
    dat.EcotranGroupType 	= dat.EcoBase_GroupType; % swap in new group type definitions for SPF work
    
    [EwEResult, PEDIGREE] 	= f_AggregateBiologicalModel_05132022(dat);
    MonteCarloStore         = [];
    [ECOTRAN]            	= ECOTRANheart_07222023(EwEResult, MonteCarloStore); % returns results w/ and w/o cannibalism corrections
	% ---------------------------------------------------------------------

    
    % step 3b: up-pack variables in current model -------------------------
    EcoBase_OriginalGroupName                   = dat.EcoBase_OriginalGroupName;
    EcoBase_GroupType                           = dat.EcoBase_GroupType;
    EcoBase_MajorClass                          = dat.EcoBase_MajorClass;
    EcoBase_SPFtype_resolved                    = dat.EcoBase_SPFtype_resolved;
    EcoBase_SPFtype_aggregated                  = dat.EcoBase_SPFtype_aggregated;

    EcoBase_ModelNumber                         = dat.EcoBase_ModelNumber;
    
    biomass                                     = dat.Biomass; % (vertical vector: num_grps (EwE) X 1)
    pb                                          = dat.PB; % (vertical vector: num_grps (EwE) X 1)
    qb                                          = dat.QB; % (vertical vector: num_grps (EwE) X 1)
    
    landings                                    = dat.landings; % (vertical vector: num_grps (EwE minus num_fleets) X num_fleets)
    discards                                    = dat.discards; % (vertical vector: num_grps (EwE minus num_fleets) X num_fleets)
        
    num_nutrients                               = ECOTRAN.num_nutrients;
    num_fleets                                  = dat.num_gear;
    num_detritus                                = dat.num_detritus;
	num_grps                                    = dat.num_EcotranGroups;
    
	A_cp                                        = ECOTRAN.EnergyBudget_wCannibalism;	% (2D matrix: num_grps (consumer) X num_grps (producer))
%     DIET_pc                                     = ECOTRAN.DIET;                         % (2D matrix: num_grps (producer) X num_grps (consumer))
    % ---------------------------------------------------------------------
    
    
    % step 3c: calculate consumption matrix -------------------------------
	p                        	= biomass' .* pb'; % consumption rates; (horizontal vector: 1 X num_grps (minus nutrients)); NOTE: does not have nutrients; NOTE: fleet catch still = 0; NOTE transposes
    q                        	= biomass' .* qb'; % consumption rates; (horizontal vector: 1 X num_grps (minus nutrients)); NOTE: does not have nutrients; NOTE: fleet catch still = 0; NOTE transposes
    
    p                           = [zeros(1, num_nutrients) p]; % append 0 at nutrient positions; (horizontal matrix: 1 X num_grps (ECOTRAN))
    q                           = [zeros(1, num_nutrients) q]; % append 0 at nutrient positions; (horizontal matrix: 1 X num_grps (ECOTRAN))
    biomass                     = [zeros(1, num_nutrients) biomass']; % append 0 at nutrient positions; (horizontal matrix: 1 X num_grps (ECOTRAN)); NOTE transpose
    
	looky_fleet                 = find(round(EcoBase_GroupType, 0) == 5);
	fleet_catch               	= landings + discards;
    p(looky_fleet)              = sum(landings);        % put fleet landings into p
    q(looky_fleet)              = sum(fleet_catch);     % put fleet catch into q
    biomass(looky_fleet)    	= sum(fleet_catch);     % put fleet catch into biomass
    
    looky_PrimaryProducer   	= find(round(EcoBase_GroupType, 0) == 2);
    q(looky_PrimaryProducer)	= p(looky_PrimaryProducer); % put primry production into q
    
%     p_repmat                    = repmat(p, [num_grps, 1]); % (2D matrix: num_grps X num_grps)
    q_repmat                    = repmat(q, [num_grps, 1]); % (2D matrix: num_grps X num_grps)
    
%     Q_pc                        = DIET_pc .* q_repmat; % consumption matrix; NOTE: orientation differs from matrix from TrophicMatrix; (2D matrix: num_grps (producers) X num_grps (consumers))
    Q_cp                        = A_cp   .* q_repmat; % consumption matrix; (2D matrix: num_grps (consumers) X num_grps (producers))
    
    
	% add detritus to Q_cp -----
%     ae                       	= [zeros(1, num_nutrients) ae']; % append 0 at nutrient positions; NOTE transpose
%     ee                       	= [zeros(1, num_nutrients) ee']; % append 0 at nutrient positions; NOTE transpose
%     
%     p_feces                     = q .* (1 - ae); % (horizontal vector: 1 X num_grps)
%     p_senescence                = q .* (1 - ee); % (horizontal vector: 1 X num_grps)
%     % QQQ add filter for negatives (should not be needed))
%     p_detritus                  = p_feces + p_senescence; % (horizontal vector: 1 X num_grps)
%     
%     p_feces_repmat              = repmat(p_feces, [num_detritus, 1]);       % (2D matrix: num_detritus X num_grps)
%     p_senescence_repmat       	= repmat(p_senescence, [num_detritus, 1]);	% (2D matrix: num_detritus X num_grps)
%     q_feces                     = p_feces_repmat .* fate_feces;             % (2D matrix: num_detritus X num_grps)
%     q_senescence             	= p_senescence_repmat .* fate_senescence;	% (2D matrix: num_detritus X num_grps)
%     q_detritus                  = q_feces + q_senescence;                   % (2D matrix: num_detritus X num_grps)
%     q_ANYdetritus               = sum(q_detritus, 2);                       % (vertical vector: num_detritus X 1)
%     
%     Q_cp(looky_ANYdetritus, :)	= q_detritus;
    
% 	looky_ANYdetritus                           = find(round(EcoBase_GroupType, 0) == 4);
% % 	looky_TerminalBenthicDetritus               = find(EcoBase_GroupType == 4.3);
%     
% %     q_ANYdetritus                       = sum(Q_cp(looky_ANYdetritus, :), 2);
%     q(looky_ANYdetritus)                = q_ANYdetritus; % put detritus production into q
% %     q(looky_TerminalBenthicDetritus)	= 1; % put termnal benthic detritus production = 1 into q

    % re-normalize detritus columns in A_cp -------
	looky_ANYdetritus                   = find(round(EcoBase_GroupType, 0) == 4);
	looky_ANYnutrient                 	= find(round(EcoBase_GroupType, 0) == 1);

    A_cp(looky_ANYnutrient, looky_ANYdetritus) = 0;
    A_c_detritus                        = A_cp(:, looky_ANYdetritus);   % (2D matrix: num_grps X num_detritus)
    sum_A_c_detritus                    = sum(A_c_detritus, 1);         % (horizontal vector: 1 X num_detritus)
    repmat_sum_A_c_detritus           	= repmat(sum_A_c_detritus, [num_grps, 1]); % (2D matrix: num_grps X num_detritus)
    A_c_detritus                        = A_c_detritus ./ repmat_sum_A_c_detritus;
    A_c_detritus(isnan(A_c_detritus))	= 0;
    A_cp(:, looky_ANYdetritus)          = A_c_detritus;

    q_ANYdetritus                       = sum(Q_cp(looky_ANYdetritus, :), 2);
    q(looky_ANYdetritus)                = q_ANYdetritus'; % put detritus production into q; NOTE transpose
    
	q_repmat                            = repmat(q, [num_grps, 1]); % recalculate; (2D matrix: num_grps X num_grps)
    Q_cp                                = A_cp   .* q_repmat; % consumption matrix; (2D matrix: num_grps (consumers) X num_grps (producers))
    % ---------------------------------------------------------------------    

    
    % step 3d: remove nutrient rows & clms --------------------------------
    %           from DIET, TrophicMatrix, ConsumptionMatrix, & names
	looky_ANYnutrient                               = find(round(EcoBase_GroupType, 0) == 1);

    A_cp(looky_ANYnutrient, :)                      = [];
    A_cp(:, looky_ANYnutrient)                      = [];
%     DIET_pc(looky_ANYnutrient, :)                   = [];
%     DIET_pc(:, looky_ANYnutrient)                   = [];
%     Q_pc(looky_ANYnutrient, :)                      = [];
%     Q_pc(:, looky_ANYnutrient)                      = [];
    Q_cp(looky_ANYnutrient, :)                      = [];
    Q_cp(:, looky_ANYnutrient)                      = [];
    p(looky_ANYnutrient)                            = [];
    q(looky_ANYnutrient)                            = [];
    q(looky_ANYnutrient)                            = [];
    biomass(looky_ANYnutrient)                  	= []; % (horizontal matrix: 1 X num_grps - num_nutrients)
    
    EcoBase_OriginalGroupName(looky_ANYnutrient)    = [];
    EcoBase_GroupType(looky_ANYnutrient)            = [];
    EcoBase_MajorClass(looky_ANYnutrient)           = [];
    EcoBase_SPFtype_resolved(looky_ANYnutrient)     = [];
    EcoBase_SPFtype_aggregated(looky_ANYnutrient)	= [];
    
	[num_grps, ~]                                   = size(A_cp); % get new matrix size

    % re-normalize TrophicMatrix (DIET needs no renormailization since nutrient entries were always 0)
    sum_A                             	= sum(A_cp, 1);                     % (horizontal matrix: 1 X num_grps)
    sum_A_repmat                        = repmat(sum_A,   [num_grps, 1]);	% (2D matrix: num_grps X num_grps)
    A_cp                            	= A_cp ./ sum_A_repmat;     % renormalize all columns; NOTE: will now ignore emigration & external feeding
    A_cp(isnan(A_cp))               	= 0;
    % ---------------------------------------------------------------------
    
    
    % step 3e: find group addresses ---------------------------------------
    % NOTE: nutrients were removed in previous step, so these addresses correspond to EwE     
	looky_ANYdetritus                           = find(round(EcoBase_GroupType, 0) == 4);
	looky_TerminalBenthicDetritus               = find(EcoBase_GroupType == 4.3);

    looky_eggs                                  = find(round(EcoBase_GroupType, 0) == 8);

    looky_PrimaryProducer                       = find(round(EcoBase_GroupType, 0) == 2);
    
	looky_ALLconsumers                          = find(round(EcoBase_GroupType, 0) == 3);
    
    looky_micrograzers                          = find(round(EcoBase_GroupType, 3) == 3.111);
    
	looky_zooplankton                           = find(round(EcoBase_GroupType, 2) == 3.11); 
	looky_micronekton                           = find(round(EcoBase_GroupType, 2) == 3.12); 
	looky_ALLzooplankton                        = [looky_zooplankton; looky_micronekton]; % zooplankton & micronekton grouping
    
    looky_BenthicInvertebrate                   = find(round(EcoBase_GroupType, 2) == 3.21);
    
	looky_squid                                 = find(round(EcoBase_GroupType, 2) == 3.13); 
	looky_octopus                               = find(round(EcoBase_GroupType, 2) == 3.23); 
	looky_cephalopod                            = find(round(EcoBase_GroupType, 2) == 3.03); 
    looky_cephalopod                            = sort([looky_cephalopod; looky_squid; looky_octopus]); % pool all cephalopds together since benthics & pelagics are often hard to distinguish in the models

	looky_ALLfish                           	= find(strcmp(EcoBase_MajorClass, 'fish'));
    looky_PELAGICfish                           = find(round(EcoBase_GroupType, 2) == 3.14);
	looky_DEMERSALfish                          = find(round(EcoBase_GroupType, 2) == 3.24);
    looky_ForageFish                            = find(strcmp(EcoBase_SPFtype_aggregated, 'forage fish'));
    looky_MesopelagicFish                    	= find(strcmp(EcoBase_SPFtype_aggregated, 'mesopelagic fish') | strcmp(EcoBase_SPFtype_aggregated, 'mesopealgic fish'));    
    looky_PELAGICfish_nonSPF                    = looky_PELAGICfish(~ismember(looky_PELAGICfish, [looky_ForageFish; looky_MesopelagicFish]));
    
    looky_anchovy                               = find(strcmp(EcoBase_SPFtype_resolved, 'anchovy'));
    looky_BongaShad                           	= find(strcmp(EcoBase_SPFtype_resolved, 'bonga shad'));    
    looky_FlyingFishEtc                      	= find(strcmp(EcoBase_SPFtype_resolved, 'flying fish & halfbeaks & saury'));
    looky_herring                               = find(strcmp(EcoBase_SPFtype_resolved, 'herring'));    
    looky_mackerelCarangidae                	= find(strcmp(EcoBase_SPFtype_resolved, 'mackerel - Carangidae'));    
    looky_mackerelScombridae                	= find(strcmp(EcoBase_SPFtype_resolved, 'mackerel - Scombridae'));    
    looky_menhaden                            	= find(strcmp(EcoBase_SPFtype_resolved, 'menhaden'));    
    looky_sardine                            	= find(strcmp(EcoBase_SPFtype_resolved, 'sardine'));    
    looky_shad                                  = find(strcmp(EcoBase_SPFtype_resolved, 'shad'));    
    looky_smelt                               	= find(strcmp(EcoBase_SPFtype_resolved, 'smelt'));    
    looky_sprat                              	= find(strcmp(EcoBase_SPFtype_resolved, 'sprat'));

    % QQQ patch to remove mackerel from ForageFish but include in PELAGICfish_nonSPF --------
    looky_ForageFish            = looky_ForageFish(~ismember(looky_ForageFish, [looky_mackerelCarangidae; looky_mackerelScombridae]));
    looky_PELAGICfish_nonSPF	= looky_PELAGICfish(~ismember(looky_PELAGICfish, [looky_ForageFish; looky_MesopelagicFish]));
    % QQQ  ----------------------------------
    
	looky_seabird                               = find(strcmp(EcoBase_MajorClass, 'seabird'));
    looky_mammal                                = find(strcmp(EcoBase_MajorClass, 'mammal'));
	looky_fleet                                 = find(round(EcoBase_GroupType, 0) == 5); 
    % *********************************************************************
    
    
    
    
    % *********************************************************************
    % STEP 4: aggregate groups---------------------------------------------
    % step 4a: prep group name aggregations -------------------------------
    EcoBase_FULLresName                             = EcoBase_OriginalGroupName;
    EcoBase_FULLresGroupType                      	= EcoBase_GroupType;
    
    % SPFagg ---------------------
    EcoBase_SPFaggName                              = EcoBase_OriginalGroupName;
    EcoBase_SPFaggName(looky_seabird)               = {'seabird'};
	EcoBase_SPFaggName(looky_mammal)                = {'mammal'};
	EcoBase_SPFaggName(looky_fleet)                 = {'fleet'};
    EcoBase_SPFaggName(looky_ForageFish)            = {'forage fish'};
    EcoBase_SPFaggName(looky_MesopelagicFish)       = {'mesopelagic fish'};
    EcoBase_SPFaggName(looky_mackerelCarangidae)    = {'mackerel - Carangidae'};
    EcoBase_SPFaggName(looky_mackerelScombridae)    = {'mackerel - Scombridae'};
    
    EcoBase_SPFaggGroupType                             = EcoBase_GroupType;
    EcoBase_SPFaggGroupType(looky_seabird)              = 3.160;
	EcoBase_SPFaggGroupType(looky_mammal)               = 3.160;
	EcoBase_SPFaggGroupType(looky_fleet)                = 5.000;
    EcoBase_SPFaggGroupType(looky_ForageFish)           = 3.140;
    EcoBase_SPFaggGroupType(looky_MesopelagicFish)      = 3.140;
    EcoBase_SPFaggGroupType(looky_mackerelCarangidae)	= 3.140;
    EcoBase_SPFaggGroupType(looky_mackerelScombridae)	= 3.140;
    
    EcoBase_SPFaggMajorClass                            = EcoBase_MajorClass;
    EcoBase_SPFaggType_aggregated                       = EcoBase_SPFtype_aggregated;
    EcoBase_SPFaggType_resolved                         = EcoBase_SPFtype_resolved;
    
    % SPFres ---------------------
    EcoBase_SPFresName                                  = EcoBase_OriginalGroupName;
	EcoBase_SPFresName(looky_seabird)                   = {'seabird'};
	EcoBase_SPFresName(looky_mammal)                    = {'mammal'};
	EcoBase_SPFresName(looky_fleet)                     = {'fleet'};
    EcoBase_SPFresName(looky_MesopelagicFish)           = {'mesopelagic fish'};
    EcoBase_SPFresName(looky_mackerelCarangidae)        = {'mackerel - Carangidae'};
    EcoBase_SPFresName(looky_mackerelScombridae)        = {'mackerel - Scombridae'};
    EcoBase_SPFresName(looky_anchovy)                   = {'anchovy'};
    EcoBase_SPFresName(looky_BongaShad)                 = {'bonga shad'};
    EcoBase_SPFresName(looky_FlyingFishEtc)             = {'flying fish & halfbeaks & saury'};
    EcoBase_SPFresName(looky_herring)                   = {'herring'};
    EcoBase_SPFresName(looky_menhaden)                  = {'menhaden'};
    EcoBase_SPFresName(looky_sardine)                   = {'sardine'};
    EcoBase_SPFresName(looky_shad)                      = {'shad'};
    EcoBase_SPFresName(looky_smelt)                     = {'smelt'};
    EcoBase_SPFresName(looky_sprat)                     = {'sprat'};
    
    EcoBase_SPFresGroupType                             = EcoBase_GroupType;
	EcoBase_SPFresGroupType(looky_seabird)            	= 3.160;
	EcoBase_SPFresGroupType(looky_mammal)             	= 3.160;
	EcoBase_SPFresGroupType(looky_fleet)              	= 5.000;    
    EcoBase_SPFresGroupType(looky_MesopelagicFish)     	= 3.140;
    EcoBase_SPFresGroupType(looky_mackerelCarangidae) 	= 3.140;
    EcoBase_SPFresGroupType(looky_mackerelScombridae)  	= 3.140;
    EcoBase_SPFresGroupType(looky_anchovy)            	= 3.140;
    EcoBase_SPFresGroupType(looky_BongaShad)          	= 3.140;
    EcoBase_SPFresGroupType(looky_FlyingFishEtc)      	= 3.140;
    EcoBase_SPFresGroupType(looky_herring)           	= 3.140;
    EcoBase_SPFresGroupType(looky_menhaden)          	= 3.140;
    EcoBase_SPFresGroupType(looky_sardine)           	= 3.140;
    EcoBase_SPFresGroupType(looky_shad)               	= 3.140;
    EcoBase_SPFresGroupType(looky_smelt)              	= 3.140;
    EcoBase_SPFresGroupType(looky_sprat)              	= 3.140;
    
	EcoBase_SPFresMajorClass                            = EcoBase_MajorClass;
	EcoBase_SPFresType_aggregated                    	= EcoBase_SPFtype_aggregated;
    EcoBase_SPFresType_resolved                         = EcoBase_SPFtype_resolved;
    % ---------------------------------------------------------------------
    
    
    % step 4b: aggregate consumer groups (rows) ---------------------------
   	Q_seabirds_p                                    = sum(Q_cp(looky_seabird, :), 1);
    Q_mammals_p                                     = sum(Q_cp(looky_mammal, :), 1);
    Q_fleets_p                                      = sum(Q_cp(looky_fleet, :), 1);
	Q_MesopelagicFish_p                             = sum(Q_cp(looky_MesopelagicFish, :), 1);
    Q_mackerelCarangidae_p                       	= sum(Q_cp(looky_mackerelCarangidae, :), 1);
    Q_mackerelScombridae_p                       	= sum(Q_cp(looky_mackerelScombridae, :), 1);

   	biomass_seabirds                             	= sum(biomass(looky_seabird));
    biomass_mammals                             	= sum(biomass(looky_mammal));
    biomass_fleets                               	= sum(biomass(looky_fleet));
	biomass_MesopelagicFish                        	= sum(biomass(looky_MesopelagicFish));
    biomass_mackerelCarangidae                   	= sum(biomass(looky_mackerelCarangidae));
    biomass_mackerelScombridae                   	= sum(biomass(looky_mackerelScombridae));

    % sum consumer rows (SPFagg) --------
    Q_ForageFish_p                                  = sum(Q_cp(looky_ForageFish, :), 1);
    biomass_ForageFish                           	= sum(biomass(looky_ForageFish));
    
    % sum consumer rows (SPFres) --------
    Q_anchovy_p                                     = sum(Q_cp(looky_anchovy, :), 1);
    Q_BongaShad_p                                   = sum(Q_cp(looky_BongaShad, :), 1);
    Q_FlyingFishEtc_p                            	= sum(Q_cp(looky_FlyingFishEtc, :), 1);
    Q_herring_p                                     = sum(Q_cp(looky_herring, :), 1);
    Q_menhaden_p                                    = sum(Q_cp(looky_menhaden, :), 1);
    Q_sardine_p                                     = sum(Q_cp(looky_sardine, :), 1);
    Q_shad_p                                        = sum(Q_cp(looky_shad, :), 1);
    Q_smelt_p                                       = sum(Q_cp(looky_smelt, :), 1);
    Q_sprat_p                                       = sum(Q_cp(looky_sprat, :), 1);
    
    biomass_anchovy                               	= sum(biomass(looky_anchovy));
    biomass_BongaShad                             	= sum(biomass(looky_BongaShad));
    biomass_FlyingFishEtc                         	= sum(biomass(looky_FlyingFishEtc));
    biomass_herring                                	= sum(biomass(looky_herring));
    biomass_menhaden                              	= sum(biomass(looky_menhaden));
    biomass_sardine                              	= sum(biomass(looky_sardine));
    biomass_shad                                   	= sum(biomass(looky_shad));
    biomass_smelt                                  	= sum(biomass(looky_smelt));
    biomass_sprat                                  	= sum(biomass(looky_sprat));
    % ---------------------------------------------------------------------
    
    % replace consumer rows -----------------------------------------------
    % SPFagg -----------
    Q_SPFagg_p                                  = Q_cp;
    Q_SPFagg_p(looky_seabird, :)                = repmat(Q_seabirds_p,           [length(looky_seabird), 1]);
    Q_SPFagg_p(looky_mammal, :)                 = repmat(Q_mammals_p,            [length(looky_mammal), 1]);
    Q_SPFagg_p(looky_fleet, :)                  = repmat(Q_fleets_p,             [length(looky_fleet), 1]);
    Q_SPFagg_p(looky_ForageFish, :)             = repmat(Q_ForageFish_p,         [length(looky_ForageFish), 1]);
    Q_SPFagg_p(looky_MesopelagicFish, :)        = repmat(Q_MesopelagicFish_p,    [length(looky_MesopelagicFish), 1]);
    Q_SPFagg_p(looky_mackerelCarangidae, :)   	= repmat(Q_mackerelCarangidae_p, [length(looky_mackerelCarangidae), 1]);
    Q_SPFagg_p(looky_mackerelScombridae, :)   	= repmat(Q_mackerelScombridae_p, [length(looky_mackerelScombridae), 1]);
    
    biomass_SPFagg                            	= biomass;
    biomass_SPFagg(looky_seabird)             	= biomass_seabirds;
    biomass_SPFagg(looky_mammal)              	= biomass_mammals;
    biomass_SPFagg(looky_fleet)               	= biomass_fleets;
    biomass_SPFagg(looky_ForageFish)          	= biomass_ForageFish;
    biomass_SPFagg(looky_MesopelagicFish)      	= biomass_MesopelagicFish;
    biomass_SPFagg(looky_mackerelCarangidae)   	= biomass_mackerelCarangidae;
    biomass_SPFagg(looky_mackerelScombridae)   	= biomass_mackerelScombridae;
    
    % SPFres -----------
    Q_SPFres_p                                  = Q_cp;
    Q_SPFres_p(looky_seabird, :)                = repmat(Q_seabirds_p,           [length(looky_seabird), 1]);
    Q_SPFres_p(looky_mammal, :)                 = repmat(Q_mammals_p,            [length(looky_mammal), 1]);
    Q_SPFres_p(looky_fleet, :)                  = repmat(Q_fleets_p,             [length(looky_fleet), 1]);
    Q_SPFres_p(looky_MesopelagicFish, :)        = repmat(Q_MesopelagicFish_p,    [length(looky_MesopelagicFish), 1]);
    Q_SPFres_p(looky_mackerelCarangidae, :)   	= repmat(Q_mackerelCarangidae_p, [length(looky_mackerelCarangidae), 1]);
    Q_SPFres_p(looky_mackerelScombridae, :)   	= repmat(Q_mackerelScombridae_p, [length(looky_mackerelScombridae), 1]);
    Q_SPFres_p(looky_anchovy, :)                = repmat(Q_anchovy_p,            [length(looky_anchovy), 1]);
    Q_SPFres_p(looky_BongaShad, :)           	= repmat(Q_BongaShad_p,          [length(looky_BongaShad), 1]);
    Q_SPFres_p(looky_FlyingFishEtc, :)       	= repmat(Q_FlyingFishEtc_p,      [length(looky_FlyingFishEtc), 1]);
    Q_SPFres_p(looky_herring, :)                = repmat(Q_herring_p,            [length(looky_herring), 1]);
    Q_SPFres_p(looky_menhaden, :)               = repmat(Q_menhaden_p,           [length(looky_menhaden), 1]);
    Q_SPFres_p(looky_sardine, :)                = repmat(Q_sardine_p,            [length(looky_sardine), 1]);
    Q_SPFres_p(looky_shad, :)                   = repmat(Q_shad_p,               [length(looky_shad), 1]);
    Q_SPFres_p(looky_smelt, :)                  = repmat(Q_smelt_p,              [length(looky_smelt), 1]);
    Q_SPFres_p(looky_sprat, :)                	= repmat(Q_sprat_p,              [length(looky_sprat), 1]);
    
    biomass_SPFres                            	= biomass;
    biomass_SPFres(looky_seabird)             	= biomass_seabirds;
    biomass_SPFres(looky_mammal)              	= biomass_mammals;
    biomass_SPFres(looky_fleet)              	= biomass_fleets;
    biomass_SPFres(looky_MesopelagicFish)    	= biomass_MesopelagicFish;
    biomass_SPFres(looky_mackerelCarangidae)   	= biomass_mackerelCarangidae;
    biomass_SPFres(looky_mackerelScombridae)	= biomass_mackerelScombridae;
    biomass_SPFres(looky_anchovy)             	= biomass_anchovy;
    biomass_SPFres(looky_BongaShad)           	= biomass_BongaShad;
    biomass_SPFres(looky_FlyingFishEtc)       	= biomass_FlyingFishEtc;
    biomass_SPFres(looky_herring)             	= biomass_herring;
    biomass_SPFres(looky_menhaden)          	= biomass_menhaden;
    biomass_SPFres(looky_sardine)             	= biomass_sardine;
    biomass_SPFres(looky_shad)                	= biomass_shad;
    biomass_SPFres(looky_smelt)               	= biomass_smelt;
    biomass_SPFres(looky_sprat)                	= biomass_sprat;
    % ---------------------------------------------------------------------
    
    % delete duplicate consumer rows --------------------------------------
	looky_c_ForageFish                          = looky_ForageFish;
    looky_c_MesopelagicFish                     = looky_MesopelagicFish;
    looky_c_seabird                             = looky_seabird;
    looky_c_mammal                              = looky_mammal;
    looky_c_fleet                               = looky_fleet;
    
    looky_c_anchovy                             = looky_anchovy;
    looky_c_BongaShad                           = looky_BongaShad;
    looky_c_FlyingFishEtc                       = looky_FlyingFishEtc;
    looky_c_herring                             = looky_herring;
    looky_c_mackerelCarangidae                  = looky_mackerelCarangidae;
    looky_c_mackerelScombridae                  = looky_mackerelScombridae;
    looky_c_menhaden                            = looky_menhaden;
    looky_c_sardine                             = looky_sardine;
    looky_c_shad                                = looky_shad;
    looky_c_smelt                               = looky_smelt;
    looky_c_sprat                               = looky_sprat;
    
    looky_c_ForageFish(1)                       = NaN;
    looky_c_MesopelagicFish(1)               	= NaN;
    looky_c_seabird(1)                        	= NaN;
    looky_c_mammal(1)                         	= NaN;
    looky_c_fleet(1)                           	= NaN;
    
    looky_c_anchovy(1)                        	= NaN;
    looky_c_BongaShad(1)                       	= NaN;
    looky_c_FlyingFishEtc(1)                   	= NaN;
    looky_c_herring(1)                        	= NaN;
    looky_c_mackerelCarangidae(1)            	= NaN;
    looky_c_mackerelScombridae(1)              	= NaN;
    looky_c_menhaden(1)                        	= NaN;
    looky_c_sardine(1)                         	= NaN;
    looky_c_shad(1)                           	= NaN;
    looky_c_smelt(1)                          	= NaN;
    looky_c_sprat(1)                          	= NaN;
    
    looky_SPFagg_duplicates                                 = [looky_c_ForageFish; looky_c_MesopelagicFish; looky_c_seabird; ...
                                                               looky_c_mammal; looky_c_fleet];
    looky_SPFagg_duplicates(isnan(looky_SPFagg_duplicates)) = [];
    Q_SPFagg_p(looky_SPFagg_duplicates, :)                  = [];
    biomass_SPFagg(looky_SPFagg_duplicates)               	= [];
    EcoBase_SPFaggName(looky_SPFagg_duplicates)             = []; % edit labels
    EcoBase_SPFaggGroupType(looky_SPFagg_duplicates)        = []; % edit GroupType
	EcoBase_SPFaggMajorClass(looky_SPFagg_duplicates)       = []; % edit MajorClass
    EcoBase_SPFaggType_aggregated(looky_SPFagg_duplicates)	= []; % edit EcoBase_SPFtype_aggregated
    EcoBase_SPFaggType_resolved(looky_SPFagg_duplicates)	= []; % edit EcoBase_SPFtype_resolved
    
    looky_SPFres_duplicates                                 = [looky_c_anchovy; looky_c_BongaShad; ...
                                                               looky_c_FlyingFishEtc; looky_c_herring; looky_c_mackerelCarangidae; ...
                                                               looky_c_mackerelScombridae; looky_c_menhaden; looky_c_sardine; ...
                                                               looky_c_shad; looky_c_smelt; looky_c_sprat; ...
                                                               looky_c_MesopelagicFish; looky_c_seabird; looky_c_mammal; looky_c_fleet];
    looky_SPFres_duplicates(isnan(looky_SPFres_duplicates)) = [];
    Q_SPFres_p(looky_SPFres_duplicates, :)                  = [];
    biomass_SPFres(looky_SPFres_duplicates)               	= [];
	EcoBase_SPFresName(looky_SPFres_duplicates)             = []; % edit labels
	EcoBase_SPFresGroupType(looky_SPFres_duplicates)        = []; % edit GroupType
	EcoBase_SPFresMajorClass(looky_SPFres_duplicates)       = []; % edit MajorClass
    EcoBase_SPFresType_aggregated(looky_SPFres_duplicates)	= []; % edit EcoBase_SPFtype_aggregated
    EcoBase_SPFresType_resolved(looky_SPFres_duplicates)	= []; % edit EcoBase_SPFtype_resolved
    % ---------------------------------------------------------------------

    
    % step 4c: aggregate producer groups (columns) ------------------------
    % sum producer columns (need to handle this separately for SPFagg & SPFres)
    % SPFagg --------------
    Q_SPFagg_seabirds                        	= sum(Q_SPFagg_p(:, looky_seabird), 2);
    Q_SPFagg_mammals                          	= sum(Q_SPFagg_p(:, looky_mammal), 2);
    Q_SPFagg_fleets                          	= sum(Q_SPFagg_p(:, looky_fleet), 2);
    Q_SPFagg_ForageFish                       	= sum(Q_SPFagg_p(:, looky_ForageFish), 2);
    Q_SPFagg_MesopelagicFish                    = sum(Q_SPFagg_p(:, looky_MesopelagicFish), 2);
    Q_SPFagg_mackerelCarangidae               	= sum(Q_SPFagg_p(:, looky_mackerelCarangidae), 2);
    Q_SPFagg_mackerelScombridae               	= sum(Q_SPFagg_p(:, looky_mackerelScombridae), 2);

    % SPFres --------------
    Q_SPFres_seabirds                         	= sum(Q_SPFres_p(:, looky_seabird), 2);
    Q_SPFres_mammals                          	= sum(Q_SPFres_p(:, looky_mammal), 2);
    Q_SPFres_fleets                           	= sum(Q_SPFres_p(:, looky_fleet), 2);
    Q_SPFres_MesopelagicFish                    = sum(Q_SPFres_p(:, looky_MesopelagicFish), 2);
    Q_SPFres_mackerelCarangidae               	= sum(Q_SPFres_p(:, looky_mackerelCarangidae), 2);
    Q_SPFres_mackerelScombridae               	= sum(Q_SPFres_p(:, looky_mackerelScombridae), 2);
    Q_SPFres_anchovy                          	= sum(Q_SPFres_p(:, looky_anchovy), 2);
    Q_SPFres_BongaShad                        	= sum(Q_SPFres_p(:, looky_BongaShad), 2);
    Q_SPFres_FlyingFishEtc                    	= sum(Q_SPFres_p(:, looky_FlyingFishEtc), 2);
    Q_SPFres_herring                           	= sum(Q_SPFres_p(:, looky_herring), 2);
    Q_SPFres_menhaden                        	= sum(Q_SPFres_p(:, looky_menhaden), 2);
    Q_SPFres_sardine                           	= sum(Q_SPFres_p(:, looky_sardine), 2);
    Q_SPFres_shad                              	= sum(Q_SPFres_p(:, looky_shad), 2);
    Q_SPFres_smelt                           	= sum(Q_SPFres_p(:, looky_smelt), 2);
    Q_SPFres_sprat                          	= sum(Q_SPFres_p(:, looky_sprat), 2);
    % ---------------------------------------------------------------------
    
	% replace producer columns --------------------------------------------
    % SPFagg --------------
    Q_SPFagg                                   	= Q_SPFagg_p;
    Q_SPFagg(:, looky_seabird)                 	= repmat(Q_SPFagg_seabirds,           [1, length(looky_seabird)]);
    Q_SPFagg(:, looky_mammal)                	= repmat(Q_SPFagg_mammals,            [1, length(looky_mammal)]);
    Q_SPFagg(:, looky_fleet)                  	= repmat(Q_SPFagg_fleets,             [1, length(looky_fleet)]);    
    Q_SPFagg(:, looky_ForageFish)              	= repmat(Q_SPFagg_ForageFish,         [1, length(looky_ForageFish)]);
    Q_SPFagg(:, looky_MesopelagicFish)         	= repmat(Q_SPFagg_MesopelagicFish,    [1, length(looky_MesopelagicFish)]);
    Q_SPFagg(:, looky_mackerelCarangidae)       = repmat(Q_SPFagg_mackerelCarangidae, [1, length(looky_mackerelCarangidae)]);
    Q_SPFagg(:, looky_mackerelScombridae)    	= repmat(Q_SPFagg_mackerelScombridae, [1, length(looky_mackerelScombridae)]);
    
    % SPFres --------------
    Q_SPFres                                   	= Q_SPFres_p;
    Q_SPFres(:, looky_seabird)               	= repmat(Q_SPFres_seabirds,           [1, length(looky_seabird)]);
    Q_SPFres(:, looky_mammal)                	= repmat(Q_SPFres_mammals,            [1, length(looky_mammal)]);
    Q_SPFres(:, looky_fleet)                	= repmat(Q_SPFres_fleets,             [1, length(looky_fleet)]);    
    Q_SPFres(:, looky_MesopelagicFish)      	= repmat(Q_SPFres_MesopelagicFish,    [1, length(looky_MesopelagicFish)]);
    Q_SPFres(:, looky_mackerelCarangidae)       = repmat(Q_SPFres_mackerelCarangidae, [1, length(looky_mackerelCarangidae)]);
    Q_SPFres(:, looky_mackerelScombridae)    	= repmat(Q_SPFres_mackerelScombridae, [1, length(looky_mackerelScombridae)]);
    Q_SPFres(:, looky_anchovy)              	= repmat(Q_SPFres_anchovy,            [1, length(looky_anchovy)]);
    Q_SPFres(:, looky_BongaShad)            	= repmat(Q_SPFres_BongaShad,          [1, length(looky_BongaShad)]);
    Q_SPFres(:, looky_FlyingFishEtc)         	= repmat(Q_SPFres_FlyingFishEtc,      [1, length(looky_FlyingFishEtc)]);
    Q_SPFres(:, looky_herring)              	= repmat(Q_SPFres_herring,            [1, length(looky_herring)]);
    Q_SPFres(:, looky_menhaden)             	= repmat(Q_SPFres_menhaden,           [1, length(looky_menhaden)]);
    Q_SPFres(:, looky_sardine)              	= repmat(Q_SPFres_sardine,            [1, length(looky_sardine)]);
    Q_SPFres(:, looky_shad)                 	= repmat(Q_SPFres_shad,               [1, length(looky_shad)]);
    Q_SPFres(:, looky_smelt)                	= repmat(Q_SPFres_smelt,              [1, length(looky_smelt)]);
    Q_SPFres(:, looky_sprat)                 	= repmat(Q_SPFres_sprat,              [1, length(looky_sprat)]);
    % ---------------------------------------------------------------------
    
    % delete duplicate consumer rows --------------------------------------
    % NOTE: looky_ variables are still good pointers to column addresses at this point
    % NOTE: after this step, all the looky_ variables will need to be redefined separately for SPFagg & SPFres (but they are still good for the fully-resolved model)
    % SPFagg --------------
    Q_SPFagg(:, looky_SPFagg_duplicates)        = [];
    
    % SPFres --------------
	Q_SPFres(:, looky_SPFres_duplicates)        = [];
    % ---------------------------------------------------------------------
    
    
    % step 4d: rebuild DIET & TrophicMatrix from ConsumptionMatrix --------
    [num_grps, ~]                               = size(Q_cp);
    [num_grps_SPFagg, ~]                        = size(Q_SPFagg);
    [num_grps_SPFres, ~]                        = size(Q_SPFres);
    
    % original model ------
    q_producers                                 = sum(Q_cp, 1); % (horizontal vector: 1 X num_grps)
    q_consumers                                 = sum(Q_cp, 2);	% (vertical vector: num_grps X 1)
    
    q_producers_repmat                          = repmat(q_producers, [num_grps, 1]); % q_producers replicated down rows; (2D matrix: num_grps X num_grps)
    q_consumers_repmat                          = repmat(q_consumers, [1, num_grps]); % q_consumers replicated across columns; (2D matrix: num_grps X num_grps)
    
    A_cp                                        = Q_cp ./ q_producers_repmat; % (2D matrix: num_grps X num_grps); QQQ flows out of detritus (clms) are all 0
    A_cp(isnan(A_cp))                           = 0;
    
    DIET_cp                                     = Q_cp ./ q_consumers_repmat; % (2D matrix: num_grps X num_grps)
    DIET_cp(isnan(DIET_cp))                     = 0;
    DIET_pc                                     = DIET_cp'; % put DIET into proper orientation; (2D matrix: num_grps X num_grps); NOTE transpose;
    % --------------------
        
    
    % SPFagg -------------
    q_producers_SPFagg              = sum(Q_SPFagg, 1); % (horizontal vector: 1 X num_grps_SPFagg)
    q_consumers_SPFagg              = sum(Q_SPFagg, 2);	% (vertical vector: num_grps_SPFagg X 1)
    
    q_producers_SPFagg_repmat       = repmat(q_producers_SPFagg, [num_grps_SPFagg, 1]); % q_producers replicated down rows; (2D matrix: num_grps_SPFagg X num_grps_SPFagg)
    q_consumers_SPFagg_repmat       = repmat(q_consumers_SPFagg, [1, num_grps_SPFagg]); % q_consumers replicated across columns; (2D matrix: num_grps_SPFagg X num_grps_SPFagg)
    
    A_cp_SPFagg                     = Q_SPFagg ./ q_producers_SPFagg_repmat; % (2D matrix: num_grps_SPFagg X num_grps_SPFagg); QQQ flows out of detritus (clms) are all 0
    A_cp_SPFagg(isnan(A_cp_SPFagg))	= 0;

    DIET_cp_SPFagg                 = Q_SPFagg ./ q_consumers_SPFagg_repmat; % (2D matrix: num_grps_SPFagg X num_grps_SPFagg)
    DIET_cp_SPFagg(isnan(DIET_cp_SPFagg))	= 0;
    DIET_pc_SPFagg                 = DIET_cp_SPFagg'; % put DIET into proper orientation; (2D matrix: num_grps_SPFagg X num_grps_SPFagg); NOTE transpose;
    % --------------------

    
    % SPFres -------------
    q_producers_SPFres              = sum(Q_SPFres, 1); % (horizontal vector: 1 X num_grps_SPFres)
    q_consumers_SPFres              = sum(Q_SPFres, 2);	% (vertical vector: num_grps_SPFres X 1)
    
    q_producers_SPFres_repmat       = repmat(q_producers_SPFres, [num_grps_SPFres, 1]); % q_producers replicated down rows; (2D matrix: num_grps_SPFres X num_grps_SPFres)
    q_consumers_SPFres_repmat       = repmat(q_consumers_SPFres, [1, num_grps_SPFres]); % q_consumers replicated across columns; (2D matrix: num_grps_SPFres X num_grps_SPFres)
    
    A_cp_SPFres                     = Q_SPFres ./ q_producers_SPFres_repmat; % (2D matrix: num_grps_SPFres X num_grps_SPFres); QQQ flows out of detritus (clms) are all 0
    A_cp_SPFres(isnan(A_cp_SPFres))	= 0;

    DIET_cp_SPFres                 = Q_SPFres ./ q_consumers_SPFres_repmat; % (2D matrix: num_grps_SPFres X num_grps_SPFres)
    DIET_cp_SPFres(isnan(DIET_cp_SPFres))	= 0;
    DIET_pc_SPFres                 = DIET_cp_SPFres'; % put DIET into proper orientation; (2D matrix: num_grps_SPFres X num_grps_SPFres); NOTE transpose;
    % *********************************************************************

    
    
    % *********************************************************************
    % STEP 5: get addresses within aggregated models ----------------------
    % SPFagg -------------
	looky_SPFagg_ALLconsumers                          = find(round(EcoBase_SPFaggGroupType, 0) == 3);
    
	looky_SPFagg_zooplankton                            = find(round(EcoBase_SPFaggGroupType, 2) == 3.11); 
	looky_SPFagg_micronekton                            = find(round(EcoBase_SPFaggGroupType, 2) == 3.12); 
	looky_SPFagg_ALLzooplankton                         = [looky_SPFagg_zooplankton; looky_SPFagg_micronekton]; % zooplankton & micronekton grouping
    
	looky_SPFagg_squid                                  = find(round(EcoBase_SPFaggGroupType, 2) == 3.13); 
	looky_SPFagg_octopus                                = find(round(EcoBase_SPFaggGroupType, 2) == 3.23); 
	looky_SPFagg_cephalopod                             = find(round(EcoBase_SPFaggGroupType, 2) == 3.03); 
    looky_SPFagg_cephalopod                             = sort([looky_SPFagg_cephalopod; looky_SPFagg_squid; looky_SPFagg_octopus]); % pool all cephalopds together since benthics & pelagics are often hard to distinguish in the models

	looky_SPFagg_ALLfish                                = find(strcmp(EcoBase_SPFaggMajorClass, 'fish'));
    looky_SPFagg_PELAGICfish                            = find(round(EcoBase_SPFaggGroupType, 2) == 3.14);
	looky_SPFagg_DEMERSALfish                           = find(round(EcoBase_SPFaggGroupType, 2) == 3.24);
    looky_SPFagg_ForageFish                             = find(strcmp(EcoBase_SPFaggType_aggregated, 'forage fish'));
    looky_SPFagg_MesopelagicFish                    	= find(strcmp(EcoBase_SPFaggType_aggregated, 'mesopelagic fish') | strcmp(EcoBase_SPFaggType_aggregated, 'mesopealgic fish'));    
    looky_SPFagg_PELAGICfish_nonSPF                     = looky_SPFagg_PELAGICfish(~ismember(looky_SPFagg_PELAGICfish, [looky_SPFagg_ForageFish; looky_SPFagg_MesopelagicFish]));
    
	looky_SPFagg_mackerelCarangidae                     = find(strcmp(EcoBase_SPFaggType_resolved, 'mackerel - Carangidae'));    
    looky_SPFagg_mackerelScombridae                  	= find(strcmp(EcoBase_SPFaggType_resolved, 'mackerel - Scombridae'));    

    % QQQ patch to remove mackerel from ForageFish but include in PELAGICfish_nonSPF --------
    looky_SPFagg_ForageFish                     = looky_SPFagg_ForageFish(~ismember(looky_SPFagg_ForageFish, [looky_SPFagg_mackerelCarangidae; looky_SPFagg_mackerelScombridae]));
    looky_SPFagg_PELAGICfish_nonSPF             = looky_SPFagg_PELAGICfish(~ismember(looky_SPFagg_PELAGICfish, [looky_SPFagg_ForageFish; looky_SPFagg_MesopelagicFish]));
    % QQQ  ----------------------------------
    
	looky_SPFagg_seabird                                = find(strcmp(EcoBase_SPFaggMajorClass, 'seabird'));
    looky_SPFagg_mammal                                 = find(strcmp(EcoBase_SPFaggMajorClass, 'mammal'));
	looky_SPFagg_fleet                                  = find(round(EcoBase_SPFaggGroupType, 0) == 5); 
    % --------------------
    
    
	% SPFres -------------
	looky_SPFres_ALLconsumers                          = find(round(EcoBase_SPFresGroupType, 0) == 3);
    
	looky_SPFres_zooplankton                            = find(round(EcoBase_SPFresGroupType, 2) == 3.11); 
	looky_SPFres_micronekton                            = find(round(EcoBase_SPFresGroupType, 2) == 3.12); 
	looky_SPFres_ALLzooplankton                         = [looky_SPFres_zooplankton; looky_SPFres_micronekton]; % zooplankton & micronekton grouping
    
	looky_SPFres_squid                                  = find(round(EcoBase_SPFresGroupType, 2) == 3.13); 
	looky_SPFres_octopus                                = find(round(EcoBase_SPFresGroupType, 2) == 3.23); 
	looky_SPFres_cephalopod                             = find(round(EcoBase_SPFresGroupType, 2) == 3.03); 
    looky_SPFres_cephalopod                             = sort([looky_SPFres_cephalopod; looky_SPFres_squid; looky_SPFres_octopus]); % pool all cephalopds together since benthics & pelagics are often hard to distinguish in the models

	looky_SPFres_ALLfish                             	= find(strcmp(EcoBase_SPFresMajorClass, 'fish'));
    looky_SPFres_PELAGICfish                            = find(round(EcoBase_SPFresGroupType, 2) == 3.14);
	looky_SPFres_DEMERSALfish                           = find(round(EcoBase_SPFresGroupType, 2) == 3.24);
    looky_SPFres_ForageFish                             = find(strcmp(EcoBase_SPFresType_aggregated, 'forage fish'));
    looky_SPFres_MesopelagicFish                    	= find(strcmp(EcoBase_SPFresType_aggregated, 'mesopelagic fish') | strcmp(EcoBase_SPFresType_aggregated, 'mesopealgic fish'));    
    looky_SPFres_PELAGICfish_nonSPF                     = looky_SPFres_PELAGICfish(~ismember(looky_SPFres_PELAGICfish, [looky_SPFres_ForageFish; looky_SPFres_MesopelagicFish]));
    
    looky_SPFres_anchovy                                = find(strcmp(EcoBase_SPFresType_resolved, 'anchovy'));
    looky_SPFres_BongaShad                           	= find(strcmp(EcoBase_SPFresType_resolved, 'bonga shad'));    
    looky_SPFres_FlyingFishEtc                      	= find(strcmp(EcoBase_SPFresType_resolved, 'flying fish & halfbeaks & saury'));
    looky_SPFres_herring                                = find(strcmp(EcoBase_SPFresType_resolved, 'herring'));    
    looky_SPFres_mackerelCarangidae                     = find(strcmp(EcoBase_SPFresType_resolved, 'mackerel - Carangidae'));    
    looky_SPFres_mackerelScombridae                     = find(strcmp(EcoBase_SPFresType_resolved, 'mackerel - Scombridae'));    
    looky_SPFres_menhaden                            	= find(strcmp(EcoBase_SPFresType_resolved, 'menhaden'));    
    looky_SPFres_sardine                            	= find(strcmp(EcoBase_SPFresType_resolved, 'sardine'));    
    looky_SPFres_shad                                   = find(strcmp(EcoBase_SPFresType_resolved, 'shad'));    
    looky_SPFres_smelt                               	= find(strcmp(EcoBase_SPFresType_resolved, 'smelt'));    
    looky_SPFres_sprat                              	= find(strcmp(EcoBase_SPFresType_resolved, 'sprat'));

    % QQQ patch to remove mackerel from ForageFish but include in PELAGICfish_nonSPF --------
    looky_SPFres_ForageFish                     = looky_SPFres_ForageFish(~ismember(looky_SPFres_ForageFish, [looky_SPFres_mackerelCarangidae; looky_SPFres_mackerelScombridae]));
    looky_SPFres_PELAGICfish_nonSPF             = looky_SPFres_PELAGICfish(~ismember(looky_SPFres_PELAGICfish, [looky_SPFres_ForageFish; looky_SPFres_MesopelagicFish]));
    % QQQ  ----------------------------------
    
	looky_SPFres_seabird                                = find(strcmp(EcoBase_SPFresMajorClass, 'seabird'));
    looky_SPFres_mammal                                 = find(strcmp(EcoBase_SPFresMajorClass, 'mammal'));
	looky_SPFres_fleet                                  = find(round(EcoBase_SPFresGroupType, 0) == 5); 
    % *********************************************************************

    
    
    
    % *********************************************************************
    % STEP 6: calculate MTI matrices---------------------------------------
    %         NOTE: as defined in method of Ulanowicz & Puccia 1990
	looky_ANYdetritus                           = find(round(EcoBase_GroupType, 0) == 4);
	looky_SPFaggANYdetritus                  	= find(round(EcoBase_SPFaggGroupType, 0) == 4);
	looky_SPFresANYdetritus                   	= find(round(EcoBase_SPFresGroupType, 0) == 4);

    make_plot = 'n';
        
    [MTI_xy_FULLres, tMTI_FULLres]	= f_calcMTI_10062023(DIET_pc,        A_cp,        biomass,        looky_ANYdetritus,       make_plot); % MTI (2D matrix: num_grps X num_grps); tMTI (vertical vector: num_grps X 1)
    [MTI_xy_SPFagg, tMTI_SPFagg]	= f_calcMTI_10062023(DIET_pc_SPFagg, A_cp_SPFagg, biomass_SPFagg, looky_SPFaggANYdetritus, make_plot); % (2D matrix: num_grps_SPFagg X num_grps_SPFagg)
    [MTI_xy_SPFres, tMTI_SPFres]	= f_calcMTI_10062023(DIET_pc_SPFres, A_cp_SPFres, biomass_SPFres, looky_SPFresANYdetritus, make_plot); % (2D matrix: num_grps_SPFres X num_grps_SPFres)
    % *********************************************************************
    
    
    
    % *********************************************************************
    % STEP 7: summarize MTI results----------------------------------------
    
    % step 7a: pack up results for aggregated ForageFish group ------------
    target_loop                                 = 8; % ForageFish position
	looky_currentGrp                            = looky_SPFagg_ForageFish; % addresses of current prey groups; NOTE: use SPFagg for aggregated ForageFish
	label_currentGrp                            = Grp_labels{target_loop};        % label of current aggregated prey group
    
    % percentile positions in tMTI
    tMTI_SPFagg_target	= tMTI_SPFagg(looky_SPFagg_ForageFish);
    if length(tMTI_SPFagg_target) == 1
        num_less              	= sum(tMTI_SPFagg < tMTI_SPFagg_target); % number of groups with tMTI less than tMTI_SPFagg_ForageFish
        num_equal              	= sum(tMTI_SPFagg == tMTI_SPFagg_target); % number of groups with tMTI equal to tMTI_SPFagg_ForageFish
        percentile_tMTI         = round((100 * (num_less + (0.5*num_equal)) / length(tMTI_SPFagg)), 0);
    else
        percentile_tMTI         = NaN;
        tMTI_SPFagg_target      = NaN;
    end
    
	PositionCounter.(cn{target_loop})                           	= PositionCounter.(cn{target_loop}) + 1;
	counter_currentGrp                                           	= PositionCounter.(cn{target_loop});
        
	CompiledMTI.(fn{target_loop}).label                             = label_currentGrp;
    
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 1}   	= ReadFile_name;
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 2}       = EcoBase_ModelNumber;          % EcoBase model number
	CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 3}    	= label_currentGrp;
    
    % full-resolution model
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 4}     	= looky_ForageFish;             % group addresses in full res model
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 5}      	= EcoBase_FULLresName;          % ALL original group names
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 6}      	= EcoBase_FULLresGroupType;     % ALL ECOTRAN group type codes
	CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 7}   	= MTI_xy_FULLres;             	% MTI matrix
	CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 8}   	= tMTI_FULLres;               	% total MTI vector
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 9}     	= DIET_pc;                      % DIET matrix 
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 10}     	= A_cp;                         % A_cp TrophicMatrix
    
    % ForageFish-aggregation model
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 11}     	= looky_SPFagg_ForageFish; % group addresses in ForageFish-aggregation model
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 12}      = EcoBase_SPFaggName;           % ALL ForageFish-aggregation group names
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 13}      = EcoBase_SPFaggGroupType;      % ALL ForageFish-aggregation ECOTRAN group type codes
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 14}      = MTI_xy_SPFagg;                   % MTI matrix
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 15}      = tMTI_SPFagg;                   % total MTI vector
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 16}      = DIET_pc_SPFagg;             	% DIET matrix 
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 17}      = A_cp_SPFagg;                	% A_cp TrophicMatrix

    % SPF group-resolved model
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 18}     	= looky_SPFres_ForageFish; % group addresses in SPF group-resolved model
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 19}     	= EcoBase_SPFresName;           % ALL ForageFish-aggregation group names
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 20}      = EcoBase_SPFresGroupType;      % ALL ForageFish-aggregation ECOTRAN group type codes
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 21}      = MTI_xy_SPFres;                   % MTI matrix
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 22}      = tMTI_SPFres;                   % total MTI vector
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 23}      = DIET_pc_SPFres;             	% DIET matrix 
    CompiledMTI.(fn{target_loop}).text{counter_currentGrp, 24}      = A_cp_SPFres;                	% A_cp TrophicMatrix
    
	CompiledMTI.(fn{target_loop}).parameters(counter_currentGrp, 1)	= EcoBase_ModelNumber;
	CompiledMTI.(fn{target_loop}).parameters(counter_currentGrp, 2)	= percentile_tMTI;
	CompiledMTI.(fn{target_loop}).parameters(counter_currentGrp, 3)	= tMTI_SPFagg_target;
	% ---------------------------------------------------------------------
    
    
    % step 7b: define prey group addresses & labels in current model ------
    %          NOTE: comment out all groups that have not been aggregated into a single functional group
    Grp_addresses	= {
%                         looky_PrimaryProducer
%                         looky_ALLzooplankton
%                         looky_BenthicInvertebrate
%                         looky_cephalopod                % all pelagic & benthic
%                         looky_ALLfish
%                         looky_PELAGICfish_nonSPF
%                         looky_DEMERSALfish
%                         looky_SPFagg_ForageFish             % NOTE: use SPFagg for aggregated ForageFish in separate case below...
                        looky_SPFres_MesopelagicFish
                        looky_SPFres_anchovy
                        looky_SPFres_BongaShad
                        looky_SPFres_FlyingFishEtc             % flying fish & halfbeaks & saury
                        looky_SPFres_herring
                        looky_SPFres_mackerelCarangidae
                        looky_SPFres_mackerelScombridae
                        looky_SPFres_menhaden
                        looky_SPFres_sardine
                        looky_SPFres_shad
                        looky_SPFres_smelt
                        looky_SPFres_sprat
                        looky_SPFres_seabird
                        looky_SPFres_mammal
                        looky_SPFres_fleet
                    };
                
	num_targetGrps	= length(Grp_addresses);
    % ---------------------------------------------------------------------
        
    
    % step 7c: pack up results for each (aggregated) group ----------------
	for target_loop = 1:num_targetGrps
        
        looky_currentGrp                            = cell2mat(Grp_addresses(target_loop)); % addresses of current prey groups
        label_currentGrp                            = Grp_labels{target_loop+8};              % label of current aggregated prey group
    
        % percentile positions in tMTI
        tMTI_SPFres_target          = tMTI_SPFres(looky_currentGrp);
        if length(tMTI_SPFres_target) == 1
            num_less              	= sum(tMTI_SPFres < tMTI_SPFres_target);    % number of groups with tMTI less than tMTI_SPFagg_ForageFish
            num_equal              	= sum(tMTI_SPFres == tMTI_SPFres_target);	% number of groups with tMTI equal to tMTI_SPFagg_ForageFish
            percentile_tMTI         = round((100 * (num_less + (0.5*num_equal)) / length(tMTI_SPFres)), 0);
        else
            percentile_tMTI         = NaN;
            tMTI_SPFres_target      = NaN;
        end
        % ------------------------------------
    

        PositionCounter.(cn{target_loop+8})                                 = PositionCounter.(cn{target_loop+8}) + 1; % NOTE +8 because we skip groups from PrimaryProducers - ForageFish
        counter_currentGrp                                                  = PositionCounter.(cn{target_loop+8});

        CompiledMTI.(fn{target_loop+8}).label                               = label_currentGrp;

        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 1}         = ReadFile_name;
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 2}         = EcoBase_ModelNumber;          % EcoBase model number
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 3}         = label_currentGrp;

        % full-resolution model
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 4}     	= looky_ForageFish;             % group addresses in full res model
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 5}      	= EcoBase_FULLresName;          % ALL original group names
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 6}      	= EcoBase_FULLresGroupType;     % ALL ECOTRAN group type codes
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 7}         = MTI_xy_FULLres;              	% MTI matrix
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 8}         = tMTI_FULLres;              	% total MTI vector
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 9}     	= DIET_pc;                      % DIET matrix 
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 10}     	= A_cp;                         % A_cp TrophicMatrix

        % ForageFish-aggregation model
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 11}    	= looky_SPFagg_ForageFish;      % group addresses in ForageFish-aggregation model
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 12}        = EcoBase_SPFaggName;           % ALL ForageFish-aggregation group names
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 13}        = EcoBase_SPFaggGroupType;      % ALL ForageFish-aggregation ECOTRAN group type codes
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 14}        = MTI_xy_SPFagg;             	% MTI matrix
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 15}        = tMTI_SPFagg;                	% total MTI vector
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 16}        = DIET_pc_SPFagg;             	% DIET matrix 
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 17}        = A_cp_SPFagg;                	% A_cp TrophicMatrix

        % SPF group-resolved model
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 18}        = looky_SPFres_ForageFish;      % group addresses in SPF group-resolved model
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 19}     	= EcoBase_SPFresName;           % ALL ForageFish-aggregation group names
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 20}        = EcoBase_SPFresGroupType;      % ALL ForageFish-aggregation ECOTRAN group type codes
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 21}        = MTI_xy_SPFres;             	% MTI matrix
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 22}        = tMTI_SPFres;                	% total MTI vector
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 23}        = DIET_pc_SPFres;             	% DIET matrix 
        CompiledMTI.(fn{target_loop+8}).text{counter_currentGrp, 24}        = A_cp_SPFres;                	% A_cp TrophicMatrix

        CompiledMTI.(fn{target_loop+8}).parameters(counter_currentGrp, 1)	= EcoBase_ModelNumber;
        CompiledMTI.(fn{target_loop+8}).parameters(counter_currentGrp, 2)	= percentile_tMTI;
        CompiledMTI.(fn{target_loop+8}).parameters(counter_currentGrp, 3)	= tMTI_SPFres_target;
        % -----------------------------------------------------------------    
    
    end % (target_loop)
    % *********************************************************************

end % (model_loop)
% *************************************************************************



% STEP 5: SAVE RESULTS ****************************************************           
save(SaveFile, 'CompiledMTI')
% *************************************************************************


% end m-file***************************************************************