% CompileParameters_10012023
% Harvest SPF group EwE parameters from queried Ecobase models
%   -- read matlab versions of ECOBASE models from lists (.mat), 
%   -- find small pelagic fish groups
%   -- compile EwE parameter info
%   -- save results as .mat file
% calls:
%       f_OmnivoryIndex_01272023
%
% revision date: 10/1/2023
%   9/14/2023 re-organized functional groups returned; added some new parameters
%   9/18/2023 using catch_total ratios instead of landings_total ratios
%   10/1/2023 adding mackerel patch


% *************************************************************************
% STEP 1: define model-set directories & save files------------------------

ReadFile_directory	= '/3_Matlab_versions/Atlantic_MATLAB_versions/';
SaveFile_name     	= ['Compiled_Parameters_Atlantic_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/Pacific_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_Parameters_Pacific_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/OtherRegions_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_Parameters_OtherRegions_' num2str(date)];

% ReadFile_directory      = '/3_Matlab_versions/LiteratureModels_MATLAB_versions/';
% SaveFile_name           = ['Compiled_Parameters_LiteratureEntries_' num2str(date)];

SaveFile_directory      = '/5_Analyses/Ecopath_parameters/';
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
            
num_targetGrps = length(Grp_labels);
% -------------------------------------------------------------------------


% step 2b: initialize CompiledParameters variable -------------------------
parameterLabel	= {'model_number', 'looky_grp', 'TL', 'OmnivoryIndex', 'biomass', 'biomass_2_biomass_ALLfish', ...
                   'production', 'pb', 'qb', 'pq', 'ae', 'landings_pooled', 'discards_pooled', 'catch_pooled', ...
                   'catch_pooled_2_CatchTotal', 'production_2_PrimaryProductionTotal', ...
                   'production_2_production_PELAGICfish', 'production_2_production_ALLfish'};

CompiledParameters.TG1.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG1.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG1.parameters	= zeros(1, 18); % initialize variable that will grow
CompiledParameters.TG1.parameterLabel	= parameterLabel; % initialize variable that will grow


CompiledParameters.TG2.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG2.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG2.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG2.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG3.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG3.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG3.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG3.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG4.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG4.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG4.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG4.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG5.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG5.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG5.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG5.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG6.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG6.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG6.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG6.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG7.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG7.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG7.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG7.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG8.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG8.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG8.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG8.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG9.label      	= cell(1);      % initialize cell that will grow
CompiledParameters.TG9.text        = cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG9.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG9.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG10.label     	= cell(1);      % initialize cell that will grow
CompiledParameters.TG10.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG10.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG10.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG11.label     	= cell(1);      % initialize cell that will grow
CompiledParameters.TG11.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG11.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG11.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG12.label    	= cell(1);      % initialize cell that will grow
CompiledParameters.TG12.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG12.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG12.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG13.label    	= cell(1);      % initialize cell that will grow
CompiledParameters.TG13.text    	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG13.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG13.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG14.label   	= cell(1);      % initialize cell that will grow
CompiledParameters.TG14.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG14.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG14.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG15.label     	= cell(1);      % initialize cell that will grow
CompiledParameters.TG15.text      	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG15.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG15.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG16.label   	= cell(1);      % initialize cell that will grow
CompiledParameters.TG16.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG16.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG16.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG17.label    	= cell(1);      % initialize cell that will grow
CompiledParameters.TG17.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG17.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG17.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG18.label  	= cell(1);      % initialize cell that will grow
CompiledParameters.TG18.text    	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG18.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG18.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG19.label    	= cell(1);      % initialize cell that will grow
CompiledParameters.TG19.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG19.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG19.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG20.label    	= cell(1);      % initialize cell that will grow
CompiledParameters.TG20.text    	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG20.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG20.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG21.label     	= cell(1);      % initialize cell that will grow
CompiledParameters.TG21.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG21.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG21.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG22.label  	= cell(1);      % initialize cell that will grow
CompiledParameters.TG22.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG22.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG22.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledParameters.TG23.label     	= cell(1);      % initialize cell that will grow
CompiledParameters.TG23.text     	= cell(1, 4);   % initialize cell that will grow
CompiledParameters.TG23.parameters	= zeros(1, 18);	% initialize variable that will grow
CompiledParameters.TG23.parameterLabel	= parameterLabel; % initialize variable that will grow

fn      = fieldnames(CompiledParameters);
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

cn = fieldnames(PositionCounter);
% *************************************************************************





