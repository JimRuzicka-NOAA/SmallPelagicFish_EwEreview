% CompileMortality_09262023
% read models from Ecotran database
% calculate predation & fishery mortality metrics
% read pre-compiled Ecobase parameter metrics
% re-compile metrics and save as .mat file
%
% calls:
%       f_ECOTRANbuild_08252023
%           f_AggregateBiologicalModel_05132022
%           ECOTRANheart_05132022
%               f_ECOfunction_05132022
%                   f_RedistributeCannibalism_11202019
%                   f_calcEE_05122022
%                   f_calcPredationBudget_12102019
%
% revision date: 9/26/2023
%   9/25/2023   patch to remove mackerel from aggregated ForageFish grouping



% *************************************************************************
% STEP 1: define model-set directories & save files------------------------

ReadFile_directory	= '/3_Matlab_versions/Atlantic_MATLAB_versions/';
SaveFile_name     	= ['Compiled_Mortality_Atlantic_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/Pacific_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_Mortality_Pacific_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/OtherRegions_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_Mortality_OtherRegions_' num2str(date)];

% ReadFile_directory      = '/3_Matlab_versions/LiteratureModels_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_Mortality_LiteratureEntries_' num2str(date)];

SaveFile_directory      = '/5_Analyses/MortalityRates/';
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


% step 2b: initialize CompiledMortality variable --------------------------
parameterLabel	= {'model_number', 'M2_total', 'F_total', 'M2_ALLzooplankton', 'M2_ALLfish', ...
    'M2_PELAGICfish', 'M2_DEMERSALfish', 'M2_seabird', 'M2_mammal', 'M2_cephalopod', 'M2_BenthicInvertebrate', ...
    'M2_OTHERconsumers', 'fraction_M2_OTHERconsumers'};

CompiledMortality.TG1.label             = cell(1);      % initialize cell that will grow
CompiledMortality.TG1.text              = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG1.parameters        = zeros(1, 13); % initialize variable that will grow
CompiledMortality.TG1.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG2.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG2.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG2.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG2.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG3.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG3.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG3.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG3.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG4.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG4.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG4.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG4.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG5.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG5.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG5.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG5.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG6.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG6.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG6.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG6.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG7.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG7.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG7.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG7.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG8.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG8.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG8.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG8.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG9.label      	= cell(1);      % initialize cell that will grow
CompiledMortality.TG9.text          = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG9.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG9.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG10.label     	= cell(1);      % initialize cell that will grow
CompiledMortality.TG10.text     	= cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG10.parameters	= zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG10.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG11.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG11.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG11.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG11.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG12.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG12.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG12.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG12.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG13.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG13.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG13.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG13.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG14.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG14.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG14.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG14.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG15.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG15.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG15.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG15.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG16.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG16.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG16.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG16.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG17.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG17.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG17.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG17.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG18.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG18.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG18.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG18.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG19.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG19.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG19.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG19.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG20.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG20.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG20.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG20.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG21.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG21.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG21.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG21.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG22.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG22.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG22.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG22.parameterLabel	= parameterLabel; % initialize variable that will grow

CompiledMortality.TG23.label            = cell(1);      % initialize cell that will grow
CompiledMortality.TG23.text             = cell(1, 2);   % initialize cell that will grow
CompiledMortality.TG23.parameters       = zeros(1, 13);	% initialize variable that will grow
CompiledMortality.TG23.parameterLabel	= parameterLabel; % initialize variable that will grow

fn                                      = fieldnames(CompiledMortality);
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

cn                      = fieldnames(PositionCounter);
% *************************************************************************





% *************************************************************************
% STEP 3: process each .mat model in ReadFile_directory--------------------
FolderContents          = dir([ReadFile_directory '*.mat']); % dir struct of all pertinent .mat files
num_models              = length(FolderContents); % count of .mat files

for model_loop = 1:num_models
    
	% step 3a: load model parameters (dat) & perform ECOTRAN conversion ---
	ReadFile_name           = FolderContents(model_loop).name;
	ReadFile                = [ReadFile_directory ReadFile_name];

	disp(['Processing file: ' ReadFile_name])
    
	load(ReadFile, 'dat') % load ECOPATH (EwE) model so that group types from name translator are available
    
    dat.EcotranGroupType 	= dat.EcoBase_GroupType; % swap in new group type definitions for SPF work
    
    [ECOTRAN, ECOTRAN_MC, PhysicalLossFraction] = f_ECOTRANbuild_08252023(dat); % perform ECOTRAN conversion
    % ---------------------------------------------------------------------

    
	% step 3b: un-pack variables in current model -------------------------
