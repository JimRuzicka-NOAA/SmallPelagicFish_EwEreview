function [ECOTRAN, ECOTRAN_MC, PhysicalLossFraction] = f_ECOTRANbuild_08252023(dat)
% function [ECOTRAN, ECOTRAN_MC, PhysicalLossFraction] = f_ECOTRANbuild_08252023(readFile)
%
% build an ECOTRAN model. This returns the most basic of ECOTRAN
% conversions, with MonteCarlo stack
%
% calls:
%       f_AggregateBiologicalModel_05132022
%       ECOTRANheart_05132022		
%           f_ECOfunction_05132022	
%            	f_RedistributeCannibalism_11202019
%              	f_calcEE_05122022
%               	f_calcPredationBudget_12102019
%
% revision date: 8/25/2023
%   8/25/2023 takes dat instead of the readfile name to do the conversion
%   (needed in oreder to use SPF-redefined group types)


% *************************************************************************
% Set operating conditions-------------------------------------------------
switch_MonteCarlo	= 'MonteCarlo_build'; % generate (and save) a stack of Monte Carlo models
MonteCarlo_size     = 10; % set the size of the MonteCarlo stack of food web models
% *************************************************************************





% *************************************************************************
% STEP 1: load & aggregate EwE results-------------------------------------
fname_ECOTRANbuild     = mfilename; % save name of this m-file to keep in saved model results

% % step 1b: load ECOPATH (EwE) model
% load(readFile, 'dat')

% step 1c: aggregate model results & prep EwEResult for analysis ----------
[EwEResult, PEDIGREE] 	= f_AggregateBiologicalModel_05132022(dat);
% *************************************************************************





% *************************************************************************
% STEP 2: ECOTRAN conversion-----------------------------------------------
MonteCarloStore         = [];
[ECOTRAN]            	= ECOTRANheart_05132022(EwEResult, MonteCarloStore);
% *************************************************************************





% *************************************************************************
% STEP 3: Generate E2E Monte Carlo models based on ECOTRAN EnergyBudget----
%         Start with the one original ECOTRAN base model and generate a set of 
%           Monte Carlo models from the ECOTRAN EnergyBudget & ConsumptionBudget
%           matrices using predefined CV values

switch switch_MonteCarlo

	case 'MonteCarlo_build' % generate (and save) a stack of Monte Carlo models
    
        num_MC              = MonteCarlo_size;        % SSS set this value
        
        disp(['MonteCarlo: building stack of ' num2str(num_MC) ' food webs'])
        
        ECOTRAN.num_MC      = num_MC;

        PEDIGREE.ee_eggs_CV                               = 0.01; % SSS egg pedigree W.R.T. production budget for all groups; (CV); (scaler)
        PEDIGREE.BacterialMTBLSM_CV                       = 0.01; % SSS pedigree for implicit bacterial metabolism of terminal detritus (CV)
        PEDIGREE.Oxidation_NH4_CV                         = 0.01;	% fraction of NH4 produced oxidized directly back to NO3 abiologically; QQQ scaler?? (vertical vector: num_NH4 X 1)??
        PEDIGREE.NutrientUptake_CV                        = 0.01; % SSS pedigree for nutrient uptake by primary producers (CV)
        ECOTRAN_PEDIGREE                               	  = f_E2Epedigree_08042020(ECOTRAN, PEDIGREE); % NEW!!!

                % SSS use for standardized pedigree
                %     overwrite the pedigree values from the ECOPATH (EwE) model from VisualBasic file (.csv format)
                [rows, clms]                                = size(ECOTRAN_PEDIGREE.EnergyBudget_CV);
                ECOTRAN_PEDIGREE.EnergyBudget_CV            = 0.001 * ones(rows, clms); % changes how important predators are relative to eachother
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV       = zeros(7, clms);
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV(1, :) = 0.05; % feces
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV(2, :) = 0.05; % metabolism
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV(3, :) = 0.05; % eggs
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV(4, :) = 0.05;	% predation
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV(5, :) = 0.05;  % senescence
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV(6, :) = 0.05;  % ba
                ECOTRAN_PEDIGREE.ConsumptionBudget_CV(7, :) = 0.05;  % em
                ECOTRAN_PEDIGREE.DiscardFraction_CV         = 0.05 * ECOTRAN_PEDIGREE.DiscardFraction_CV; % QQQ reduce DiscardFraction_CV

        MonteCarloConditions.num_MC               	    = num_MC;	% number of random Monte Carlo models to generate
        MonteCarloConditions.DistributionType         	= 'normal';	% SSS distribution to draw random values from ('normal' or 'uniform'); (NOTE: code not fully proofed for uniform)

        ECOTRAN_MC                                      = f_E2E_MonteCarlo_08042020(MonteCarloConditions, ECOTRAN, ECOTRAN_PEDIGREE);
        EnergyBudget_MC                                 = ECOTRAN_MC.EnergyBudget_MC;
        ConsumptionBudget_MC                            = ECOTRAN_MC.ConsumptionBudget_MC;
        DiscardFraction_MC                              = ECOTRAN_MC.DiscardFraction_MC;
        ECOTRAN_MC.num_MC                               = num_MC;

