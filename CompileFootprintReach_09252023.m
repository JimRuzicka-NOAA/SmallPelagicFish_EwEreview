% CompileFootprintReach_09232023
% read models from Ecotran database
% calculate footprint & reach metrics
%
% calls:
%         f_ECOTRANbuild_08252023			
%             f_AggregateBiologicalModel_05132022		
%             ECOTRANheart_05132022		
%                 f_ECOfunction_05132022	
%                     f_RedistributeCannibalism_11202019
%                     f_calcEE_05122022
%                     f_calcPredationBudget_12102019
%         f_FootprintReach_09252023	
%             f_WebProductivity_03272019
%             f_DietTrace_08032020
%
% revision date: 9/23/2023
%   9/19/2023   re-coded gross footprint calculation to remove recycling feedback loops (necessary to prevent footprints > 100%)
%   9/24/2023   corrections for import diet
%   9/25/2023   patch to remove mackerel from aggregated ForageFish grouping


% *************************************************************************
% STEP 1: define model-set directories & save files------------------------
ReadFile_directory	= '/3_Matlab_versions/Atlantic_MATLAB_versions/';
SaveFile_name     	= ['Compiled_FootprintReach_Atlantic_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/Pacific_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_FootprintReach_Pacific_' num2str(date)];

% ReadFile_directory	= '/3_Matlab_versions/OtherRegions_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_FootprintReach_OtherRegions_' num2str(date)];

% ReadFile_directory      = '/3_Matlab_versions/LiteratureModels_MATLAB_versions/';
% SaveFile_name     	= ['Compiled_FootprintReach_LiteratureEntries_' num2str(date)];

SaveFile_directory      = '/5_Analyses/FootprintReach/';
SaveFile                = [SaveFile_directory SaveFile_name];
% *************************************************************************



% *************************************************************************
% STEP 2: initialize variables---------------------------------------------

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


% step 2b: initialize CompiledFootprintReach variable ---------------------
parameterLabel	= {'model_number',  ...
                   'FOOTPRINT_system', 'REACH_system', ...
                   'net_FOOTPRINT_phytoplankton', 'gross_FOOTPRINT_phytoplankton', ...
                   'REACH_ALLfish', 'REACH_birds', 'REACH_mammals', ...
                   'REACH_fleets', 'REACH_landedGrps', ...
                   'pooled_FOOTPRINT_system', 'pooled_REACH_system', ...
                   'pooled_net_FOOTPRINT_phytoplankton', 'pooled_gross_FOOTPRINT_phytoplankton', ...
                   'pooled_REACH_ALLfish', 'pooled_REACH_birds', 'pooled_REACH_mammals', ...
                   'pooled_REACH_fleets', 'pooled_REACH_landedGrps', ...
                   'max_FOOTPRINT_system', 'max_REACH_system', ...
                   'max_net_FOOTPRINT_phytoplankton', 'max_gross_FOOTPRINT_phytoplankton', ...
                   'max_REACH_ALLfish', 'max_REACH_birds', 'max_REACH_mammals', ...
                   'max_REACH_fleets', 'max_REACH_landedGrps'};

CompiledFootprintReach.TG1.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG1.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG1.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG1.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG2.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG2.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG2.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG2.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG3.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG3.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG3.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG3.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG4.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG4.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG4.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG4.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG5.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG5.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG5.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG5.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG6.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG6.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG6.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG6.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG7.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG7.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG7.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG7.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG8.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG8.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG8.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG8.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG9.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG9.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG9.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG9.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG10.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG10.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG10.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG10.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG11.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG11.text         	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG11.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG11.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG12.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG12.text         	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG12.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG12.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG13.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG13.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG13.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG13.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG14.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG14.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG14.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG14.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG15.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG15.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG15.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG15.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG16.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG16.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG16.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG16.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG17.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG17.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG17.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG17.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG18.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG18.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG18.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG18.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG19.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG19.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG19.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG19.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG20.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG20.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG20.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG20.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG21.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG21.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG21.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG21.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG22.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG22.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG22.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG22.parameterLabel	= parameterLabel; % define label

CompiledFootprintReach.TG23.label         	= cell(1);      % initialize cell
CompiledFootprintReach.TG23.text          	= cell(1, 11);   % initialize cell that will grow
CompiledFootprintReach.TG23.parameters    	= zeros(1, 28) * NaN; % initialize variable that will grow
CompiledFootprintReach.TG23.parameterLabel	= parameterLabel; % define label