% *************************************************************************
% STEP 3: process each .mat model in ReadFile_directory--------------------
FolderContents          = dir([ReadFile_directory '*.mat']); % dir struct of all pertinent .mat files
num_files               = length(FolderContents); % count of .mat files

for model_loop = 1:num_files

    % step 3a: load model parameters (dat) --------------------------------
	ReadFile_name           = FolderContents(model_loop).name; 
    ReadFile                = [ReadFile_directory ReadFile_name];
    
    disp(['Processing file: ' ReadFile_name])
    
    load(ReadFile, 'dat')
    % ---------------------------------------------------------------------
    
    
    % step 3b: up-pack variables in current model -------------------------
    EcoBase_OriginalGroupName                   = dat.EcoBase_OriginalGroupName;
    EcoBase_GroupType                           = dat.EcoBase_GroupType;
    EcoBase_MajorClass                          = dat.EcoBase_MajorClass;
    EcoBase_SPFtype_resolved                    = dat.EcoBase_SPFtype_resolved;
    EcoBase_SPFtype_aggregated                  = dat.EcoBase_SPFtype_aggregated;
    
    EcoBase_ModelNumber                         = dat.EcoBase_ModelNumber;
    EcoBase_ecotype                             = dat.EcoBase_ecotype;
    
    biomass                                     = dat.Biomass;
    pb                                          = dat.PB;
    qb                                          = dat.QB;
	pq                                          = dat.PQ;
    ae                                          = dat.AE;
    
    landings                                    = dat.landings;
    discards                                    = dat.discards;
    
    TL                                          = dat.TL; % (vertical vector: num_grps X 1)
    DIET                                        = dat.diet;
        
    num_fleets                                  = dat.num_gear;
    num_grps                                    = dat.num_EwEGroups;
    % ---------------------------------------------------------------------
    
    
	% step 3c: remove nutrient rows in order to match rows of EwE parameters -------
    looky_nutrients                             = find(round(EcoBase_GroupType, 0) == 1);
    EcoBase_OriginalGroupName(looky_nutrients)  = [];
    EcoBase_GroupType(looky_nutrients)          = [];
    EcoBase_MajorClass(looky_nutrients)         = [];
    EcoBase_SPFtype_resolved(looky_nutrients)   = [];
    EcoBase_SPFtype_aggregated(looky_nutrients)	= [];
    
    EcoBase_ecotype(looky_nutrients)            = []; % (vertical vector: num_grps X 1) EwE order excluding nutrients
    % ---------------------------------------------------------------------

    
    % step 3d: find target groups -----------------------------------------
	looky_ALLconsumers                          = find(round(EcoBase_GroupType, 0) == 3);

    looky_PrimaryProducer                       = find(round(EcoBase_GroupType, 0) == 2);
    
	looky_micrograzers                          = find(round(EcoBase_GroupType, 3) == 3.111);
    
	looky_zooplankton                           = find(round(EcoBase_GroupType, 2) == 3.11); 
	looky_micronekton                           = find(round(EcoBase_GroupType, 2) == 3.12);
	looky_ALLzooplankton                        = [looky_zooplankton; looky_micronekton]; % zooplankton + micronekton grouping

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
    % ---------------------------------------------------------------------
    
    
    % combine all fleets --------------------------------------------------
    % filter out NaNs (an error on reading matlab file for NCC model)
    landings(isnan(landings))       = 0;
    discards(isnan(discards))       = 0;
    
    landings_pooled                 = sum(landings, 2);
    discards_pooled                 = sum(discards, 2);
    landings_pooled_total           = sum(landings_pooled);
    discards_pooled_total           = sum(discards_pooled);
    landings_pooled                 = [landings_pooled; zeros(length(looky_fleet), 1)]; % append zeros for fleets; (vertical vector: num_grps X 1)
    discards_pooled                 = [discards_pooled; zeros(length(looky_fleet), 1)]; % append zeros for fleets; (vertical vector: num_grps X 1)
    landings_total_byFleet          = sum(dat.landings, 1); % (horizontal vector: 1 X num_fleets)
    discards_total_byFleet          = sum(dat.discards, 1); % (horizontal vector: 1 X num_fleets)
    catch_total_byFleet             = (landings_total_byFleet + discards_total_byFleet); % (horizontal vector: 1 X num_fleets)
    catch_pooled                    = landings_pooled + discards_pooled; % (vertical vector: num_grps X 1)
    catch_pooled_total              = sum(catch_pooled);
    
    biomass(looky_fleet)            = catch_total_byFleet';
    pb(looky_fleet)                 = landings_total_byFleet' ./ catch_total_byFleet';
    qb(looky_fleet)                 = catch_total_byFleet' ./ catch_total_byFleet';
    pq(looky_fleet)                 = landings_total_byFleet' ./ catch_total_byFleet';
    ae(looky_fleet)                 = landings_total_byFleet' ./ catch_total_byFleet';
    pb(isnan(pb))                   = 0; % fix div/0 error
    qb(isnan(qb))                   = 0; % fix div/0 error
    pq(isnan(pq))                   = 0; % fix div/0 error
    ae(isnan(ae))                   = 0; % fix div/0 error
    % ---------------------------------------------------------------------
    
    
    % calculate production rates ------------------------------------------
    production_rate                 = biomass .* pb; % (vertical vector: num_grps X 1)
    PrimaryProduction_total         = sum(production_rate(looky_PrimaryProducer));
    PelagicFishProduction_total     = sum(production_rate(looky_PELAGICfish));
    DemersalFishProduction_total	= sum(production_rate(looky_DEMERSALfish));
    FishProduction_total          	= sum(production_rate(looky_ALLfish)); % (scaler)
    FishBiomass_total               = sum(biomass(looky_ALLfish)); % (scaler)
    % ---------------------------------------------------------------------
    
    
    % calculate OmnivoryIndex ---------------------------------------------
    DIET(:, 1)	= []; % remove left header column
    DIET(1, :)	= []; % remove top header row
    
    if num_fleets > 0
        fleet_catch                             = landings + discards;
        fleet_diet                              = fleet_catch ./ sum(fleet_catch, 1);
        fleet_diet(isnan(fleet_diet))           = 0; % correct div/0 error (should not be necessary)
        fleet_diet((end+1):(end+num_fleets), :) = 0;
        DIET((end+1):(end+num_fleets), :)       = 0; % add rows for fleets (fleets always at the end)
        DIET(:, (end+1):(end+num_fleets))       = fleet_diet; % append fleet "diets"; (2D matrix: num_grps X num_grps)
    end
        
