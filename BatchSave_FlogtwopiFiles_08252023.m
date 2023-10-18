% BatchSave_FlogtwopiFiles_08252023
% Batch save mass-balanced model parameters from K-path files
% 
% takes:
%       ReadFile_directory      directory containing ONLY balanced K-path files
%       
% calls:
%       f_readKpath_08142023
%       EcoBase_nametranslator_08122023.mat     file containing translations to standardized functional group definitions
%       
%
% revision date: 8-25-2023


ReadFile_directory	= '/2_VisualBasic_versions/Atlantic_VisualBasic_versions/';
% ReadFile_directory	= '/2_VisualBasic_versions/Pacific_VisualBasic_versions/';
% ReadFile_directory	= '/2_VisualBasic_versions/OtherRegions_VisualBasic_versions/';
% ReadFile_directory	= '/2_VisualBasic_versions/LiteratureModels_VisualBasic_versions/';


SaveFile_directory	= ReadFile_directory;
FolderContents      = dir([ReadFile_directory '*.xlsm']); % dir struct of all pertinent .csv files
num_files           = length(FolderContents); % count of .csv files


% read in ECOTRAN name and group type definitions ----------------
NameTranslator_directory        = '/4_Metadata/';
NameTranslator_file             = 'EcoBase_nametranslator_08122023.mat';
load([NameTranslator_directory NameTranslator_file], 'EcoBase_nametranslator')


for file_loop = 1:num_files
    
	ReadFile_name       = FolderContents(file_loop).name; 
    ReadFile            = [ReadFile_directory ReadFile_name];
    
    % grab model number from file name
    ModelNumber_text	= ReadFile_name;
    ModelNumber_text	= erase(ModelNumber_text, 'ECOTRAN_Ecobase-');
    ModelNumber_text	= eraseBetween(ModelNumber_text, '_', '.xlsm', 'Boundaries', 'inclusive');
    ModelNumber         = str2num(ModelNumber_text);
    
    SaveFile_name       = ['ECOTRAN_Ecobase-' num2str(ModelNumber) '_' date() '.mat'];
    SaveFile            = [ReadFile_directory SaveFile_name];
    
    disp(['Processing file: ' ReadFile_name])
    