fn                                          = fieldnames(CompiledFootprintReach);
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
    
	% step 3a: load model parameters (dat) & perform an ECOTRAN conversion 
	ReadFile_name           = FolderContents(model_loop).name;
	ReadFile                = [ReadFile_directory ReadFile_name];    
    
	disp(['Processing file: ' ReadFile_name])
    
	load(ReadFile, 'dat') % load ECOPATH (EwE) model so that group types from name translator are available
    
    dat.EcotranGroupType 	= dat.EcoBase_GroupType; % swap in new group type definitions for SPF work
    
    [ECOTRAN, ECOTRAN_MC, PhysicalLossFraction] = f_ECOTRANbuild_08252023(dat); % perform ECOTRAN conversion
    
    % trim down the MonteCarlo number
    ECOTRAN.num_MC      = 2;
	ECOTRAN_MC.num_MC	= 2;
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
    
    EnergyBudget_MC                             = ECOTRAN_MC.EnergyBudget_MC;       % (3D matrix: num_grps X num_grps X num_MC)
    TransferEfficiency_MC                       = ECOTRAN_MC.TransferEfficiency_MC; % (2D matrix: num_MC X num_grps)
    % ---------------------------------------------------------------------


    % step 3c: find group type addresses (ECOTRAN positions) --------------
    looky_NO3                       = find(EcoBase_GroupType == 1);
	looky_NH4                       = find(EcoBase_GroupType == 1.1 | EcoBase_GroupType == 1.2);
	looky_ANYnutrient            	= find(round(EcoBase_GroupType, 0) == 1);
    
	looky_ANYdetritus               = find(round(EcoBase_GroupType, 0) == 4);
    
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
    
    num_ALLfish         = length(looky_ALLfish);
	num_birds         	= length(looky_seabird);
	num_mammals      	= length(looky_mammal);
	num_fleets        	= length(looky_fleet);
    num_detritus        = length(looky_ANYdetritus);
    % ---------------------------------------------------------------------
    
    
    % find all fleet catch groups -----------------------------------------
    % filter out NaNs (an error on reading matlab file for NCC model)
    landings(isnan(landings))       = 0;
    
    landings_pooled                 = sum(landings, 2);
    landings_pooled                 = [zeros(length(looky_ANYnutrient), 1); landings_pooled; zeros(length(looky_fleet), 1)]; % append zeros for nutrients & fleets; (vertical vector: num_grps X 1)
    
    looky_landedGrps                = find(landings_pooled > 0);
    % ---------------------------------------------------------------------
    
    
    % ---------------------------------------------------------------------
    % correct EnergyBudget in ECOTRAN & ECOTRAN_MC
    %   renormalize clms to 1
    %   subtract CB_em terms accross appropriate rows (noe there will be less production supported from each driver (because import is no longer included as part of footprint)
    %   remove negative senescene from detritus and negative detritus terms in EB and renormalize detritus clms
    sum_EB                                  = sum(ECOTRAN.EnergyBudget, 1);
    sum_EB_repmat                           = repmat(sum_EB, [num_grps, 1]);
    corrected_EnergyBudget                  = ECOTRAN.EnergyBudget ./ sum_EB_repmat;
    corrected_EnergyBudget(isnan(corrected_EnergyBudget)) = 0; % correct div/0 error
        
    ConsumptionBudget_import                = ECOTRAN.ConsumptionBudget(7, :);
    ConsumptionBudget_endemic               = 1 + ConsumptionBudget_import;
    ConsumptionBudget_endemic_repmat        = repmat(ConsumptionBudget_endemic, [num_grps, 1]);
    
    corrected_EnergyBudget                  = corrected_EnergyBudget .* ConsumptionBudget_endemic_repmat;
    corrected_EnergyBudget(:, looky_fleet)	= ECOTRAN.EnergyBudget(:, looky_fleet);
    
    % correct for negative detritus senescence
    ConsumptionBudget_senescence_detritus           = ECOTRAN.ConsumptionBudget(5, looky_ANYdetritus);
    ConsumptionBudget_senescence_detritus(ConsumptionBudget_senescence_detritus < 0) = 0;
    ConsumptionBudget_senescence_detritus_repmat	= repmat(ConsumptionBudget_senescence_detritus, [num_detritus, 1]);
    fate_senescence_detritus                        = ECOTRAN.fate_senescence(:, looky_ANYdetritus);
    corrected_EnergyBudget(looky_ANYdetritus, looky_ANYdetritus) = ConsumptionBudget_senescence_detritus_repmat .* fate_senescence_detritus;
    
    sum_EnergyBudget_detritus               = sum(corrected_EnergyBudget(:, looky_ANYdetritus));
    sum_EnergyBudget_detritus_repmat        = repmat(sum_EnergyBudget_detritus, [num_grps, 1]);
    corrected_EnergyBudget_detritus         = corrected_EnergyBudget(:, looky_ANYdetritus) ./ sum_EnergyBudget_detritus_repmat;
    
    corrected_EnergyBudget(:, looky_ANYdetritus) = corrected_EnergyBudget_detritus;
    corrected_EnergyBudget(isnan(corrected_EnergyBudget)) = 0; % correct div/0 error
    
    ECOTRAN.EnergyBudget                    = corrected_EnergyBudget;
    ECOTRAN_MC.EnergyBudget_MC(:, :, 1)     = corrected_EnergyBudget;
    
    ECOTRAN.ConsumptionBudget(5, looky_ANYdetritus)             = ConsumptionBudget_senescence_detritus;
    ECOTRAN_MC.ConsumptionBudget_MC(5, looky_ANYdetritus, 1)	= ConsumptionBudget_senescence_detritus;
    % *********************************************************************
 
    

    % *********************************************************************
    % STEP 4: calculate FOOTPRINT & REACH metrics--------------------------
    % The FOOTPRINT metrics are the fraction of each PRODUCER group's production
    %       flowing to CONSUMER = TraceGroup. Code calculates FOOTPRINT for
    %       all functional groups as TraceGroup.
    %
    % The REACH metrics are the fraction of each CONSUMER group's production ultimately 
    %       originating from PRODUCER = TraceGroup. Code calculates REACH for
    %       all functional groups as TraceGroup.
    %
    % Calculate the FOOTPRINT and REACH traces for each trophic linkage for 
    %       one (1) specific functional group of interest = TraceGroup.
    % FOOTPRINT_trace is the fraction of each trophic link ultimately contributing
    %       to production of CONSUMER = TraceGroup
    %       It is the relative contribution of each linkage to the production of 
    %       CONSUMER = TraceGroup.
    % REACH_trace is the fraction of each trophic link ultimately originating
    %       from PRODUCER = TraceGroup.
    %       It is the fraction of energy within each linkge ultimately 
    %       originating from PRODUCER = TraceGroup.
    %
    
    % step 4a: loop through each TargetGrp --------------------------------
    for TargetGrp_loop = 1:num_TargetGrps
        
        looky_currentTargetGrp                              = looky_TargetGrp_list{TargetGrp_loop}; % addresses of all grps in currentTargetGrp
        num_currentTargetGrp                                = length(looky_currentTargetGrp);
        label_currentTargetGrp                              = TargetGrp_labels{TargetGrp_loop};
        CompiledFootprintReach.(fn{TargetGrp_loop}).label	= label_currentTargetGrp;
    
        if num_currentTargetGrp > 0
        
            % initialize pooled metrics for currentTargetGrp
            pooled_WEIGHTED_FOOTPRINT_system                    = NaN;
            pooled_WEIGHTED_REACH_system                        = NaN;
            pooled_WEIGHTED_net_FOOTPRINT_phytoplankton         = NaN;
            pooled_WEIGHTED_gross_FOOTPRINT_phytoplankton       = NaN;
            pooled_WEIGHTED_REACH_ALLfish                       = NaN;
            pooled_WEIGHTED_REACH_birds                         = NaN;
            pooled_WEIGHTED_REACH_mammals                       = NaN;
            pooled_WEIGHTED_REACH_fleets                        = NaN;
            pooled_WEIGHTED_REACH_landedGrps                    = NaN;
            
            MeanWeighted_FOOTPRINT_system                       = NaN;
            MeanWeighted_REACH_system                           = NaN;
            MeanWeighted_net_FOOTPRINT_phytoplankton        	= NaN;
            MeanWeighted_gross_FOOTPRINT_phytoplankton       	= NaN;
            MeanWeighted_REACH_ALLfish                          = NaN;
            MeanWeighted_REACH_birds                            = NaN;
            MeanWeighted_REACH_mammals                          = NaN;
            MeanWeighted_REACH_fleets                           = NaN;
            MeanWeighted_REACH_landedGrps                       = NaN;
            
            pooled_FOOTPRINT_system                             = NaN;
            pooled_REACH_system                                 = NaN;
            pooled_net_FOOTPRINT_phytoplankton                  = NaN;
            pooled_gross_FOOTPRINT_phytoplankton                = NaN;
            pooled_REACH_ALLfish                                = NaN;
            pooled_REACH_birds                                  = NaN;
            pooled_REACH_mammals                                = NaN;
            pooled_REACH_fleets                                 = NaN;
            pooled_REACH_landedGrps                             = NaN;
            
            max_FOOTPRINT_system                                = NaN;
            max_REACH_system                                    = NaN;
            max_net_FOOTPRINT_phytoplankton                     = NaN;
            max_gross_FOOTPRINT_phytoplankton                   = NaN;
            max_REACH_ALLfish                                   = NaN;
            max_REACH_birds                                     = NaN;
            max_REACH_mammals                                   = NaN;
            max_REACH_fleets                                    = NaN;
            max_REACH_landedGrps                                = NaN;
            % -------------------------------------------------------------
            
            % step 4b: loop through each group within the currentTargetGrp ----
            for grp_loop = 1:num_currentTargetGrp

                looky_currentGrp        = looky_currentTargetGrp(grp_loop);
                current_EcobaseName     = EcoBase_OriginalGroupName{looky_currentGrp};

                % step 4c: define TraceGroup & calculate metrics --------------
                [DIET_MC, net_FOOTPRINT_array_MC, gross_FOOTPRINT_array_MC, REACH_array_MC, FOOTPRINT_trace_MC, REACH_trace_MC, FOOTPRINT_system_MC, REACH_system_MC] = ...
                    f_FootprintReach_09252023(ECOTRAN, ECOTRAN_MC, PhysicalLossFraction, looky_currentGrp);


                REACH_array_MC(looky_currentGrp, looky_currentGrp, :)	= 0; % set REACH to self to 0
                % -------------------------------------------------------------


                % step 4d: calculate reach to fish, seabirds, mammals, & fleets
                %          NOTE: only use the "type" MC model
                reach_2_ALLfish         = REACH_array_MC(looky_currentGrp, looky_ALLfish, 1);       % (horizontal vector: 1 X num_ALLfish)
                reach_2_birds           = REACH_array_MC(looky_currentGrp, looky_seabird, 1);       % (horizontal vector: 1 X num_birds)
                reach_2_mammals         = REACH_array_MC(looky_currentGrp, looky_mammal, 1);        % (horizontal vector: 1 X num_mammals)
                reach_2_fleets       	= REACH_array_MC(looky_currentGrp, looky_fleet, 1);         % (horizontal vector: 1 X num_fleets)
                reach_2_landedGrps      = REACH_array_MC(looky_currentGrp, looky_landedGrps, 1);	% (horizontal vector: 1 X num_landedGrps)
                % ---------------------------------------------------------


                % step 4e: calculate productivity for all groups ----------
                InputProductionVector                               = zeros(1, num_grps); % re-initialize for each loop iteration; (horizontal vector: 1 X num_grps)
                InputProductionVector(looky_NO3)                    = 100; % drive model with 100 unit of NO3; (horizontal vector: 1 X num_grps)

                Production_base                                     = zeros(num_grps, 1); % initialize; (vertical vector: num_grps X 1) % only run on the "type" model and ignore all the MC models
                current_EnergyBudget                                = EnergyBudget_MC(:, :, 1); % ignore MC models; (2D matrix: num_grps X num_grps)
                current_EnergyBudget(isnan(current_EnergyBudget))   = 0; % QQQ temporary patch for terminal benthic detritus rows that may = NaN in MC models
                current_EnergyBudget(:, looky_NH4)                  = 0; % deactivate uptake of NH4
                current_TransferEfficiency                          = TransferEfficiency_MC(1, :);
                Production_base                                     = f_WebProductivity_03272019(current_TransferEfficiency, current_EnergyBudget, InputProductionVector, PhysicalLossFraction); % production (actually CONSUMPTION) rates as "initial" or "mean" conditions; (mmole N/m3/d); (vertical vector: num_grps X 1)

                production_footprint                                = Production_base'; % use for weighting footprint values to sum across drivers (e.g., sum phytoplankton groups to get total primary production required); (horizontal vector: 1 X num_grps)

                production_footprint_phytoplankton                  = sum(production_footprint(:, looky_PrimaryProducer), 2);	% (scaler)
                production_footprint_zooplankton                    = sum(production_footprint(:, looky_ALLzooplankton), 2);	% (scaler)

                Production_base(looky_currentGrp)                   = 0; % set current_Grp to 0; (vertical vector: num_grps X 1)
                % ---------------------------------------------------------


                % step 4f: pool dependent REACH groups --------------------
                %          groups to which currentTargetGrp gives REACH production
                total_reach_2_ALLfish                	= reach_2_ALLfish' .* Production_base(looky_ALLfish); % (mmoles N/m3/d); (vertical vector: num_ALLfish X 1)
                total_reach_2_ALLfish                 	= sum(total_reach_2_ALLfish); % (mmoles N/m3/d); (scaler)
                total_production_ALLfish            	= sum(Production_base(looky_ALLfish)); % (mmoles N/m3/d); (scaler)
                reach_2_ALLfish                       	= total_reach_2_ALLfish ./ total_production_ALLfish; % (scaler)
                reach_2_ALLfish(isnan(reach_2_ALLfish))	= 0; % correct for div/0 error; the footprint UPON and reach TO an undefined model group is 0

                total_reach_2_birds                     = reach_2_birds' .* Production_base(looky_seabird); % (mmoles N/m3/d); (vertical vector: num_birds X 1)
                total_reach_2_birds                     = sum(total_reach_2_birds); % (scaler)
                total_production_birds                  = sum(Production_base(looky_seabird)); % (scaler)
                reach_2_birds                           = total_reach_2_birds ./ total_production_birds; % (horizontal vector: 1 X num_MC)
                reach_2_birds(isnan(reach_2_birds))     = 0; % correct for div/0 error; the footprint UPON and reach TO an undefined model group is 0

                total_reach_2_mammals                   = reach_2_mammals' .* Production_base(looky_mammal); % (mmoles N/m3/d); (vertical vector: num_mammals X 1)
                total_reach_2_mammals                   = sum(total_reach_2_mammals); % (mmoles N/m3/d); (scaler)
                total_production_mammals                = sum(Production_base(looky_mammal)); % (mmoles N/m3/d); (scaler)
                reach_2_mammals                         = total_reach_2_mammals ./ total_production_mammals; % (scaler)
                reach_2_mammals(isnan(reach_2_mammals))	= 0; % correct for div/0 error; the footprint UPON and reach TO an undefined model group is 0

                total_reach_2_fleets                    = reach_2_fleets' .* Production_base(looky_fleet); % (mmoles N/m3/d); (vertical vector: num_fleets X 1)
                total_reach_2_fleets                    = sum(total_reach_2_fleets); % (mmoles N/m3/d); (scaler)
                total_production_fleets                 = sum(Production_base(looky_fleet)); % (mmoles N/m3/d); (scaler)
                reach_2_fleets                          = total_reach_2_fleets ./ total_production_fleets; % (scaler)
                reach_2_fleets(isnan(reach_2_fleets))	= 0; % correct for div/0 error; the footprint UPON and reach TO an undefined model group is 0
                
                total_reach_2_landedGrps                        = reach_2_landedGrps' .* Production_base(looky_landedGrps); % (mmoles N/m3/d); (vertical vector: num_fleets X 1)
                total_reach_2_landedGrps                        = sum(total_reach_2_landedGrps); % (mmoles N/m3/d); (scaler)
                total_production_landedGrps                     = sum(Production_base(looky_landedGrps)); % (mmoles N/m3/d); (scaler)
                reach_2_landedGrps                              = total_reach_2_landedGrps ./ total_production_landedGrps; % (scaler)
                reach_2_landedGrps(isnan(reach_2_landedGrps))	= 0; % correct for div/0 error; the footprint UPON and reach TO an undefined model group is 0
                % -------------------------------------------------------------


                % step 4g: pool dependent FOOTPRINT groups --------------------
                %          groups upon which currentTargetGrp places FOOTPRINT
                %       FOOTPRINT_array_MC	- "FOOTPRINT" of each TraceGroup = consumer (rows) upon each producer (columns)
                %                        	- the fraction of each producer group's production flowing to each consumer = TraceGroup
                %                         	- (3D matrix: num_grps (consumer) X num_grps (producer) X num_MC)
                %                         	- NOTE: use for web plotting footprint box colors relative to TraceGroup
                %                         	- NOTE: does NOT include import diet.
                %                                   There is no footprint calculated for producer = import
                %                                   because the value of import production can be arbitrary.

                net_FOOTPRINT_array             = net_FOOTPRINT_array_MC(:, :, 1);      % ignore MC models; (2D matrix: num_grps (consumers) X num_grps (producers))
                gross_FOOTPRINT_array           = gross_FOOTPRINT_array_MC(:, :, 1);    % ignore MC models; (2D matrix: num_grps (consumers) X num_grps (producers))

                % Footprints on phytoplankton & zooplankton
                % weight footprints by producer group production rates to sum across primary producer and zooplankton producer groups 
                target_net_FOOTPRINT                = net_FOOTPRINT_array(looky_currentGrp, :);     % (horizontal vector: 1 (currentGrp) X num_grps)
                target_net_FOOTPRINT_production     = target_net_FOOTPRINT .* production_footprint;	% (horizontal vector: 1 (currentGrp) X num_grps); NOTE: I din't set footprint upon or production of currentGrp to 0, but it doesn't matter because we're only looking at footprints on primary producers & zooplankton here

                net_FOOTPRINT_phytoplankton_sum     = sum(target_net_FOOTPRINT_production(1, looky_PrimaryProducer), 2);        % (scaler)

                net_FOOTPRINT_phytoplankton         = net_FOOTPRINT_phytoplankton_sum ./ production_footprint_phytoplankton;	% (scaler)

                net_FOOTPRINT_phytoplankton(isnan(net_FOOTPRINT_phytoplankton))	= 0; % correct div/0 error; (scaler)

                target_gross_FOOTPRINT           	= gross_FOOTPRINT_array(looky_currentGrp, :);       % (horizontal vector: 1 (currentGrp) X num_grps)
                target_gross_FOOTPRINT_production	= target_gross_FOOTPRINT .* production_footprint;	% (horizontal vector: 1 (currentGrp) X num_grps)

                gross_FOOTPRINT_phytoplankton_sum	= sum(target_gross_FOOTPRINT_production(1, looky_PrimaryProducer), 2);	% (scaler)

                gross_FOOTPRINT_phytoplankton       = gross_FOOTPRINT_phytoplankton_sum ./ production_footprint_phytoplankton;	% (scaler)

                gross_FOOTPRINT_phytoplankton(isnan(gross_FOOTPRINT_phytoplankton))	= 0; % correct div/0 error
                % -------------------------------------------------------------


                % STEP 4h: pack-up results ------------------------------------
                %          take averages & standard deviations of Monte Carlo models
                %          NOTE: just use the "type" model and ignore the MC models

                % diet of each consumer
                DIET_recalculated               = DIET_MC(:, :, 1);              % ignore MC models; (2D matrix: num_grps+1 (producers; +import) X num_grps+1 (consumers; +import))

                %       REACH_array_MC      - "REACH" of TraceGroup = producer (rows) to each consumer (columns)
                %                           - the fraction of each consumer group's production ultimately originating from producer = TraceGroup                 
                %                           - (3D matrix: num_grps (producers + 1 import) X num_grps (consumers + 1 import) X num_MC)
                %                           - NOTE: use to plot REACH box colors in food web diagram
                %                           - NOTE: formerly called "TraceFraction_upward"
                %                           - NOTE: DOES include import diet
                REACH_array                 = REACH_array_MC(:, :, 1);	 % ignore MC models; (2D matrix: num_grps+1 (producers; +import) X num_grps+1 (consumers; +import))


                %       FOOTPRINT_trace_MC	- Fraction of each trophic link ultimately contributing to production of CONSUMER = TraceGroup
                %                           - the relative contribution of each linkage to production of CONSUMER = TraceGroup
                %                           - (3D matrix: num_grps (producers + 1 import) X num_grps (consumers + 1 import) X num_MC)
                %                           - NOTE: use to plot FOOTPRINT arrow colors in food web diagram
                %                           - NOTE: formerly called "DietTrace_downward"
                %                           - NOTE: DOES include import diet
                FOOTPRINT_trace             = FOOTPRINT_trace_MC(:, :, 1);	 % ignore MC models; (2D matrix: num_grps+1 (producers; +import) X num_grps+1 (consumers; +import))


                %       REACH_trace_MC      - Fraction of each trophic link ultimately originating from PRODUCER = TraceGroup
                %                           - It is the fraction of energy within each linkge ultimately originating from PRODUCER = TraceGroup.
                %                           - (3D matrix: num_grps (producers + 1 import) X num_grps (consumers + 1 import) X num_MC)
                %                           - NOTE: use to plot REACH arrow colors in food web diagram
                %                           - NOTE: formerly called "DietTrace_upward"
                %                           - NOTE: DOES include import diet
                REACH_trace                 = REACH_trace_MC(:, :, 1);	     % ignore MC models; (2D matrix: num_grps+1 (producers; +import) X num_grps+1 (consumers; +import))


                %       FOOTPRINT_system_MC	- SYSTEM-LEVEL footprint = ratio of total TraceGroup footprint on all PRODUCERS over total production of all CONSUMER groups
                %                           - total consumer production of ecosystem excludes microzooplankton
                %                           - (vertical vector: num_MC X 1)
                FOOTPRINT_system            = FOOTPRINT_system_MC(1);     % ignore MC models; (scaler)


                %       REACH_system_MC     - SYSTEM-LEVEL reach = ratio of total TraceGroup production going to all consumers over total production of all CONSUMER groups
                %                           - total consumer production of ecosystem excludes microzooplankton
                %                           - (vertical vector: num_MC X 1)
                REACH_system                = REACH_system_MC(1);	% ignore MC models; (scaler)


                % contribution of currentGrp to all fish production
                REACH_ALLfish              	= reach_2_ALLfish;      % ignore MC models; (scaler)

                % contribution of currentGrp to all bird production
                REACH_birds                 = reach_2_birds;        % ignore MC models; (scaler)

                % contribution of currentGrp to all mammal production
                REACH_mammals               = reach_2_mammals;      % ignore MC models; (scaler)

                % contribution of currentGrp to all fleet production
                REACH_fleets                = reach_2_fleets;       % ignore MC models; (scaler)
                
                % contribution of currentGrp to all landed groups
                REACH_landedGrps         	= reach_2_landedGrps;	% ignore MC models; (scaler)                
                % ---------------------------------------------------------
                

                % pack results --------------------------------------------
                PositionCounter.(cn{TargetGrp_loop})                                            = PositionCounter.(cn{TargetGrp_loop}) + 1;
                counter_currentGrp                                                              = PositionCounter.(cn{TargetGrp_loop});

                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 1}         	= ReadFile_name;
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 2}             = EcoBase_OriginalGroupName(looky_currentGrp);
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 3}             = {looky_currentGrp};	% address of target group (ECOTRAN format, so first 3 are nutrients)
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 4}             = EcoBase_GroupType(looky_currentGrp);
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 5}         	= EcoBase_ecotype(looky_currentGrp);
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 6}             = EcoBase_SPFtype_aggregated(looky_currentGrp);
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 7}             = EcoBase_SPFtype_resolved(looky_currentGrp);
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 8}             = EcoBase_OriginalGroupName;
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 9}             = {net_FOOTPRINT_array}; % net_FOOTPRINT_array
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 10}          	= {gross_FOOTPRINT_array}; % gross_FOOTPRINT_array
                CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 11}          	= {REACH_array}; % REACH_array
                
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 1)       = EcoBase_ModelNumber;    % number of current model
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 2)       = FOOTPRINT_system;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 3)       = REACH_system;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 4)       = net_FOOTPRINT_phytoplankton;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 5)       = gross_FOOTPRINT_phytoplankton;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 6)       = REACH_ALLfish;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 7)       = REACH_birds;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 8)       = REACH_mammals;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 9)       = REACH_fleets;
                CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 10)      = REACH_landedGrps;
                % -----------------------------------------------------


                % build-up production-weighted means for aggregated group types
                WEIGHTED_FOOTPRINT_system                       = FOOTPRINT_system              * production_footprint(looky_currentGrp);
                WEIGHTED_REACH_system                           = REACH_system                  * production_footprint(looky_currentGrp);
                WEIGHTED_net_FOOTPRINT_phytoplankton            = net_FOOTPRINT_phytoplankton	* production_footprint(looky_currentGrp);
                WEIGHTED_gross_FOOTPRINT_phytoplankton          = gross_FOOTPRINT_phytoplankton	* production_footprint(looky_currentGrp);
                WEIGHTED_REACH_ALLfish                          = REACH_ALLfish                 * production_footprint(looky_currentGrp);
                WEIGHTED_REACH_birds                            = REACH_birds                   * production_footprint(looky_currentGrp);
                WEIGHTED_REACH_mammals                      	= REACH_mammals                 * production_footprint(looky_currentGrp);
                WEIGHTED_REACH_fleets                           = REACH_fleets                  * production_footprint(looky_currentGrp);
                WEIGHTED_REACH_landedGrps                   	= REACH_landedGrps              * production_footprint(looky_currentGrp);
                
                pooled_WEIGHTED_FOOTPRINT_system                = sum([pooled_WEIGHTED_FOOTPRINT_system                 WEIGHTED_FOOTPRINT_system], 'omitnan');
                pooled_WEIGHTED_REACH_system                    = sum([pooled_WEIGHTED_REACH_system                     WEIGHTED_REACH_system], 'omitnan');
                pooled_WEIGHTED_net_FOOTPRINT_phytoplankton     = sum([pooled_WEIGHTED_net_FOOTPRINT_phytoplankton      WEIGHTED_net_FOOTPRINT_phytoplankton], 'omitnan');
                pooled_WEIGHTED_gross_FOOTPRINT_phytoplankton	= sum([pooled_WEIGHTED_gross_FOOTPRINT_phytoplankton	WEIGHTED_gross_FOOTPRINT_phytoplankton], 'omitnan');
                pooled_WEIGHTED_REACH_ALLfish                   = sum([pooled_WEIGHTED_REACH_ALLfish                    WEIGHTED_REACH_ALLfish], 'omitnan');
                pooled_WEIGHTED_REACH_birds                     = sum([pooled_WEIGHTED_REACH_birds                      WEIGHTED_REACH_birds], 'omitnan');
                pooled_WEIGHTED_REACH_mammals                 	= sum([pooled_WEIGHTED_REACH_mammals                    WEIGHTED_REACH_mammals], 'omitnan');
                pooled_WEIGHTED_REACH_fleets                 	= sum([pooled_WEIGHTED_REACH_fleets                     WEIGHTED_REACH_fleets], 'omitnan');
                pooled_WEIGHTED_REACH_landedGrps                = sum([pooled_WEIGHTED_REACH_landedGrps                 WEIGHTED_REACH_landedGrps], 'omitnan');
                
                
                % sum together footprint & reach metrics for all groups in the currentTargetGrp
                pooled_FOOTPRINT_system                 = sum([pooled_FOOTPRINT_system              FOOTPRINT_system], 'omitnan');
                pooled_REACH_system                     = sum([pooled_REACH_system                  REACH_system], 'omitnan');
                pooled_net_FOOTPRINT_phytoplankton      = sum([pooled_net_FOOTPRINT_phytoplankton   net_FOOTPRINT_phytoplankton], 'omitnan');
                pooled_gross_FOOTPRINT_phytoplankton	= sum([pooled_gross_FOOTPRINT_phytoplankton	gross_FOOTPRINT_phytoplankton], 'omitnan');
                pooled_REACH_ALLfish                    = sum([pooled_REACH_ALLfish                 REACH_ALLfish], 'omitnan');
                pooled_REACH_birds                      = sum([pooled_REACH_birds                   REACH_birds], 'omitnan');
                pooled_REACH_mammals                   	= sum([pooled_REACH_mammals                 REACH_mammals], 'omitnan');
                pooled_REACH_fleets                     = sum([pooled_REACH_fleets                  REACH_fleets], 'omitnan');
                pooled_REACH_landedGrps              	= sum([pooled_REACH_landedGrps            	REACH_landedGrps], 'omitnan');
                
                
                % take the max footprint & reach metrics for all groups in the currentTargetGrp
                max_FOOTPRINT_system                    = max([max_FOOTPRINT_system                 FOOTPRINT_system], [], 'omitnan');
                max_REACH_system                        = max([max_REACH_system                     REACH_system], [], 'omitnan');
                max_net_FOOTPRINT_phytoplankton         = max([max_net_FOOTPRINT_phytoplankton      net_FOOTPRINT_phytoplankton], [], 'omitnan');
                max_gross_FOOTPRINT_phytoplankton       = max([max_gross_FOOTPRINT_phytoplankton	gross_FOOTPRINT_phytoplankton], [], 'omitnan');
                max_REACH_ALLfish                       = max([max_REACH_ALLfish                    REACH_ALLfish], [], 'omitnan');
                max_REACH_birds                         = max([max_REACH_birds                      REACH_birds], [], 'omitnan');
                max_REACH_mammals                   	= max([max_REACH_mammals                    REACH_mammals], [], 'omitnan');
                max_REACH_fleets                        = max([max_REACH_fleets                     REACH_fleets], [], 'omitnan');
                max_REACH_landedGrps                    = max([max_REACH_landedGrps                 REACH_landedGrps], [], 'omitnan');
                % -----------------------------------------------------
                
            end % (grp_loop)
            % *************************************************************
            
            % *************************************************************
            % calculate weighted means of the current target group --------
            MeanWeighted_FOOTPRINT_system               = pooled_WEIGHTED_FOOTPRINT_system / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_FOOTPRINT_system); MeanWeighted_FOOTPRINT_system = 0; end
            if isinf(MeanWeighted_FOOTPRINT_system); MeanWeighted_FOOTPRINT_system = 0; end
            
            MeanWeighted_REACH_system                   = pooled_WEIGHTED_REACH_system / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_REACH_system); MeanWeighted_REACH_system = 0; end
            if isinf(MeanWeighted_REACH_system); MeanWeighted_REACH_system = 0; end
            
            MeanWeighted_net_FOOTPRINT_phytoplankton     = pooled_WEIGHTED_net_FOOTPRINT_phytoplankton / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_net_FOOTPRINT_phytoplankton); MeanWeighted_net_FOOTPRINT_phytoplankton = 0; end
            if isinf(MeanWeighted_net_FOOTPRINT_phytoplankton); MeanWeighted_net_FOOTPRINT_phytoplankton = 0; end
            
            MeanWeighted_gross_FOOTPRINT_phytoplankton	= pooled_WEIGHTED_gross_FOOTPRINT_phytoplankton / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_gross_FOOTPRINT_phytoplankton); MeanWeighted_gross_FOOTPRINT_phytoplankton = 0; end
            if isinf(MeanWeighted_gross_FOOTPRINT_phytoplankton); MeanWeighted_gross_FOOTPRINT_phytoplankton = 0; end
            
            MeanWeighted_REACH_ALLfish              	= pooled_WEIGHTED_REACH_ALLfish / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_REACH_ALLfish); MeanWeighted_REACH_ALLfish = 0; end
            if isinf(MeanWeighted_REACH_ALLfish); MeanWeighted_REACH_ALLfish = 0; end
            
            MeanWeighted_REACH_birds                    = pooled_WEIGHTED_REACH_birds / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_REACH_birds); MeanWeighted_REACH_birds = 0; end
            if isinf(MeanWeighted_REACH_birds); MeanWeighted_REACH_birds = 0; end
            
            MeanWeighted_REACH_mammals              	= pooled_WEIGHTED_REACH_mammals / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_REACH_mammals); MeanWeighted_REACH_mammals = 0; end
            if isinf(MeanWeighted_REACH_mammals); MeanWeighted_REACH_mammals = 0; end
            
            MeanWeighted_REACH_fleets                   = pooled_WEIGHTED_REACH_fleets / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_REACH_fleets); MeanWeighted_REACH_fleets = 0; end
            if isinf(MeanWeighted_REACH_fleets); MeanWeighted_REACH_fleets = 0; end
            
            MeanWeighted_REACH_landedGrps               = pooled_WEIGHTED_REACH_landedGrps / sum(production_footprint(looky_currentTargetGrp));
            if isnan(MeanWeighted_REACH_landedGrps); MeanWeighted_REACH_landedGrps = 0; end
            if isinf(MeanWeighted_REACH_landedGrps); MeanWeighted_REACH_landedGrps = 0; end
            % ---------------------------------------------------------
            
            % ---------------------------------------------------------
            PositionCounter.(cn{TargetGrp_loop})                            = PositionCounter.(cn{TargetGrp_loop}) + 1;
            counter_currentGrp                                           	= PositionCounter.(cn{TargetGrp_loop});

            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 1}         	= ReadFile_name;
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 2}             = ['TOTAL: ' label_currentTargetGrp];
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 3}             = 99999;	% address of target group (ECOTRAN format, so first 3 are nutrients)
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 4}             = EcoBase_GroupType(looky_currentTargetGrp);
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 5}         	= EcoBase_ecotype(looky_currentTargetGrp);
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 6}             = EcoBase_SPFtype_aggregated(looky_currentGrp);
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 7}             = EcoBase_SPFtype_resolved(looky_currentGrp);
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 8}             = EcoBase_OriginalGroupName;
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 9}             = {net_FOOTPRINT_array}; % net_FOOTPRINT_array
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 10}          	= {gross_FOOTPRINT_array}; % gross_FOOTPRINT_array
            CompiledFootprintReach.(fn{TargetGrp_loop}).text{counter_currentGrp, 11}          	= {REACH_array}; % REACH_array
            
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 1)       = EcoBase_ModelNumber;    % number of current model
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 2)       = MeanWeighted_FOOTPRINT_system;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 3)       = MeanWeighted_REACH_system;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 4)       = MeanWeighted_net_FOOTPRINT_phytoplankton;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 5)       = MeanWeighted_gross_FOOTPRINT_phytoplankton;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 6)       = MeanWeighted_REACH_ALLfish;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 7)       = MeanWeighted_REACH_birds;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 8)       = MeanWeighted_REACH_mammals;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 9)       = MeanWeighted_REACH_fleets;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 10)      = MeanWeighted_REACH_landedGrps;
            
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 11)      = pooled_FOOTPRINT_system;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 12)    	= pooled_REACH_system;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 13)    	= pooled_net_FOOTPRINT_phytoplankton;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 14)    	= pooled_gross_FOOTPRINT_phytoplankton;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 15)    	= pooled_REACH_ALLfish;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 16)    	= pooled_REACH_birds;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 17)     	= pooled_REACH_mammals;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 18)    	= pooled_REACH_fleets;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 19)      = pooled_REACH_landedGrps;
            
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 20)      = max_FOOTPRINT_system;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 21)    	= max_REACH_system;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 22)    	= max_net_FOOTPRINT_phytoplankton;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 23)    	= max_gross_FOOTPRINT_phytoplankton;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 24)    	= max_REACH_ALLfish;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 25)    	= max_REACH_birds;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 26)     	= max_REACH_mammals;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 27)    	= max_REACH_fleets;
            CompiledFootprintReach.(fn{TargetGrp_loop}).parameters(counter_currentGrp, 28)      = max_REACH_landedGrps;

        end % (if num_currentTargetGrp > 0)
    end % (TargetGrp_loop)
end % (model_loop)
% *************************************************************************




% *************************************************************************
% STEP 5: SAVE RESULTS ****************************************************           
save(SaveFile, 'CompiledFootprintReach');
% *************************************************************************


% end m-file***************************************************************