%     % renormalize to sum to 1 (because we ignore import diet)
%     [rows_DIET, ~]	= size(DIET);
%     sum_DIET        = sum(DIET);
%     sum_DIET_repmat = repmat(sum_DIET, [rows_DIET, 1]);
%     DIET            = DIET ./ sum_DIET_repmat;
%     DIET(isnan(DIET)) = 0; % correct div/0 error
    
	[OmnivoryIndex, fname_OmnivoryIndex]        = f_OmnivoryIndex_01272023(TL, DIET); % (vertical vector: num_grps X 1)
    % ---------------------------------------------------------------------
    
    
    
    % *********************************************************************
    % STEP 4: compile results for each group type -------------------------
    Grp_addresses	= {
                        looky_PrimaryProducer
                        looky_ALLzooplankton
                        looky_BenthicInvertebrate
                        looky_cephalopod % all pelagic & benthic
                        looky_ALLfish
                        looky_PELAGICfish_nonSPF
                        looky_DEMERSALfish
                        looky_ForageFish
                        looky_MesopelagicFish
                        looky_anchovy
                        looky_BongaShad
                        looky_FlyingFishEtc
                        looky_herring
                        looky_mackerelCarangidae
                        looky_mackerelScombridae
                        looky_menhaden
                        looky_sardine
                        looky_shad
                        looky_smelt
                        looky_sprat
                        looky_seabird
                        looky_mammal
                        looky_fleet
                    };
        
    
    for target_loop = 1:num_targetGrps
        
        looky_currentGrp        = cell2mat(Grp_addresses(target_loop));
        label_currentGrp        = Grp_labels{target_loop};
        
        CompiledParameters.(fn{target_loop}).label = label_currentGrp;
        
        num_currentGrp          = length(looky_currentGrp);
        
        if num_currentGrp > 0
            for currentGrp_loop = 1:num_currentGrp
                
                % calculate ratios and clean up NaNs & infs ---------------
                biomass_2_FishBiomass_total = biomass(looky_currentGrp(currentGrp_loop)) / FishBiomass_total;
                if isnan(biomass_2_FishBiomass_total); biomass_2_FishBiomass_total = 0; end
                if isinf(biomass_2_FishBiomass_total); biomass_2_FishBiomass_total = 0; end

