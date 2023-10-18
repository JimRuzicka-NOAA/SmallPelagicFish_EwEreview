% CompileScenarios_09262023
% read models from Ecotran database
% perform ECOTRAN conversion
% ID scenario modification consumers
% run scenario
% pool scenario results into aggregated response groups
% re-compile metrics and save as .mat file
%
% calls:
%           f_ECOTRANbuild_08252023			
%           	f_AggregateBiologicalModel_05132022		
%               ECOTRANheart_05132022		
%                   f_ECOfunction_05132022	
%                       f_RedistributeCannibalism_11202019
%                       f_calcEE_05122022
%                       f_calcPredationBudget_12102019
%               f_E2E_MonteCarlo_08042020.m
%               f_E2Epedigree_08042020.m
%           f_WebProductivity_03272019
%           f_ScenarioGenerator_10212020
%           f_CompileScenarioResults_03262021
%
% revision: 9/26/2023
%   9/26/2023   remove mackerel from ForageFish


% *************************************************************************
% STEP 1: define model-set directories & save files------------------------
ReadFile_directory      = '/3_Matlab_versions/Atlantic_MATLAB_versions/';
SaveFile_name           = ['Compiled_Scenarios_Atlantic_' num2str(date)];

% ReadFile_directory	  = '/3_Matlab_versions/Pacific_MATLAB_versions/';
% SaveFile_name           = ['Compiled_Scenarios_Pacific_' num2str(date)];

% ReadFile_directory      = '/3_Matlab_versions/OtherRegions_MATLAB_versions/';
% SaveFile_name           = ['Compiled_Scenarios_OtherRegions_' num2str(date)];

% ReadFile_directory      = '/3_Matlab_versions/LiteratureModels_MATLAB_versions/';
% SaveFile_name           = ['Compiled_Scenarios_LiteratureEntries_' num2str(date)];

SaveFile_directory      = '/5_Analyses/Scenarios/';
SaveFile                = [SaveFile_directory SaveFile_name];
% *************************************************************************



% *************************************************************************
% STEP 2: initialize variables---------------------------------------------

% step 2a: define ScaleFactor ---------------------------------------------
ScaleFactor                         = 0.8; % scenario consumer change from baseline
% -------------------------------------------------------------------------