%         % activate to save this stack of Monte Carlo food webs
%         filename_MC      = [SaveFile_directory 'MonteCarlo_NCC_stack_' date '.mat'];
%         disp(['MonteCarlo: SAVING stack: ' filename_MC])
%         save(filename_MC, 'ECOTRAN_MC')

    % end (case build_MonteCarlo) -----------------------------------------

    
    case 'MonteCarlo_load' % load a set of Monte Carlo models
        filename_MC = [SaveFile_directory 'MonteCarlo_NCC_stack_27-Jun-2022.mat']; % SSS be sure to give correct saved file name here
        disp(['MonteCarlo: LOADING stack: ' filename_MC])
        load(filename_MC, 'ECOTRAN_MC')
        
        num_MC                            	= ECOTRAN_MC.num_MC;
        EnergyBudget_MC                     = ECOTRAN_MC.EnergyBudget_MC;
        ConsumptionBudget_MC                = ECOTRAN_MC.ConsumptionBudget_MC;
        DiscardFraction_MC                  = ECOTRAN_MC.DiscardFraction_MC;
    % end (case load_MonteCarlo) ------------------------------------------
        
    
    case 'MonteCarlo_TypeModel'
        
        disp('MonteCarlo: using the defining TypeModel')
    
        num_MC                          = 1;       % only the "type" model is used
        EnergyBudget_MC                 = ECOTRAN.EnergyBudget;
        ConsumptionBudget_MC            = ECOTRAN.ConsumptionBudget;
        DiscardFraction_MC              = ECOTRAN.DiscardFraction;

        ECOTRAN_MC.num_MC               = num_MC;
        ECOTRAN_MC.EnergyBudget_MC      = ECOTRAN.EnergyBudget; % (3D matrix: num_grps (consumers) X num_grps (producers) X num_MC (1))
        ECOTRAN_MC.ConsumptionBudget_MC	= ECOTRAN.ConsumptionBudget; % (3D matrix: 7 X num_grps (producers) X num_MC (1))
        ECOTRAN_MC.DiscardFraction_MC	= ECOTRAN.DiscardFraction;
        
        ECOTRAN_MC.fate_metabolism      = ECOTRAN.fate_metabolism;	% (3D matrix: num_nutrients X num_grps (producers) X num_MC (1))
        ECOTRAN_MC.fate_eggs            = ECOTRAN.fate_eggs;        % (3D matrix: num_eggs X num_grps (producers) X num_MC (1))
        ECOTRAN_MC.fate_feces           = ECOTRAN.fate_feces;       % (3D matrix: num_ANYdetritus X num_grps (producers) X num_MC (1))
        ECOTRAN_MC.fate_senescence      = ECOTRAN.fate_senescence;  % (3D matrix: num_ANYdetritus X num_grps (producers) X num_MC (1))
        ECOTRAN_MC.fate_predation       = ECOTRAN.fate_predation;   % (3D matrix: num_livingANDfleets X num_grps (producers) X num_MC (1))
	% end (case MonteCarlo_TypeModel) -------------------------------------