%                 landings_pooled_2_LandingsTotal = landings_pooled(looky_currentGrp(currentGrp_loop)) / landings_pooled_total;
%                 if isnan(landings_pooled_2_LandingsTotal); landings_pooled_2_LandingsTotal = 0; end
%                 if isinf(landings_pooled_2_LandingsTotal); landings_pooled_2_LandingsTotal = 0; end
                
                catch_pooled_2_CatchTotal = catch_pooled(looky_currentGrp(currentGrp_loop)) / catch_pooled_total;
                if isnan(catch_pooled_2_CatchTotal); catch_pooled_2_CatchTotal = 0; end
                if isinf(catch_pooled_2_CatchTotal); catch_pooled_2_CatchTotal = 0; end
                
                production_2_PrimaryProductionTotal = production_rate(looky_currentGrp(currentGrp_loop)) / PrimaryProduction_total;                
                if isnan(production_2_PrimaryProductionTotal); production_2_PrimaryProductionTotal = 0; end
                if isinf(production_2_PrimaryProductionTotal); production_2_PrimaryProductionTotal = 0; end
                
                production_2_production_PELAGICfish = production_rate(looky_currentGrp(currentGrp_loop)) / PelagicFishProduction_total;
                if isnan(production_2_production_PELAGICfish); production_2_production_PELAGICfish = 0; end
                if isinf(production_2_production_PELAGICfish); production_2_production_PELAGICfish = 0; end
                
                production_2_production_ALLfish = production_rate(looky_currentGrp(currentGrp_loop)) / FishProduction_total;
                if isnan(production_2_production_ALLfish); production_2_production_ALLfish = 0; end
                if isinf(production_2_production_ALLfish); production_2_production_ALLfish = 0; end
                % ---------------------------------------------------------
                
                % ---------------------------------------------------------
                PositionCounter.(cn{target_loop})                                       = PositionCounter.(cn{target_loop}) + 1;
                counter_currentGrp                                                      = PositionCounter.(cn{target_loop});

                CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 1}       	= ReadFile_name;
                CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 2}      	= EcoBase_ecotype(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 3}       	= EcoBase_OriginalGroupName(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 4}       	= EcoBase_GroupType(looky_currentGrp(currentGrp_loop));

                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 1)	= EcoBase_ModelNumber;
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 2)	= looky_currentGrp(currentGrp_loop)+3; % ECOTRAN address
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 3)	= TL(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 4)	= OmnivoryIndex(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 5)	= biomass(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 6)	= biomass_2_FishBiomass_total;
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 7)	= production_rate(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 8)	= pb(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 9)	= qb(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 10)	= pq(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 11)	= ae(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 12)	= landings_pooled(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 13)	= discards_pooled(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 14)	= catch_pooled(looky_currentGrp(currentGrp_loop));
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 15)	= catch_pooled_2_CatchTotal;
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 16)	= production_2_PrimaryProductionTotal;
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 17)	= production_2_production_PELAGICfish;
                CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 18)	= production_2_production_ALLfish;
            end % currentGrp_loop
            % *************************************************************
            
            
            % calculate group sums in the model ***************************
            % calculate ratios and clean up NaNs & infs ---------------
            SUM_biomass_2_FishBiomass_total = sum(biomass(looky_currentGrp)) / FishBiomass_total;
            if isnan(SUM_biomass_2_FishBiomass_total); SUM_biomass_2_FishBiomass_total = 0; end
            if isinf(SUM_biomass_2_FishBiomass_total); SUM_biomass_2_FishBiomass_total = 0; end