% step 2a: define TargetGrp_labels ----------------------------------------
TargetGrp_labels	= {
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

num_TargetGrps      = length(TargetGrp_labels);
% -------------------------------------------------------------------------


% step 2b: initialize CompiledScenario variable ---------------------
parameterLabel	= {'model_number', 'response_cephalopod', 'response_ALLfish', ...
                   'response_DemersalFish', 'response_PELAGICfish_nonSPF', ...
                   'response_seabird', 'response_mammal', 'response_fleet', 'response_landedGrps'};

CompiledScenario.TG1.label         	= cell(1);      % initialize cell
CompiledScenario.TG1.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG1.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG1.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG2.label         	= cell(1);      % initialize cell
CompiledScenario.TG2.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG2.parameters    	= zeros(1, 9);  % initialize variable that will grow
CompiledScenario.TG2.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG3.label         	= cell(1);      % initialize cell
CompiledScenario.TG3.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG3.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG3.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG4.label         	= cell(1);      % initialize cell
CompiledScenario.TG4.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG4.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG4.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG5.label         	= cell(1);      % initialize cell
CompiledScenario.TG5.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG5.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG5.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG6.label         	= cell(1);      % initialize cell
CompiledScenario.TG6.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG6.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG6.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG7.label         	= cell(1);      % initialize cell
CompiledScenario.TG7.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG7.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG7.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG8.label         	= cell(1);      % initialize cell
CompiledScenario.TG8.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG8.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG8.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG9.label         	= cell(1);      % initialize cell
CompiledScenario.TG9.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG9.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG9.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG10.label         	= cell(1);      % initialize cell
CompiledScenario.TG10.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG10.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG10.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG11.label         	= cell(1);      % initialize cell
CompiledScenario.TG11.text         	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG11.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG11.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG12.label         	= cell(1);      % initialize cell
CompiledScenario.TG12.text         	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG12.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG12.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG13.label         	= cell(1);      % initialize cell
CompiledScenario.TG13.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG13.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG13.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG14.label         	= cell(1);      % initialize cell
CompiledScenario.TG14.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG14.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG14.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG15.label         	= cell(1);      % initialize cell
CompiledScenario.TG15.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG15.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG15.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG16.label         	= cell(1);      % initialize cell
CompiledScenario.TG16.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG16.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG16.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG17.label         	= cell(1);      % initialize cell
CompiledScenario.TG17.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG17.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG17.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG18.label         	= cell(1);      % initialize cell
CompiledScenario.TG18.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG18.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG18.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG19.label         	= cell(1);      % initialize cell
CompiledScenario.TG19.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG19.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG19.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG20.label         	= cell(1);      % initialize cell
CompiledScenario.TG20.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG20.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG20.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG21.label         	= cell(1);      % initialize cell
CompiledScenario.TG21.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG21.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG21.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG22.label         	= cell(1);      % initialize cell
CompiledScenario.TG22.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG22.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG22.parameterLabel	= parameterLabel; % define label

CompiledScenario.TG23.label         	= cell(1);      % initialize cell
CompiledScenario.TG23.text          	= cell(1, 8);   % initialize cell that will grow
CompiledScenario.TG23.parameters    	= zeros(1, 9); % initialize variable that will grow
CompiledScenario.TG23.parameterLabel	= parameterLabel; % define label

fn                                   	= fieldnames(CompiledScenario);
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
FolderContents      = dir([ReadFile_directory '*.mat']); % dir struct of all pertinent .mat files
num_models          = length(FolderContents); % count of .mat files
record_counter    	= 0; % initialize

for model_loop = 1:num_models

	% step 3a: load model parameters (dat) & perform an ECOTRAN conversion 
	ReadFile_name           = FolderContents(model_loop).name;
	ReadFile                = [ReadFile_directory ReadFile_name];    
    
	disp(['Processing file: ' ReadFile_name])
    
	load(ReadFile, 'dat') % load ECOPATH (EwE) model so that group types from name translator are available
    
    dat.EcotranGroupType 	= dat.EcoBase_GroupType; % swap in new group type definitions for SPF work
    
    [ECOTRAN, ECOTRAN_MC, PhysicalLossFraction] = f_ECOTRANbuild_08252023(dat); % perform ECOTRAN conversion
    
    ECOTRAN.num_MC          = 1; % ignore all Monte Carlo models
    % ---------------------------------------------------------------------

    
	% step 3b: un-pack variables in current model -------------------------
    EcoBase_ModelNumber                         = dat.EcoBase_ModelNumber;
    
    EcoBase_OriginalGroupName                   = dat.EcoBase_OriginalGroupName;
    EcoBase_GroupType                           = dat.EcoBase_GroupType;
    EcoBase_MajorClass                          = dat.EcoBase_MajorClass;
    EcoBase_SPFtype_resolved                    = dat.EcoBase_SPFtype_resolved;
    EcoBase_SPFtype_aggregated                  = dat.EcoBase_SPFtype_aggregated;
    EcoBase_ecotype                             = dat.EcoBase_ecotype;

    num_grps                                    = dat.num_EcotranGroups;
    
    landings                                    = dat.landings;
    
    EnergyBudget                                = ECOTRAN_MC.EnergyBudget_MC(:, :, 1);   	% (2D matrix: num_grps X num_grps); NOTE: ignore Monte Carlo models
    EnergyBudget(isnan(EnergyBudget))           = 0; % QQQ temp patch for ECOBASE models, I need to filter out NaN in dummy terminal detritus groups
    TransferEfficiency                          = ECOTRAN_MC.TransferEfficiency_MC(1, :);	% (horizontal vector: 1 X num_grps); NOTE: ignore Monte Carlo models
	ConsumptionBudget                           = ECOTRAN_MC.ConsumptionBudget_MC(:, :, 1); % (@D matrix: 7 X num_grps); NOTE: ignore Monte Carlo models
    fate_metabolism                             = ECOTRAN_MC.fate_metabolism(:, :, 1);    	% (2D matrix: num_nutrients X num_grps); NOTE: ignore Monte Carlo models
    fate_predation                              = ECOTRAN_MC.fate_predation(:, :, 1);      	% (2D matrix: num_livingANDfleets X num_grps); NOTE: ignore Monte Carlo models
    fate_eggs                                   = ECOTRAN_MC.fate_eggs(:, :, 1);            % fate of eggs (reproduction) in base model; (2D matrix: num_eggs X num_grps)
    fate_feces                                  = ECOTRAN_MC.fate_feces(:, :, 1);           % fate of feces detritus in base model; (2D matrix: num_ANYdetritus X num_grps)
    fate_senescence                             = ECOTRAN_MC.fate_senescence(:, :, 1);      % fate of senescence detritus in base model; (3D matrix: num_ANYdetritus X num_grps X num_MC)
    
    DiscardFraction                             = ECOTRAN.DiscardFraction;                  % (3D matrix: num_grps X num_fleets)
    % ---------------------------------------------------------------------
    
    
    % step 3c: find group type addresses (ECOTRAN positions) --------------
    looky_NO3                       = find(EcoBase_GroupType == 1);
	looky_NH4                       = find(EcoBase_GroupType == 1.1 | EcoBase_GroupType == 1.2);
	looky_ANYnutrient            	= find(round(EcoBase_GroupType, 0) == 1);

    looky_ANYdetritus             	= find(round(EcoBase_GroupType, 0) == 4);

    looky_PrimaryProducer           = find(round(EcoBase_GroupType, 0) == 2);
    
	looky_ALLconsumers           	= find(round(EcoBase_GroupType, 0) == 3);
    
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
                            
    looky_TargetGrp_list	= {
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
	% ---------------------------------------------------------------------


    % find all fleet catch groups -----------------------------------------
    % filter out NaNs (an error on reading matlab file for NCC model)
    landings(isnan(landings))       = 0;
    
    landings_pooled                 = sum(landings, 2);
    landings_pooled                 = [zeros(length(looky_ANYnutrient), 1); landings_pooled; zeros(length(looky_fleet), 1)]; % append zeros for nutrients & fleets; (vertical vector: num_grps X 1)
    
    looky_landedGrps                = find(landings_pooled > 0);
    % ---------------------------------------------------------------------    
    
    
    % prepare to run static scenarios -------------------------------------
    InputProductionVector                               = zeros(1, num_grps);   % initialize: (horizontal vector: 1 X num_grps)
    InputProductionVector(looky_NO3)                    = 100; % 100 units of NO3 to drive the model

    EnergyBudget(:, looky_NH4)                          = 0; % shut off recycling; % deactivate nutrient recycling; set nutrient columns in EnergyBudget to 0 so that recycled nutrients don't flow into any other group
    fate_metabolism(:, looky_NH4)                       = 0; % deactivate nutrient recycling; set nutrient columns in EnergyBudget to 0 so that recycled nutrients don't flow into any other group
    fate_predation(:,  looky_NH4)                       = 0; % deactivate nutrient recycling; set nutrient columns in EnergyBudget to 0 so that recycled nutrients don't flow into any other group
    % *********************************************************************
    
    
    
    % *********************************************************************
	% step 4a: loop through each TargetGrp --------------------------------
    for TargetGrp_loop = 1:num_TargetGrps
        
        looky_currentTargetGrp                              = looky_TargetGrp_list{TargetGrp_loop}; % addresses of all grps in currentTargetGrp
        num_currentTargetGrp                                = length(looky_currentTargetGrp);
        label_currentTargetGrp                              = TargetGrp_labels{TargetGrp_loop};
        CompiledScenario.(fn{TargetGrp_loop}).label         = label_currentTargetGrp;
    
        % calculate base productivity ---------------------------------
        Production_base	= f_WebProductivity_03272019(TransferEfficiency, EnergyBudget, InputProductionVector, PhysicalLossFraction); % production (actually CONSUMPTION) rates as "initial" or "mean" conditions; (mmole N/m3/d); (2D matrix: num_grps X num_MC)
        % -------------------------------------------------------------


        if num_currentTargetGrp > 0
        
            % SCENARIO--------------------------------------------------------
            % DIRECT DECREASE OF TARGET GROUP as a consumer by 20% ....................
            ScenarioConditions.modify_consumer         	= [looky_currentTargetGrp];    	% row number(s) of consumer group(s) to force-modify
            ScenarioConditions.ScaleFactor            	= ScaleFactor;                  % value > 1 means increase flow to modify_consumer (and reduced flow to offset_consumer); < 1 means decrease flow to modify_consumer; 
            %                                                                               NOTE: keep ScaleFactor >= 0 (negative value makes no sense)
            ScenarioConditions.offset_consumer       	= [1:num_grps];                 % row number(s) of consumer group(s) to modify as offset to force-modified grp(s)
            %                                                                               NOTE: change in modify_consumer grp(s); can be [] if offset is to be distributed among ALL consumer groups
            ScenarioConditions.offset_consumer([looky_ANYnutrient; looky_ANYdetritus]) = [];	% (assume no change to detritus or to nutrients; --YOU ARE FREE TO CHANGE THIS ASSUMPTION--!!!)
            ScenarioConditions.trgt_producer            = 1:num_grps;                   % column number(s) of producer group(s)
        %     ScenarioConditions.EnergyBudget_base        = EnergyBudget;                 % MonteCarlo set of EnergyBudget_base models; (3D matrix: num_grps X num_grps X num_MC); 
            % %                                                                             NOTE: no changes made directly to EnergyBudget_base, everything is done via the fates

            ScenarioConditions.ConsumptionBudget_base	= ConsumptionBudget;            % MonteCarlo set of ConsumptionBudget_base models; (3D matrix: 7 X num_grps X num_MC)

            ScenarioConditions.fate_metabolism_base     = fate_metabolism;              % fate of metabolism in base model; (3D matrix: num_nutrients X num_grps X num_MC); NOTE: using fate_metabolism with nutrient recycling deactivated
            ScenarioConditions.fate_eggs_base           = fate_eggs;         % fate of eggs (reproduction) in base model; (3D matrix: num_eggs X num_grps X num_MC)
            ScenarioConditions.fate_feces_base      	= fate_feces;        % fate of feces detritus in base model; (3D matrix: num_ANYdetritus X num_grps X num_MC)
            ScenarioConditions.fate_predation_base   	= fate_predation;               % fate of production among all predators in base model; (3D matrix: num_livingANDfleets X num_grps X num_MC); NOTE: using fate_predation with nutrient recycling deactivated
            ScenarioConditions.fate_senescence_base   	= fate_senescence;	% fate of senescence detritus in base model; (3D matrix: num_ANYdetritus X num_grps X num_MC)

            ScenarioConditions.DiscardFraction_base     = ECOTRAN.DiscardFraction;      % (3D matrix: num_grps X num_fleets)

            ScenarioConditions.TransferEfficiency    	= TransferEfficiency;           % (horizontal vectr: 1 X num_grps)
            ScenarioConditions.InputProductionVector   	= InputProductionVector;	% <<<---NOTE base input production driver rates; (horizontal vector: 1 X num_grps)
            ScenarioConditions.PhysicalLossFraction    	= PhysicalLossFraction;	% <<<---NOTE base advection rates; (horizontal vector: 1 X num_grps)

            StaticScenario_results                   	= f_ScenarioGenerator_10212020(ScenarioConditions, ECOTRAN);
            % ---------------------------------------------------------------------


            % compile scenario results----------------------------------------
            %           (scenario_FractionalChange = change relative to un-altered model)
            %           (scenario_RatioChange      = altered to un-altered model ratio)
            [FractionalChange, RatioChange, scenario_ResultsCompiled]     = f_CompileScenarioResults_03262021(Production_base, StaticScenario_results);
            % scenario_ResultsCompiled:
            %       clm 1: FractionalChange_mean	= (scenario production - base production) / (base production)
            %       clm 2: FractionalChange_std
            %       clm 3: RatioChange_mean         = (scenario production / base production
            %       clm 4: RatioChange_std
            %       clm 5: Production_scenario_mean 
            %       clm 6: Production_scenario_std 
            %       clm 7: Production_base_mean 
            %       clm 8: Production_base_std

            % pool results by response group --------------------------------------
            scenario_ResultsCompiled(looky_currentTargetGrp, :) = 0; % set modify_consumer results to 0 so the forced change doesnt get added in to the other pelagic fish

            result_cephalopod                   = sum(scenario_ResultsCompiled(looky_cephalopod, :), 1);
            result_ALLfish                      = sum(scenario_ResultsCompiled(looky_ALLfish, :), 1);
            result_DemersalFish                 = sum(scenario_ResultsCompiled(looky_DEMERSALfish, :), 1);
            result_PELAGICfish_nonSPF           = sum(scenario_ResultsCompiled(looky_PELAGICfish_nonSPF, :), 1); % excluding forced groups
            result_seabird                      = sum(scenario_ResultsCompiled(looky_seabird, :), 1);
            result_mammal                       = sum(scenario_ResultsCompiled(looky_mammal, :), 1);
            result_fleet                        = sum(scenario_ResultsCompiled(looky_fleet, :), 1);
            result_landedGrps                 	= sum(scenario_ResultsCompiled(looky_landedGrps, :), 1);


            result_CurrentModel = [   
                                    (result_cephalopod(5) - result_cephalopod(7))                   ./ result_cephalopod(7)
                                    (result_ALLfish(5) - result_ALLfish(7))                         ./ result_ALLfish(7)
                                    (result_DemersalFish(5) - result_DemersalFish(7))               ./ result_DemersalFish(7)
                                    (result_PELAGICfish_nonSPF(5) - result_PELAGICfish_nonSPF(7))	./ result_PELAGICfish_nonSPF(7)
                                    (result_seabird(5) - result_seabird(7))                         ./ result_seabird(7)
                                    (result_mammal(5) - result_mammal(7))                           ./ result_mammal(7)
                                    (result_fleet(5) - result_fleet(7))                             ./ result_fleet(7)
                                    (result_landedGrps(5) - result_landedGrps(7))                	./ result_landedGrps(7)
                                  ];
            % NOTE: do NOT fix div/0 errors, leave as NaNs so groups that don't exist in an individual model aren't counted as 0 in subsequent analyses

            % pack results ----------------------------------------------------
            PositionCounter.(cn{TargetGrp_loop})                                	= PositionCounter.(cn{TargetGrp_loop}) + 1;
            counter_currentGrp                                                    	= PositionCounter.(cn{TargetGrp_loop});

            CompiledScenario.(fn{TargetGrp_loop}).text{counter_currentGrp, 1}         	= ReadFile_name;
            CompiledScenario.(fn{TargetGrp_loop}).text{counter_currentGrp, 2}         	= EcoBase_OriginalGroupName(looky_currentTargetGrp);
            CompiledScenario.(fn{TargetGrp_loop}).text(counter_currentGrp, 3)           = {looky_currentTargetGrp};	% address of target group (ECOTRAN format, so first 3 are nutrients)
            CompiledScenario.(fn{TargetGrp_loop}).text{counter_currentGrp, 4}          	= EcoBase_GroupType(looky_currentTargetGrp);
            CompiledScenario.(fn{TargetGrp_loop}).text{counter_currentGrp, 5}         	= EcoBase_ecotype(looky_currentTargetGrp);
            CompiledScenario.(fn{TargetGrp_loop}).text{counter_currentGrp, 6}         	= EcoBase_SPFtype_aggregated(looky_currentTargetGrp);
            CompiledScenario.(fn{TargetGrp_loop}).text{counter_currentGrp, 7}          	= EcoBase_SPFtype_resolved(looky_currentTargetGrp);
            CompiledScenario.(fn{TargetGrp_loop}).text{counter_currentGrp, 8}         	= EcoBase_OriginalGroupName;

            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 1)    	= EcoBase_ModelNumber;     % number of current model
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 2)     = result_CurrentModel(1);
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 3)     = result_CurrentModel(2);
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 4)     = result_CurrentModel(3);
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 5)     = result_CurrentModel(4);
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 6)     = result_CurrentModel(5);
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 7)     = result_CurrentModel(6);
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 8)     = result_CurrentModel(7);
            CompiledScenario.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 9)  	= result_CurrentModel(8);

        end % (if num_currentTargetGrp > 0)
        
    end % (TargetGrp_loop)

end % (model_loop)
% *************************************************************************



% *************************************************************************
save(SaveFile, 'CompiledScenario');
% *************************************************************************


% end m-file***************************************************************