%     dat                 = f_readKpath_10222022(ReadFile);
    dat                 = f_readKpath_08142023(ReadFile);
    
    
    % re-assign EcotranType codes -----------------------------------------
    num_EcotranGroups                   = dat.num_EcotranGroups;
    EcotranName                         = dat.EcotranName;
	old_EcotranGroupType                = dat.EcotranGroupType;
    EwEGroupType                        = dat.EwEGroupType;
    EwEGroupType                        = [99; 99; 99; EwEGroupType]; % append EwEGroupType place-holders for nutrients 
    looky_fleet                         = find(EwEGroupType == 3);
    
    % initialize
    EcoBase_OriginalGroupName        	= repmat({''}, num_EcotranGroups, 1); % original name in the model; (strings)
    EcoBase_GroupType                	= zeros(num_EcotranGroups, 1); % Ecotran group type code; (double)
    EcoBase_MajorClass                  = repmat({''}, num_EcotranGroups, 1); % (strings)
   	EcoBase_SPFtype_resolved         	= repmat({''}, num_EcotranGroups, 1); % (strings)
    EcoBase_SPFtype_aggregated        	= repmat({''}, num_EcotranGroups, 1); % (strings)
    EcoBase_GroupName                   = repmat({''}, num_EcotranGroups, 1); % a generalized group name (probably not used); (strings)
    EcoBase_SPFtype_ecotype          	= repmat({''}, num_EcotranGroups, 1); % (probably not used); (strings)
    EcoBase_LifeStage                   = repmat({''}, num_EcotranGroups, 1); % (probably not used); (strings)
    EcoBase_WatercolumnEnvironment      = repmat({''}, num_EcotranGroups, 1); % (probably not used); (strings)
    EcoBase_EnvironmentType             = repmat({''}, num_EcotranGroups, 1); % (probably not used); (strings)
    
    for grp_loop = 4:num_EcotranGroups
        
        current_EcotranName             = EcotranName(grp_loop);
        looky_current_grp               = find(strcmp(EcoBase_nametranslator.EcoBase_name, current_EcotranName) == 1); % row address of current_EcotranName in EcoBase_nametranslator
        num_EcoBase_name_hits           = length(looky_current_grp);
        
        if num_EcoBase_name_hits == 1 % if there is only a single model match with that original EcoBase group name
            
            EcoBase_OriginalGroupName(grp_loop)     	= current_EcotranName; % original name in the model
            EcoBase_GroupType(grp_loop)              	= EcoBase_nametranslator.ECOTRAN_type(looky_current_grp); % Ecotran group type code
            EcoBase_MajorClass(grp_loop)               	= EcoBase_nametranslator.major_class(looky_current_grp);
            EcoBase_SPFtype_resolved(grp_loop)         	= EcoBase_nametranslator.SPFtype_resolved(looky_current_grp);
            EcoBase_SPFtype_aggregated(grp_loop)      	= EcoBase_nametranslator.SPFtype_aggregated(looky_current_grp);
            EcoBase_GroupName(grp_loop)               	= EcoBase_nametranslator.group_name(looky_current_grp); % a generalized group name (probably not used)
            EcoBase_SPFtype_ecotype(grp_loop)         	= EcoBase_nametranslator.ecotype(looky_current_grp); % (probably not used)
            EcoBase_LifeStage(grp_loop)               	= EcoBase_nametranslator.life_stage(looky_current_grp); % (probably not used)
            EcoBase_WatercolumnEnvironment(grp_loop)  	= EcoBase_nametranslator.watercolumn_environment(looky_current_grp); % (probably not used)
            EcoBase_EnvironmentType(grp_loop)          	= EcoBase_nametranslator.environment_type(looky_current_grp); % (probably not used)
            
        elseif num_EcoBase_name_hits > 1 % if there are multiple entries of the same EcoBase group name (e.g., when name is used by more than 1 model)
            
            % find the EcoBase_nametranslator row that matched both the model group name and the model number
            current_modelID_list	= EcoBase_nametranslator.MODEL_ID(looky_current_grp);
            hit_list                = zeros(num_EcoBase_name_hits,1);
            
            for hits_loop = 1:num_EcoBase_name_hits
                hits_models = str2num(current_modelID_list{hits_loop});
                if max(ismember(hits_models, ModelNumber)) == 1
                    hit_list(hits_loop) = 1;
                end
            end
            
            looky_hit       = find(hit_list == 1);
            looky_hit       = looky_hit(1); % just in case the model is listed twice with the same EcoBase name (shouldn't happen...)
            
            EcoBase_OriginalGroupName(grp_loop)      	= current_EcotranName; % original name in the model
            EcoBase_GroupType(grp_loop)               	= EcoBase_nametranslator.ECOTRAN_type(looky_current_grp(looky_hit)); % Ecotran group type code
            EcoBase_MajorClass(grp_loop)               	= EcoBase_nametranslator.major_class(looky_current_grp(looky_hit));
            EcoBase_SPFtype_resolved(grp_loop)         	= EcoBase_nametranslator.SPFtype_resolved(looky_current_grp(looky_hit));
            EcoBase_SPFtype_aggregated(grp_loop)      	= EcoBase_nametranslator.SPFtype_aggregated(looky_current_grp(looky_hit));
            EcoBase_GroupName(grp_loop)               	= EcoBase_nametranslator.group_name(looky_current_grp(looky_hit)); % a generalized group name (probably not used)
            EcoBase_SPFtype_ecotype(grp_loop)       	= EcoBase_nametranslator.ecotype(looky_current_grp(looky_hit)); % (probably not used)
            EcoBase_LifeStage(grp_loop)               	= EcoBase_nametranslator.life_stage(looky_current_grp(looky_hit)); % (probably not used)
            EcoBase_WatercolumnEnvironment(grp_loop)  	= EcoBase_nametranslator.watercolumn_environment(looky_current_grp(looky_hit)); % (probably not used)
            EcoBase_EnvironmentType(grp_loop)          	= EcoBase_nametranslator.environment_type(looky_current_grp(looky_hit)); % (probably not used)
            
        end % (if num_EcoBase_name_hits == 1 elseif num_EcoBase_name_hits > 1)
        
    end % (grp_loop)

    % return detritus types to original EcotranGroupType to preserve terminal detritus identities
	looky_detritus                              = find(EwEGroupType == 2);
    EcoBase_GroupType(looky_detritus)       	= old_EcotranGroupType(looky_detritus);
    EcoBase_MajorClass(looky_detritus)          = {'detritus'};
    EcoBase_SPFtype_ecotype(looky_detritus)    	= {'detritus'};
	EcoBase_OriginalGroupName(looky_detritus)  	= EcotranName(looky_detritus);
	EcoBase_GroupName(looky_detritus)           = EcotranName(looky_detritus);
    
    % return nutrient types to original EcotranGroupType 
    looky_nutrients                             = find(floor(old_EcotranGroupType) == 1);	% row addresses of nutrients
    EcoBase_GroupType(looky_nutrients)        	= old_EcotranGroupType(looky_nutrients);
    EcoBase_MajorClass(looky_nutrients)         = {'nutrient'};
	EcoBase_SPFtype_ecotype(looky_nutrients)	= {'nutrient'};
    EcoBase_OriginalGroupName(looky_nutrients) 	= EcotranName(looky_nutrients);
	EcoBase_GroupName(looky_nutrients)          = EcotranName(looky_nutrients);

    % add fleets as an Ecobase_major_class
	looky_fleet                                 = find(old_EcotranGroupType == 5);	% row addresses of fleets
	EcoBase_GroupType(looky_fleet)              = old_EcotranGroupType(looky_fleet);
    EcoBase_MajorClass(looky_fleet)             = {'fleet'};
	EcoBase_SPFtype_ecotype(looky_fleet)        = {'fleet'};    
    EcoBase_OriginalGroupName(looky_fleet)     	= EcotranName(looky_fleet);
    EcoBase_GroupName(looky_fleet)              = EcotranName(looky_fleet);
    
    % pack-up and save results --------------------------------------------
    % re-define GroupTypeDef
    dat.GroupTypeDef_bacteria           = 9.000; % bacteria
    dat.GroupTypeDef_ANYNitroNutr       = 1.000; % any Nitrogen Nutrient
    dat.GroupTypeDef_NO3                = 1.000; % NO3
    dat.GroupTypeDef_plgcNH4            = 1.100; % pelagic NH4
    dat.GroupTypeDef_bnthNH4            = 1.200; % benthic NH4
    dat.GroupTypeDef_ANYPrimaryProd     = 2.000; % any Primary Producer
    dat.GroupTypeDef_LrgPhyto           = 2.120; % large phytoplankton
    dat.GroupTypeDef_SmlPhyto           = 2.110; % small phytoplankton
    dat.GroupTypeDef_Macrophytes        = 2.220; % macrophytes	2.3
    dat.GroupTypeDef_ANYConsumer        = 3.000; % any consumer	3
    dat.GroupTypeDef_ConsumPlgcPlankton = 3.110; % consumer - pelagic - plankton	3.11
    dat.GroupTypeDef_ConsumPlgcNekton   = 3.140; % consumer - pelagic - nekton	3.12
    dat.GroupTypeDef_ConsumPlgcWrmBlood	= 3.160; % consumer - pelagic - warm-blooded
    dat.GroupTypeDef_ConsumBntcInvert   = 3.210; % consumer - benthic - invertebrate
    dat.GroupTypeDef_ConsumBntcVert     = 3.240; % consumer - benthic - vertebrate
    dat.GroupTypeDef_ConsumBnthWrmBlood = 3.260; % consumer - benthic - warm-blooded
    dat.GroupTypeDef_eggs               = 8.000; % any eggs
    dat.GroupTypeDef_ANYDetritus        = 4.000; % any detritus (not egg)
    dat.GroupTypeDef_offal              = 4.200; % offal
    dat.GroupTypeDef_terminalPlgcDetr	= 4.100; % terminal pelagic detritus
    dat.GroupTypeDef_terminalBnthDetr	= 4.300; % terminal benthic detritus
    dat.GroupTypeDef_BA                 = 6.1; % accumulation (BA)
    dat.GroupTypeDef_EM                 = 6.2; % emigration (EM)
    dat.GroupTypeDef_fishery            = 5.000; % fleet
    dat.GroupTypeDef_import             = 7.000; % assigned in matlab code later (import??)
    dat.GroupTypeDef_micrograzers       = 3.111; % micrograzers
    
    % step 2a: re-calculate additional group counts based on new GroupTypeDef_
    dat.num_detritus                    = length(find(floor(EcoBase_GroupType) == dat.GroupTypeDef_ANYDetritus));
    dat.num_eggs                        = length(find(EcoBase_GroupType  == dat.GroupTypeDef_eggs));
    dat.num_EggsAndDetritus             = dat.num_eggs + dat.num_detritus;
    dat.num_micrograzers                = length(find(EcoBase_GroupType  == dat.GroupTypeDef_micrograzers));
    dat.num_bacteria                    = length(find(EcoBase_GroupType  == dat.GroupTypeDef_bacteria));
    dat.num_PrimaryProducer             = length(find(fix(EcoBase_GroupType)  == dat.GroupTypeDef_ANYPrimaryProd));
    
    % save other Ecobase/SPF naming info
    dat.EcoBase_ModelNumber             = ModelNumber;
    dat.EcoBase_OriginalGroupName     	= EcoBase_OriginalGroupName;
	dat.EcoBase_GroupName           	= EcoBase_GroupName;
    dat.EcoBase_GroupNumber             = dat.EcotranNumberCode; % use original vector from Ecotran
	dat.EcoBase_GroupType             	= EcoBase_GroupType;
    dat.EcoBase_MajorClass              = EcoBase_MajorClass;
    dat.EcoBase_SPFtype_resolved        = EcoBase_SPFtype_resolved;
    dat.EcoBase_SPFtype_aggregated      = EcoBase_SPFtype_aggregated;
    dat.EcoBase_ecotype                 = EcoBase_SPFtype_ecotype;
    dat.EcoBase_LifeStage            	= EcoBase_LifeStage;
    dat.Ecobase_watercolumn_environment	= EcoBase_WatercolumnEnvironment;
    dat.Ecobase_environment_type      	= EcoBase_EnvironmentType;
    
    save([SaveFile_directory SaveFile_name], 'dat')

end
% *************************************************************************


% end m-file***************************************************************