end % (switch_MonteCarlo)
% *************************************************************************





% *************************************************************************
% STEP 4: prep and pack ECOTRAN model parameters---------------------------

% step 4a: read in ECOTRAN structure variables ----------------------------
%          (so that no changes are made to original values)
GroupType                           = ECOTRAN.GroupType;
label                            	= ECOTRAN.label;
% EnergyBudget_MC                 	  = ECOTRAN.EnergyBudget;
biomass                          	= ECOTRAN.biomass;              % (vertical vector: num_grps X 1); note inclusion of separately constructed regional models
pb                               	= ECOTRAN.pb;                   % (vertical vector: num_grps X 1)
qb                               	= ECOTRAN.qb;                   % (vertical vector: num_grps X 1)
fate_feces                       	= ECOTRAN.fate_feces;
fate_metabolism                  	= ECOTRAN.fate_metabolism;
fate_eggs                        	= ECOTRAN.fate_eggs;
fate_senescence                  	= ECOTRAN.fate_senescence;
ProductionLossScaler             	= ECOTRAN.ProductionLossScaler;	% (vertical vector: num_grps X 1)
RetentionScaler                 	= ECOTRAN.RetentionScaler;      % sensitivity to advection & mixing (0 = more advection <--> less advection =1); (vertical vector: num_grps X 1)
FunctionalResponseParams         	= ECOTRAN.FunctionalResponseParams;
num_grps                            = ECOTRAN.num_grps;             % number of model groups
% num_MC                              = ECOTRAN.num_MC;               % number of Monte Carlo models
% TransferEfficiency                  = ECOTRAN.TransferEfficiency;	  % gets redefined manually below
% -------------------------------------------------------------------------


% step 4b: find detritus, nutrients, ba & em ------------------------------
%           row addresses in EnergyBudget_MC
%           NOTE: ba = biomass accumulation term, em = emigration term

looky_NO3                       	= find(GroupType        == ECOTRAN.GroupTypeDef_NO3);
looky_plgcNH4                       = find(GroupType        == ECOTRAN.GroupTypeDef_plgcNH4);
looky_bnthNH4                       = find(GroupType        == ECOTRAN.GroupTypeDef_bnthNH4);
looky_NH4                           = find(GroupType        == ECOTRAN.GroupTypeDef_plgcNH4 | GroupType == ECOTRAN.GroupTypeDef_bnthNH4);
looky_nutrients                     = find(floor(GroupType)	== ECOTRAN.GroupTypeDef_ANYNitroNutr);	% row addresses of nutrients
looky_ANYPrimaryProducer        	= find(floor(GroupType) == ECOTRAN.GroupTypeDef_ANYPrimaryProd);
looky_macroalgae                  	= find(GroupType        == ECOTRAN.GroupTypeDef_Macrophytes);
looky_phytoplankton                 = looky_ANYPrimaryProducer(~ismember(looky_ANYPrimaryProducer, looky_macroalgae));
looky_ANYconsumer                 	= find(floor(GroupType) == ECOTRAN.GroupTypeDef_ANYConsumer);
% looky_PLGCbacteria                  = find(GroupType        == ECOTRAN.GroupTypeDef_plgcBacteria);
% looky_BNTHbacteria                  = find(GroupType        == ECOTRAN.GroupTypeDef_bnthBacteria);
% looky_ANYbacteria                   = find(GroupType        == ECOTRAN.GroupTypeDef_plgcBacteria | GroupType == ECOTRAN.GroupTypeDef_bnthBacteria);
looky_micrograzers                  = find(GroupType        == ECOTRAN.GroupTypeDef_micrograzers);
looky_bacteria                      = find(floor(GroupType) == ECOTRAN.GroupTypeDef_bacteria);
looky_eggs                          = find(GroupType        == ECOTRAN.GroupTypeDef_eggs);
looky_ANYdetritus                   = find(floor(GroupType) == ECOTRAN.GroupTypeDef_ANYDetritus);
looky_terminalPLGCdetritus          = find(GroupType        == ECOTRAN.GroupTypeDef_terminalPlgcDetr);
looky_terminalBNTHdetritus          = find(GroupType        == ECOTRAN.GroupTypeDef_terminalBnthDetr);
looky_eggsANDdetritus               = sort([looky_ANYdetritus; looky_eggs]);
looky_livingANDdetritus             = sort([looky_ANYPrimaryProducer; looky_ANYconsumer; looky_bacteria; looky_eggsANDdetritus]);
looky_terminalANYdetritus           = find(GroupType == ECOTRAN.GroupTypeDef_terminalPlgcDetr | GroupType == ECOTRAN.GroupTypeDef_terminalBnthDetr);
looky_fleets                        = find(floor(GroupType) == ECOTRAN.GroupTypeDef_fleet);
looky_livingANDfleets               = [looky_ANYPrimaryProducer; looky_ANYconsumer; looky_bacteria; looky_fleets]; % includes primary producers & bacteria
looky_NONnutrients                  = sort([looky_livingANDdetritus; looky_fleets]);	% addresses of all groups EXCEPT nutrients (needed to append nutrients)
looky_nonNO3                     	= 1:num_grps;
looky_nonNO3(looky_NO3)          	= [];