%             SUM_landings_pooled_2_LandingsTotal = sum(landings_pooled(looky_currentGrp)) / landings_pooled_total;
%             if isnan(SUM_landings_pooled_2_LandingsTotal); SUM_landings_pooled_2_LandingsTotal = 0; end
%             if isinf(SUM_landings_pooled_2_LandingsTotal); SUM_landings_pooled_2_LandingsTotal = 0; end

            SUM_catch_pooled_2_CatchTotal = sum(catch_pooled(looky_currentGrp)) / catch_pooled_total;
            if isnan(SUM_catch_pooled_2_CatchTotal); SUM_catch_pooled_2_CatchTotal = 0; end
            if isinf(SUM_catch_pooled_2_CatchTotal); SUM_catch_pooled_2_CatchTotal = 0; end
            
            SUM_production_2_PrimaryProductionTotal = sum(production_rate(looky_currentGrp)) / PrimaryProduction_total;                
            if isnan(SUM_production_2_PrimaryProductionTotal); SUM_production_2_PrimaryProductionTotal = 0; end
            if isinf(SUM_production_2_PrimaryProductionTotal); SUM_production_2_PrimaryProductionTotal = 0; end

            SUM_production_2_production_PELAGICfish = sum(production_rate(looky_currentGrp)) / PelagicFishProduction_total;
            if isnan(SUM_production_2_production_PELAGICfish); SUM_production_2_production_PELAGICfish = 0; end
            if isinf(SUM_production_2_production_PELAGICfish); SUM_production_2_production_PELAGICfish = 0; end

            SUM_production_2_production_ALLfish = sum(production_rate(looky_currentGrp)) / FishProduction_total;
            if isnan(SUM_production_2_production_ALLfish); SUM_production_2_production_ALLfish = 0; end
            if isinf(SUM_production_2_production_ALLfish); SUM_production_2_production_ALLfish = 0; end
            
            SUM_TL = sum(TL(looky_currentGrp) .* production_rate(looky_currentGrp)) / sum(production_rate(looky_currentGrp));
            if isnan(SUM_TL); SUM_TL = 0; end
            if isinf(SUM_TL); SUM_TL = 0; end
            
            SUM_OI = sum(OmnivoryIndex(looky_currentGrp) .* production_rate(looky_currentGrp)) / sum(production_rate(looky_currentGrp));
            if isnan(SUM_OI); SUM_OI = 0; end
            if isinf(SUM_OI); SUM_OI = 0; end
            
            SUM_pb = sum(pb(looky_currentGrp) .* production_rate(looky_currentGrp)) / sum(production_rate(looky_currentGrp));
            if isnan(SUM_pb); SUM_pb = 0; end
            if isinf(SUM_pb); SUM_pb = 0; end
            
            SUM_qb = sum(qb(looky_currentGrp) .* production_rate(looky_currentGrp)) / sum(production_rate(looky_currentGrp));
            if isnan(SUM_qb); SUM_qb = 0; end
            if isinf(SUM_qb); SUM_qb = 0; end
            
            SUM_pq = sum(pq(looky_currentGrp) .* production_rate(looky_currentGrp)) / sum(production_rate(looky_currentGrp));
            if isnan(SUM_pq); SUM_pq = 0; end
            if isinf(SUM_pq); SUM_pq = 0; end
            
            SUM_ae = sum(ae(looky_currentGrp) .* production_rate(looky_currentGrp)) / sum(production_rate(looky_currentGrp));
            if isnan(SUM_ae); SUM_ae = 0; end
            if isinf(SUM_ae); SUM_ae = 0; end
            % ---------------------------------------------------------
            
            % ---------------------------------------------------------
            PositionCounter.(cn{target_loop})                                           = PositionCounter.(cn{target_loop}) + 1;
            counter_currentGrp                                                          = PositionCounter.(cn{target_loop});

            CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 1}         	= ReadFile_name;
            CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 2}         	= ['TOTAL: ' label_currentGrp];

            CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 3}        	= EcoBase_OriginalGroupName(looky_currentGrp);
            CompiledParameters.(fn{target_loop}).text{counter_currentGrp, 4}        	= EcoBase_GroupType(looky_currentGrp);
            
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 1)      = EcoBase_ModelNumber;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 2)    	= 99999;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 3)    	= SUM_TL;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 4)    	= SUM_OI;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 5)    	= sum(biomass(looky_currentGrp));
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 6)   	= SUM_biomass_2_FishBiomass_total;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 7)    	= sum(production_rate(looky_currentGrp));
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 8)      = SUM_pb;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 9)      = SUM_qb;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 10)  	= SUM_pq;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 11)     = SUM_ae;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 12)     = sum(landings_pooled(looky_currentGrp));
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 13)     = sum(discards_pooled(looky_currentGrp));
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 14)     = sum(catch_pooled(looky_currentGrp));
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 15)    	= SUM_catch_pooled_2_CatchTotal;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 16)   	= SUM_production_2_PrimaryProductionTotal;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 17)   	= SUM_production_2_production_PELAGICfish;
            CompiledParameters.(fn{target_loop}).parameters(counter_currentGrp, 18)   	= SUM_production_2_production_ALLfish;
            % *************************************************************
            
        end % (if num_currentGrp > 0)
    end % target_loop
	% *********************************************************************

end % (model_loop)
% *************************************************************************




% STEP 5: SAVE RESULTS ****************************************************           
save(SaveFile, 'CompiledParameters')
% *************************************************************************


% end m-file***************************************************************