%     EcoBase_OriginalGroupName                   = dat.EcoBase_OriginalGroupName;
    EcoBase_GroupType                           = dat.EcoBase_GroupType;
    EcoBase_MajorClass                          = dat.EcoBase_MajorClass;
    EcoBase_SPFtype_resolved                    = dat.EcoBase_SPFtype_resolved;
    EcoBase_SPFtype_aggregated                  = dat.EcoBase_SPFtype_aggregated;
    EcoBase_ModelNumber                         = dat.EcoBase_ModelNumber;

    num_grps                                    = dat.num_EcotranGroups;
    
    consumption_total                           = ECOTRAN.consumption_total';	% (horizontal vector: 1 X num_grps); (NOTE transpose)
    EnergyBudget                                = ECOTRAN.EnergyBudget;         % (2D matrix: num_grps X num_grps)
    biomass                                     = ECOTRAN.biomass';             % (horizontal vector: 1 X num_grps); (NOTE transpose)
	ECOTRANlabel                                = ECOTRAN.label;
    % ---------------------------------------------------------------------

    
    % step 3c: find group type addresses (ECOTRAN positions) --------------
	looky_ALLconsumers           	= find(round(EcoBase_GroupType, 0) == 3);
    
	looky_PrimaryProducer       	= find(round(EcoBase_GroupType, 0) == 2);
    
    looky_micrograzers              = find(round(EcoBase_GroupType, 3) == 3.111);

	looky_zooplankton               = find(round(EcoBase_GroupType, 2) == 3.11); 
	looky_micronekton               = find(round(EcoBase_GroupType, 2) == 3.12);
	looky_ALLzooplankton        	= [looky_zooplankton; looky_micronekton]; % zooplankton + micronekton grouping

    looky_BenthicInvertebrate    	= find(round(EcoBase_GroupType, 2) == 3.21);
    
	looky_squid                     = find(round(EcoBase_GroupType, 2) == 3.13); 
	looky_octopus                   = find(round(EcoBase_GroupType, 2) == 3.23); 
	looky_cephalopod                = find(round(EcoBase_GroupType, 2) == 3.03); 
    looky_cephalopod                = sort([looky_cephalopod; looky_squid; looky_octopus]); % pool all cephalopds together since benthics & pelagics are often hard to distinguish in the models
    
	looky_ALLfish               	= find(strcmp(EcoBase_MajorClass, 'fish'));
    looky_PELAGICfish              	= find(round(EcoBase_GroupType, 2) == 3.14);
	looky_DEMERSALfish            	= find(round(EcoBase_GroupType, 2) == 3.24);
	looky_ForageFish            	= find(strcmp(EcoBase_SPFtype_aggregated, 'forage fish'));
    looky_MesopelagicFish         	= find(strcmp(EcoBase_SPFtype_aggregated, 'mesopelagic fish') | strcmp(EcoBase_SPFtype_aggregated, 'mesopealgic fish'));    
    looky_PELAGICfish_nonSPF      	= looky_PELAGICfish(~ismember(looky_PELAGICfish, [looky_ForageFish; looky_MesopelagicFish]));

 	looky_anchovy                   = find(strcmp(EcoBase_SPFtype_resolved, 'anchovy'));
    looky_BongaShad             	= find(strcmp(EcoBase_SPFtype_resolved, 'bonga shad'));    
    looky_FlyingFishEtc             = find(strcmp(EcoBase_SPFtype_resolved, 'flying fish & halfbeaks & saury'));
    looky_herring                	= find(strcmp(EcoBase_SPFtype_resolved, 'herring'));    
    looky_mackerelCarangidae     	= find(strcmp(EcoBase_SPFtype_resolved, 'mackerel - Carangidae'));    
    looky_mackerelScombridae        = find(strcmp(EcoBase_SPFtype_resolved, 'mackerel - Scombridae'));    
    looky_menhaden               	= find(strcmp(EcoBase_SPFtype_resolved, 'menhaden'));    
    looky_sardine                 	= find(strcmp(EcoBase_SPFtype_resolved, 'sardine'));    
    looky_shad                  	= find(strcmp(EcoBase_SPFtype_resolved, 'shad'));    
    looky_smelt                 	= find(strcmp(EcoBase_SPFtype_resolved, 'smelt'));    
    looky_sprat                  	= find(strcmp(EcoBase_SPFtype_resolved, 'sprat'));    

    % QQQ patch to remove mackerel from ForageFish but include in PELAGICfish_nonSPF --------
    looky_ForageFish            = looky_ForageFish(~ismember(looky_ForageFish, [looky_mackerelCarangidae; looky_mackerelScombridae]));
    looky_PELAGICfish_nonSPF	= looky_PELAGICfish(~ismember(looky_PELAGICfish, [looky_ForageFish; looky_MesopelagicFish]));
    % QQQ  ----------------------------------

	looky_seabird                	= find(strcmp(EcoBase_MajorClass, 'seabird'));
    looky_mammal                 	= find(strcmp(EcoBase_MajorClass, 'mammal'));
	looky_fleet                 	= find(round(EcoBase_GroupType, 0) == 5); 
    
    looky_OTHERconsumers            = looky_ALLconsumers;
    looky_classified              	= find(ismember(looky_ALLconsumers, [looky_ALLzooplankton; looky_ALLfish; looky_seabird; looky_mammal; looky_fleet; looky_cephalopod; looky_BenthicInvertebrate; looky_micrograzers]));
	looky_OTHERconsumers(looky_classified) = []; % unclassified consumer grouping (EXCLUDES micrograzers)
    % *********************************************************************
    
    
    
    
    
    % *********************************************************************
    % STEP 4: compile mortality for each prey group type ------------------
    
    % step 4a: compile mortality rates imposed BY different consumers -----
    consumption_total_repmat                = repmat(consumption_total, [num_grps, 1]); % replicate down rows; (t WWT/km2/y); (2D matrix: num_grps (consumers) X num_grps (producers))
    CONSUMPTION_matrix                      = EnergyBudget .* consumption_total_repmat;	% (t WWT/km2/y); (2D matrix: num_grps (consumers) X num_grps (producers))
    
	PredationPressure_total                 = sum(CONSUMPTION_matrix(looky_ALLconsumers, :), 1); % (t/km2/y); (horizontal vector: 1 X num_grps)
    PredationPressure_ALLzooplankton    	= sum(CONSUMPTION_matrix(looky_ALLzooplankton, :), 1);
    PredationPressure_ALLfish           	= sum(CONSUMPTION_matrix(looky_ALLfish, :), 1);
    PredationPressure_PELAGICfish        	= sum(CONSUMPTION_matrix(looky_PELAGICfish, :), 1);
    PredationPressure_DEMERSALfish      	= sum(CONSUMPTION_matrix(looky_DEMERSALfish, :), 1);
    PredationPressure_seabird               = sum(CONSUMPTION_matrix(looky_seabird, :), 1);
    PredationPressure_mammal             	= sum(CONSUMPTION_matrix(looky_mammal, :), 1);
    PredationPressure_cephalopod            = sum(CONSUMPTION_matrix(looky_cephalopod, :), 1);
    PredationPressure_BenthicInvertebrate	= sum(CONSUMPTION_matrix(looky_BenthicInvertebrate, :), 1);
    PredationPressure_OTHERconsumers     	= sum(CONSUMPTION_matrix(looky_OTHERconsumers, :), 1); % all other types of consumers, but excluding micrograzers
    PredationPressure_fleets              	= sum(CONSUMPTION_matrix(looky_fleet, :), 1);
    % ---------------------------------------------------------------------
    
    
	% step 4b: define prey group addresses & labels in current model ------
    Grp_addresses	= {
                        looky_PrimaryProducer
                        looky_ALLzooplankton
                        looky_BenthicInvertebrate
                        looky_cephalopod                % all pelagic & benthic
                        looky_ALLfish
                        looky_PELAGICfish_nonSPF
                        looky_DEMERSALfish
                        looky_ForageFish
                        looky_MesopelagicFish
                        looky_anchovy
                        looky_BongaShad
                        looky_FlyingFishEtc             % flying fish & halfbeaks & saury
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
    % ---------------------------------------------------------------------


    % step 4c: process each prey group ------------------------------------
    for target_loop = 1:num_targetGrps
        
        looky_currentGrp                            = cell2mat(Grp_addresses(target_loop)); % addresses of current prey groups
        label_currentGrp                            = Grp_labels{target_loop};              % label of current aggregated prey group
        current_ECOTRANlabels                       = ECOTRANlabel(looky_currentGrp);       % names of individual prey groups
        current_biomass                             = sum(biomass(looky_currentGrp));       % (scaler)
        
        CompiledMortality.(fn{target_loop}).label	= label_currentGrp;
        
        if current_biomass > 0
        
            % calculate mortality sources on current_TargetGrp ------------
            M2_total                                    = sum(PredationPressure_total(looky_currentGrp))                / current_biomass; % (1/y); (scaler)
            F_total                                     = sum(PredationPressure_fleets(looky_currentGrp))               / current_biomass; % (1/y); (scaler)
            M2_ALLzooplankton                           = sum(PredationPressure_ALLzooplankton(looky_currentGrp))       / current_biomass; % (1/y); (scaler)
            M2_ALLfish                                  = sum(PredationPressure_ALLfish(looky_currentGrp))              / current_biomass; % (1/y); (scaler)
            M2_PELAGICfish                              = sum(PredationPressure_PELAGICfish(looky_currentGrp))          / current_biomass; % (1/y); (scaler)
            M2_DEMERSALfish                             = sum(PredationPressure_DEMERSALfish(looky_currentGrp))         / current_biomass; % (1/y); (scaler)
            M2_seabird                                  = sum(PredationPressure_seabird(looky_currentGrp))              / current_biomass; % (1/y); (scaler)
            M2_mammal                                   = sum(PredationPressure_mammal(looky_currentGrp))               / current_biomass; % (1/y); (scaler)
            M2_cephalopod                               = sum(PredationPressure_cephalopod(looky_currentGrp))           / current_biomass; % (1/y); (scaler)
            M2_BenthicInvertebrate                      = sum(PredationPressure_BenthicInvertebrate(looky_currentGrp))	/ current_biomass; % (1/y); (scaler)
            M2_OTHERconsumers                           = sum(PredationPressure_OTHERconsumers(looky_currentGrp))       / current_biomass; % (1/y); (scaler)
            % -------------------------------------------------------------

            
            % pack results ------------------------------------------------
            fraction_M2_OTHERconsumers                                                  = M2_OTHERconsumers / (M2_total + F_total); % fraction M2+F by unclassified consumers            
            if isnan(fraction_M2_OTHERconsumers); fraction_M2_OTHERconsumers = 0; end % fix div/0 error
            if isinf(fraction_M2_OTHERconsumers); fraction_M2_OTHERconsumers = 0; end % fix div/0 error

            
            PositionCounter.(cn{target_loop})                                           = PositionCounter.(cn{target_loop}) + 1;
            counter_currentGrp                                                          = PositionCounter.(cn{target_loop});
        
            CompiledMortality.(fn{target_loop}).text{counter_currentGrp, 1}             = ReadFile_name;
            CompiledMortality.(fn{target_loop}).text{counter_currentGrp, 2}             = label_currentGrp;
        
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 1)       = EcoBase_ModelNumber;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 2)       = M2_total;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 3)       = F_total;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 4)    	= M2_ALLzooplankton;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 5)    	= M2_ALLfish;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 6)    	= M2_PELAGICfish;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 7)       = M2_DEMERSALfish;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 8)       = M2_seabird;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 9)       = M2_mammal;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 10)      = M2_cephalopod;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 11)      = M2_BenthicInvertebrate;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 12)      = M2_OTHERconsumers;
            CompiledMortality.(fn{target_loop}).parameters(counter_currentGrp, 13)      = fraction_M2_OTHERconsumers; % fraction M2+F by unclassified consumers
            % -------------------------------------------------------------

        end % (if current_biomass > 0)
    end % (target_loop)
end % (model_loop)
% *************************************************************************




% *************************************************************************
% STEP 5: SAVE RESULTS ****************************************************           
save(SaveFile, 'CompiledMortality');
% *************************************************************************


% end m-file***************************************************************