num_nutrients                   	= length(looky_nutrients);
num_NO3                             = length(looky_NO3);
num_NH4                          	= length(looky_NH4);
num_plgcNH4                         = length(looky_plgcNH4); % FFF replace mat_num_plgcNH4 & mat_num_bnthNH4 with simple mat_num_NH4
num_bnthNH4                         = length(looky_bnthNH4); % FFF replace mat_num_plgcNH4 & mat_num_bnthNH4 with simple mat_num_NH4
num_ANYPrimaryProd                	= length(looky_ANYPrimaryProducer);
num_phytoplankton                	= length(looky_phytoplankton);
num_macroalgae                   	= length(looky_macroalgae);
num_ANYconsumers                	= length(looky_ANYconsumer);
num_fleets                          = length(looky_fleets);
num_predators                       = num_ANYconsumers + num_fleets;
num_livingANDfleets                 = length(looky_livingANDfleets);
num_eggs                         	= length(looky_eggs);
num_ANYdetritus                   	= length(looky_ANYdetritus);
% *************************************************************************





% *************************************************************************
% STEP 5: define TransferEfficiency terms----------------------------------
%         SET MANUALLY: TransferEfficiency = 1 for all groups because we are
%                       working with the consumption budget matrix that tracks the fate of ALL consumption (not just predation)
%                       system losses (groups where TransferEfficiency < 1 include benthic detritus, fishery, (others?)
%          NOTE: terminal benthic detritus column in EnergyBudget sums to 1 and has NO OtherMortality, 
%                TE is the only means of removing terminal benthic detritus from system
TransferEfficiency                  = ones(num_MC, num_grps); % re-initialize as rows of horizontal vector of ones
TransferEfficiency(:, [looky_terminalBNTHdetritus]) = 0.1; % NOTE: I use 0.1 TE for terminal benthic detritus as a standard default (JRuz 9/27/2018)
ECOTRAN_MC.TransferEfficiency_MC	= TransferEfficiency;
% *************************************************************************





% *************************************************************************
% STEP 6: define production loss fractions---------------------------------
%         (FFF in future, might use vector read in from .csv file; but for now, this is all handled here)
% LX                   = 0; % NOTE: set to 0 to ignore physical losses; set to 1 for the default relative upwelling index (1 is used for the average yearly relative upwelling index)
LX                          = ones(1, num_grps);
ProductionLossScaler        = zeros(1, num_grps); % initialize
PhysicalLossFraction        = ProductionLossScaler .* LX;
% *************************************************************************


% end m-file***************************************************************