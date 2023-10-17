% ParseEcobase_07042023
% access and parse parameters for 1 model in the Ecobase EwE database
% by Jim Ruzicka
%
% takes:
%       target_EwEmodel         model code number from Ecobase database
%
% calls:
%       parseXML
%
% returns:
%       model_info_table        cell structure of basic model info
%       parameter_table         parameter values for each group
%
% NOTE: does not process stanza info
% NOTE: does not process pedigree info
% revision date: 7-4-2023



% *************************************************************************
% STEP 1: define and load 1 EwE model--------------------------------------


% Pacific -----------------------------------------------------------------
% target_EwEmodel     = 2; % Prince William Sound
% target_EwEmodel     = 42; % Eastern Tropical Pacific
% target_EwEmodel     = 172; % West Coast Vancouver Island
% target_EwEmodel     = 175; % Western Bering Sea
% target_EwEmodel     = 239; % Central Gulf of California
% target_EwEmodel     = 242; % Alto Golfo de California
% target_EwEmodel     = 252; % Aleutian Islands
% target_EwEmodel     = 266; % Kuosheng Bay
% target_EwEmodel     = 267; % Lagoon Chiku - Taiwan
% target_EwEmodel     = 282; % Prince William Sound
% target_EwEmodel     = 307; % Jalisco and Colima Coast Mexico
% target_EwEmodel     = 311; % Peru 1953
% target_EwEmodel     = 312; % Peru 1960
% target_EwEmodel     = 325; % Sinaloa sur MEXICO Mexico
% target_EwEmodel     = 328; % Strait of Georgia
% target_EwEmodel     = 410; % North South of China Sea
% target_EwEmodel     = 417; % Baja California
% target_EwEmodel     = 436; % Western Tropical Pacific Ocean
% target_EwEmodel     = 438; % South East Alaska
% target_EwEmodel     = 439; % Peru 1953 (other author)
% target_EwEmodel     = 450; % Gulf of California
% target_EwEmodel     = 477; % Strait of Georgia 1950
% target_EwEmodel     = 478; % British Columbia coast
% target_EwEmodel     = 479; % North East Pacific
% target_EwEmodel     = 487; % Humboldt Current Tam
% target_EwEmodel     = 488; % Northern Humboldt Current Tam
% target_EwEmodel     = 489; % Sechura Bay Peru
% target_EwEmodel     = 490; % Independence Bay Peru
% target_EwEmodel     = 499; % Kaloko Honokohau USA coral reef
% target_EwEmodel     = 519; % Northern Californian Current 1960 Field
% target_EwEmodel     = 637; % Central Chile
% target_EwEmodel     = 658; % Peru 1973
% target_EwEmodel     = 674; % Northern British Columbia 1950
% target_EwEmodel     = 675; % Northern British Columbia 2000
% target_EwEmodel     = 677; % Gulf of Nicoya Costa Rica
% target_EwEmodel     = 682; % Bolinao Coral Reef Phillipines coral reef
% target_EwEmodel     = 703; % Bolinao Coral Reef Phillipines coral reef
% target_EwEmodel     = 711; % Danajon Bank Phillipines
% target_EwEmodel     = 730; % Moreton Bay Ecosystem Australia
% target_EwEmodel     = 741; % Galapagos
% target_EwEmodel     = 756; % Western Antarctic Peninsula


% Atlantic ----------------------------------------------------------------
% target_EwEmodel     = 7; % Azores archipelago Azores
% target_EwEmodel     = 28; % Central Atlantic
% target_EwEmodel     = 29; % Central Atlantic
% target_EwEmodel     = 40; % Eastern Scotian Shelf
% target_EwEmodel     = 41; % Eastern Scotian Shelf
% target_EwEmodel     = 63; % Barents Sea Russia
% target_EwEmodel     = 64; % Low Barents Sea Russia
% target_EwEmodel     = 68; % Icelandic shelf Iceland
% target_EwEmodel     = 99; % USA, Mid Atlantic Bight
% target_EwEmodel     = 105; % Grand Banks of Newfoundland Canada
% target_EwEmodel     = 107; % Grand Banks of Newfoundland Canada
% target_EwEmodel     = 108; % Grand Banks of Newfoundland Canada
% target_EwEmodel     = 111; % North Atlantic 
% target_EwEmodel     = 112; % North Atlantic 
% target_EwEmodel     = 115; % Northern Benguela Namibia
% target_EwEmodel     = 116; % Northern Gulf St Lawrence Canada
% target_EwEmodel     = 118; % Northwest Africa
% target_EwEmodel     = 133; % Senegambia Senegal 
% target_EwEmodel     = 135; % Sierra Leone
% target_EwEmodel     = 136; % Sierra Leone 1978
% target_EwEmodel     = 137; % Sierra Leone
% target_EwEmodel     = 145; % Southern Gulf of St. Lawrence Canada
% target_EwEmodel     = 179; % Bamboung Senegal
% target_EwEmodel     = 180; % Bamboung Senegal
% target_EwEmodel     = 189; % North Brazil Brazil
% target_EwEmodel     = 227; % Iceland
% target_EwEmodel     = 324; % Virgin Islands BVI
% target_EwEmodel     = 335; % Bay of Biscay France
% target_EwEmodel     = 403; % Western Channel France,U.K. of Great Britain and Northern Ireland
% target_EwEmodel     = 411; % Malvinas/Falkland Islands
% target_EwEmodel     = 429; % S--fjord Norway
% target_EwEmodel     = 443; % West scotland DeepSea UK
% target_EwEmodel     = 444; % Gulf of Maine USA
% target_EwEmodel     = 446; % Hudson Bay Canada
% target_EwEmodel     = 448; % Irish Sea Ireland & UK
% target_EwEmodel     = 459; % Lesser Antilles
% target_EwEmodel     = 461; % West Scotland
% target_EwEmodel     = 462; % Northern Gulf of St Lawrence Canada
% target_EwEmodel     = 467; % USA, South Atlantic Continental Shelf
% target_EwEmodel     = 485; % South Benguela
% target_EwEmodel     = 486; % Cape Verde
% target_EwEmodel     = 500; % North Benguela Namibia
% target_EwEmodel     = 501; % North Benguela Namibia
% target_EwEmodel     = 502; % North Benguela Namibia
% target_EwEmodel     = 503; % North Benguela Namibia
% target_EwEmodel     = 504; % South Benguela Namibia
% target_EwEmodel     = 505; % South Benguela Namibia
% target_EwEmodel     = 506; % South of Benguela Namibia
% target_EwEmodel     = 513; % Liberia
% target_EwEmodel     = 518; % New Foundland Canada
% target_EwEmodel     = 526; % Western Channel UK Farance
% target_EwEmodel     = 633; % Bay of Biscay France
% target_EwEmodel     = 634; % Bay of Biscay France
% target_EwEmodel     = 646; % Guinea
% target_EwEmodel     = 654; % Morocco
% target_EwEmodel     = 655; % Canada, Grand Banks of Newfoundland
% target_EwEmodel     = 663; % South Shetlands Antarctica
% target_EwEmodel     = 664; % Southern Brazil Brazil
% target_EwEmodel     = 680; % North Sea
% target_EwEmodel     = 704; % Gulf of Maine USA
% target_EwEmodel     = 705; % Georges Bank USA
% target_EwEmodel     = 706; % Southern New England USA
% target_EwEmodel     = 707; % Mid-Atlantic Bight USA
% target_EwEmodel     = 725; % Guinea 
% target_EwEmodel     = 726; % Guinea 
% target_EwEmodel     = 728; % Barnegat Bay USA
% target_EwEmodel     = 734; % Celtic Sea France UK Ireland
% target_EwEmodel     = 735; % Celtic Sea France UK Ireland
% target_EwEmodel     = 736; % Bay of Biscay
% target_EwEmodel     = 737; % Bay of Biscay France
% target_EwEmodel     = 738; % Azores
% target_EwEmodel     = 742; % Mount St Michel Bay France
% target_EwEmodel     = 751; % Malangen Fjord Norway
% target_EwEmodel     = 752; % Baie de Seine France
% target_EwEmodel     = 753; % Narragansett Bay food web USA
% target_EwEmodel     = 754; % Celtic Sea France


% Other Regions -----------------------------------------------------------
% target_EwEmodel     = 24;
% target_EwEmodel     = 46;
% target_EwEmodel     = 53;
% target_EwEmodel     = 153;
% target_EwEmodel     = 168;
% target_EwEmodel     = 217; % very small file
% target_EwEmodel     = 218;
% target_EwEmodel     = 232; % very small file
% target_EwEmodel     = 240;
% target_EwEmodel     = 241;
% target_EwEmodel     = 243;
% target_EwEmodel     = 246;
% target_EwEmodel     = 247;
% target_EwEmodel     = 269; %
% target_EwEmodel     = 291;
% target_EwEmodel     = 305; % West coast of Sabah Malaysia
% target_EwEmodel     = 318;
% target_EwEmodel     = 320;
% target_EwEmodel     = 323;
% target_EwEmodel     = 400; % Raja Ampat Indonesia 1990
% target_EwEmodel     = 401; % Raja Ampat Indonesia 2005
% target_EwEmodel     = 405;
% target_EwEmodel     = 412; % Gulf of Thailand
% target_EwEmodel     = 414;
% target_EwEmodel     = 431;
% target_EwEmodel     = 433; % very small file
% target_EwEmodel     = 434;
% target_EwEmodel     = 435; % very small file
% target_EwEmodel     = 441;
% target_EwEmodel     = 452;
% target_EwEmodel     = 456;
% target_EwEmodel     = 464; % very small file
% target_EwEmodel     = 465; % Albatross Bay Australia
% target_EwEmodel     = 466; % Gulf of Carpentaria Australia
% target_EwEmodel     = 468; % very small file
% target_EwEmodel     = 473;
% target_EwEmodel     = 495;
% target_EwEmodel     = 496;
% target_EwEmodel     = 497;
% target_EwEmodel     = 520;
% target_EwEmodel     = 522;
% target_EwEmodel     = 608;
% target_EwEmodel     = 650;
% target_EwEmodel     = 651;
% target_EwEmodel     = 669;
% target_EwEmodel     = 687;
% target_EwEmodel     = 689;
% target_EwEmodel     = 691;
% target_EwEmodel     = 692; % very small file
% target_EwEmodel     = 693; % very small file
% target_EwEmodel     = 727;
% target_EwEmodel     = 729;
% target_EwEmodel     = 731;
% target_EwEmodel     = 739;
% target_EwEmodel     = 740;
% target_EwEmodel     = 743;
% target_EwEmodel     = 745;
% target_EwEmodel     = 746;
% target_EwEmodel     = 748;
% target_EwEmodel     = 749;
% target_EwEmodel     = 750;
% target_EwEmodel     = 755;
% target_EwEmodel     = 758;
% target_EwEmodel     = 759;


% PROBLEM MODELS ----------------------------------------------------------
% target_EwEmodel     = 34; % Chesapeake USA; imbalance in EcoBase?
% target_EwEmodel     = 48; % Galapagos; imbalance in EcoBase?
% target_EwEmodel     = 58; % Gulf of Mexico; imbalance in EcoBase?
% target_EwEmodel     = 125; % Ria Formosa; freshwater
% target_EwEmodel     = 183; % Eastern Bering Sea; overflow error in VisualBasic
% target_EwEmodel     = 221; % Garonne; freshwater
% target_EwEmodel     = 279; % Prince William Sound; imbalance in EcoBase?
% target_EwEmodel     = 289; % Seagrass and Mangrove Terminos Lagoon; imbalance in EcoBase?
% target_EwEmodel     = 298; % Paraná River Floodplain; freshwater
% target_EwEmodel     = 406; % East Bass Strait Australia; imbalance in EcoBase?
% target_EwEmodel     = 407; % Tasmanian Seamounts Marine Reserve Australia; imbalance in EcoBase?
% target_EwEmodel     = 413; % North Sea; imbalance in EcoBase?
% target_EwEmodel     = 415; % South West Viet nam; overflow error in VisualBasic
% target_EwEmodel     = 432; % Ningaloo; overflow error in VisualBasic
% target_EwEmodel     = 447; % Antarctica; overflow error in VisualBasic
% target_EwEmodel     = 457; % North Sea; overflow error in VisualBasic
% target_EwEmodel     = 521; % Northern Californian Current 1990 Field; imbalance in EcoBase?
% target_EwEmodel     = 537; % Santa Pola Bay; aquaculture operation
% target_EwEmodel     = 567; % Arachania Uruguay; imbalance in EcoBase?
% target_EwEmodel     = 568; % Barra Del Chuy Uruguay; beach
% target_EwEmodel     = 732; % Celtic Sea-Biscay; imbalance in EcoBase?
% target_EwEmodel     = 733; % Celtic Sea-Biscay France; imbalance in EcoBase?
% target_EwEmodel     = 744; % Sítios Novos reservoir; freshwater
% target_EwEmodel     = 757; % Ria-Lake Tapajos; freshwater



filename            = ['http://sirs.agrocampus-ouest.fr/EcoBase/php/webser/soap-client.php?no_model=' num2str(target_EwEmodel)];
theStruct           = parseXML(filename);

SaveFile_directory	= '/1_ECOBASE_queries/';
SaveFile_label      = ['ECOBASE_model-' num2str(target_EwEmodel) '_' date()];
SaveFile            = [SaveFile_directory SaveFile_label];
% *************************************************************************





% *************************************************************************
% STEP 2: parse out parameters from variable theStruct---------------------
struct_1                = theStruct.Children;
looky_bad               = find(strcmp({struct_1.Name}, '#text') == 1);
struct_1(looky_bad)     = []; % remove junk entries

% step 2a: get model description info -------------------------------------
looky_address           = find(strcmp({struct_1.Name}, {'model_descr'}) == 1);
struct_model_descr      = struct_1(looky_address).Children;

% get variable addresses
looky_model_number  	= find(strcmp({struct_model_descr.Name}, {'model_number'}) == 1);
looky_model_name      	= find(strcmp({struct_model_descr.Name}, {'model_name'}) == 1); % string
looky_country           = find(strcmp({struct_model_descr.Name}, {'country'}) == 1); % string
looky_area              = find(strcmp({struct_model_descr.Name}, {'area'}) == 1);
looky_geographic_extent	= find(strcmp({struct_model_descr.Name}, {'geographic_extent'}) == 1); % string
looky_ecosystem_type	= find(strcmp({struct_model_descr.Name}, {'ecosystem_type'}) == 1); % string
looky_currency_units	= find(strcmp({struct_model_descr.Name}, {'currency_units'}) == 1); % string
looky_description       = find(strcmp({struct_model_descr.Name}, {'description'}) == 1); % string
looky_num_group       	= find(strcmp({struct_model_descr.Name}, {'num_group'}) == 1);
looky_model_year        = find(strcmp({struct_model_descr.Name}, {'model_year'}) == 1);
looky_model_period    	= find(strcmp({struct_model_descr.Name}, {'model_period'}) == 1);
looky_doi               = find(strcmp({struct_model_descr.Name}, {'doi'}) == 1); % string
looky_reference     	= find(strcmp({struct_model_descr.Name}, {'reference'}) == 1); % string

% build model_info_table
model_info_table        = cell(13, 2); % initialize
model_info_table{1, 1}	= 'model number';
model_info_table{1, 2}	= str2num(struct_model_descr(looky_model_number).Children.Data);
model_info_table{2, 1}	= 'model name';
model_info_table{2, 2}	= struct_model_descr(looky_model_name).Children.Data;
model_info_table{3, 1}	= 'country';
model_info_table{3, 2}	= struct_model_descr(looky_country).Children.Data;
model_info_table{4, 1}	= 'area';
if ~isempty(looky_area); model_info_table{4, 2}	= str2num(struct_model_descr(looky_area).Children.Data); end
model_info_table{5, 1}	= 'geographic extent';
model_info_table{5, 2}	= struct_model_descr(looky_geographic_extent).Children.Data;
model_info_table{6, 1}	= 'ecosystem type';
if ~isempty(looky_ecosystem_type); model_info_table{6, 2}	= struct_model_descr(looky_ecosystem_type).Children.Data; end
model_info_table{7, 1}	= 'currency units';
model_info_table{7, 2}	= struct_model_descr(looky_currency_units).Children.Data;
model_info_table{8, 1}	= 'description';
model_info_table{8, 2}	= struct_model_descr(looky_description).Children.Data;
model_info_table{9, 1}	= 'number of groups';
model_info_table{9, 2}	= str2num(struct_model_descr(looky_num_group).Children.Data);
model_info_table{10, 1}	= 'number of fleets';
model_info_table{10, 2}	= 0; % initialize as zero, re-write number of fleets below;
model_info_table{11, 1}	= 'model year';
model_info_table{11, 2}	= str2num(struct_model_descr(looky_model_year).Children.Data);
model_info_table{12, 1}	= 'model period';
if ~isempty(looky_model_period); model_info_table{12, 2} = str2num(struct_model_descr(looky_model_period).Children.Data); end
model_info_table{13, 1}	= 'reference';
model_info_table{13, 2}	= struct_model_descr(looky_reference).Children.Data;
model_info_table{14, 1}	= 'doi';
if ~isempty(looky_doi); model_info_table{14, 2}	= struct_model_descr(looky_doi).Children.Data; end

num_grps                = str2num(struct_model_descr(looky_num_group).Children.Data); 
% -------------------------------------------------------------------------


% step 2b: get group description info--------------------------------------
looky_address           = find(strcmp({struct_1.Name}, {'group_descr'}) == 1);
struct_group_descr      = struct_1(looky_address).Children;
looky_bad               = find(strcmp({struct_group_descr.Name}, '#text') == 1);
struct_group_descr(looky_bad)      = [];
[~, num_grps_check]     = size(struct_group_descr);
if num_grps_check ~= num_grps
    warning('There is an issue with the number of groups')
end

% initialize tables
parameter_table                 = zeros(num_grps, 10); % QQQ start here, build up param matrix in order as we go along instead of sorting after
parameter_table_label           = cell(1, 10);
group_label_table               = cell(num_grps, 1);
diet_table                      = zeros((num_grps+1), num_grps); % initialize; (2D matrix: (num_grps+1) X num_grps)
detritus_fate_table             = zeros(num_grps, num_grps); % initialize; (2D matrix: num_grps X num_grps)

supp_parameter_table            = cell(num_grps, 11);
supp_parameter_table_label  	= cell(1, 11);


parameter_table_label{1, 1}     = 'group #';
parameter_table_label{1, 2}     = 'group type';
parameter_table_label{1, 3}     = 'biomass';
parameter_table_label{1, 4}     = 'p/b';
parameter_table_label{1, 5}     = 'q/b';
parameter_table_label{1, 6}     = 'ee';
parameter_table_label{1, 7}     = 'p/q';
parameter_table_label{1, 8}     = 'ba';
parameter_table_label{1, 9}     = 'assimilation efficiency';
parameter_table_label{1, 10}	= 'detritus import';

supp_parameter_table_label{1, 1}	= 'habitat area';
supp_parameter_table_label{1, 2}	= 'biomass habitat area';
supp_parameter_table_label{1, 3}	= 'vbk';
supp_parameter_table_label{1, 4}	= 'biomass accumulation';
supp_parameter_table_label{1, 5}	= 'respiration';
supp_parameter_table_label{1, 6}	= 'immigration';
supp_parameter_table_label{1, 7}	= 'emigration';
supp_parameter_table_label{1, 8}	= 'emigration rate';
supp_parameter_table_label{1, 9}	= 'other mortality';
supp_parameter_table_label{1, 10}	= 'export';
supp_parameter_table_label{1, 11}	= 'shadow price';


for grp_loop = 1:num_grps
    
    disp(['Processing group ' num2str(grp_loop) ' of ' num2str(num_grps)])
    
    current_grp_structure	= struct_group_descr(grp_loop);
    struct_2                = current_grp_structure.Children;
    looky_bad               = find(strcmp({struct_2.Name}, '#text') == 1);
    struct_2(looky_bad)     = [];
    
    % get variable addresses (probaly the same for all groups, but re-check for each group anyway)
    looky_group_name                = find(strcmp({struct_2.Name}, {'group_name'}) == 1);
    looky_group_seq                 = find(strcmp({struct_2.Name}, {'group_seq'}) == 1);
    looky_pp                        = find(strcmp({struct_2.Name}, {'pp'}) == 1);
    looky_biomass                   = find(strcmp({struct_2.Name}, {'biomass'}) == 1);
    looky_pb                        = find(strcmp({struct_2.Name}, {'pb'}) == 1);
    looky_qb                        = find(strcmp({struct_2.Name}, {'qb'}) == 1);
    looky_ee                        = find(strcmp({struct_2.Name}, {'ee'}) == 1);
	looky_ge                        = find(strcmp({struct_2.Name}, {'ge'}) == 1);
    looky_biomass_accum_rate        = find(strcmp({struct_2.Name}, {'biomass_accum_rate'}) == 1);
    looky_gs                        = find(strcmp({struct_2.Name}, {'gs'}) == 1);
    looky_detritus_import           = find(strcmp({struct_2.Name}, {'detritus_import'}) == 1);
    looky_diet_imp                  = find(strcmp({struct_2.Name}, {'diet_imp'}) == 1);
    looky_diet_descr                = find(strcmp({struct_2.Name}, {'diet_descr'}) == 1);
    
    looky_habitat_area              = find(strcmp({struct_2.Name}, {'habitat_area'}) == 1);
    looky_biomass_habitat_area      = find(strcmp({struct_2.Name}, {'biomass_habitat_area'}) == 1);
    looky_vbk                       = find(strcmp({struct_2.Name}, {'vbk'}) == 1);
    looky_biomass_accum             = find(strcmp({struct_2.Name}, {'biomass_accum'}) == 1);
	looky_respiration               = find(strcmp({struct_2.Name}, {'respiration'}) == 1);
    looky_immigration               = find(strcmp({struct_2.Name}, {'immigration'}) == 1);
    looky_emigration                = find(strcmp({struct_2.Name}, {'emigration'}) == 1);
    looky_emigration_rate           = find(strcmp({struct_2.Name}, {'emigration_rate'}) == 1);
    looky_other_mort                = find(strcmp({struct_2.Name}, {'other_mort'}) == 1);
	looky_export                    = find(strcmp({struct_2.Name}, {'export'}) == 1);
    looky_shadow_price              = find(strcmp({struct_2.Name}, {'shadow_price'}) == 1);
%     looky_taxon_descr               = find(strcmp({struct_2.Name}, {'taxon_descr'}) == 1);
%     looky_pedigree_assignment_descr	= find(strcmp({struct_2.Name}, {'pedigree_assignment_descr'}) == 1);
%     looky_pb_input                  = find(strcmp({struct_2.Name}, {'pb_input'}) == 1);
%     looky_ee_input                  = find(strcmp({struct_2.Name}, {'ee_input'}) == 1);
%     looky_qb_input                  = find(strcmp({struct_2.Name}, {'qb_input'}) == 1);
%     looky_ge_input                  = find(strcmp({struct_2.Name}, {'ge_input'}) == 1);
%     looky_b_hab_area_input          = find(strcmp({struct_2.Name}, {'b_hab_area_input'}) == 1);
    
    current_group_label             = struct_2(looky_group_name).Children.Data; 
    current_group_seq               = str2num(struct_2(looky_group_seq).Children.Data); % group sequence number
    disp(['   Current group-->> ' current_group_label])
    
    % build parameter tables
    group_label_table{current_group_seq, 1}     = current_group_label;
    
    % main parameters
    parameter_table(current_group_seq, 1)    	= current_group_seq; % group sequence number
    parameter_table(current_group_seq, 2)    	= str2num(struct_2(looky_pp).Children.Data); % group type QQQ ???
    parameter_table(current_group_seq, 3)   	= str2num(struct_2(looky_biomass).Children.Data); % biomass
    parameter_table(current_group_seq, 4)   	= str2num(struct_2(looky_pb).Children.Data); % pb
    parameter_table(current_group_seq, 5)   	= str2num(struct_2(looky_qb).Children.Data); % qb
    parameter_table(current_group_seq, 6)   	= str2num(struct_2(looky_ee).Children.Data); % ee
    if ~isempty(looky_ge); parameter_table(current_group_seq, 7)	= str2num(struct_2(looky_ge).Children.Data); end  % pq
    parameter_table(current_group_seq, 8)   	= str2num(struct_2(looky_biomass_accum_rate).Children.Data); % ba rate QQQ use this or looky_biomass_accum???
    if ~isempty(looky_gs); parameter_table(current_group_seq, 9)	= str2num(struct_2(looky_gs).Children.Data); end  % assimilation efficiency QQQ ???
	if ~isempty(looky_gs); parameter_table(current_group_seq, 10)	= str2num(struct_2(looky_detritus_import).Children.Data); end  % detritus import

    % additional parameters
    supp_parameter_table{current_group_seq, 1}    	= str2num(struct_2(looky_habitat_area).Children.Data); 
    supp_parameter_table{current_group_seq, 2}    	= str2num(struct_2(looky_biomass_habitat_area).Children.Data);
	if ~isempty(looky_vbk); supp_parameter_table{current_group_seq, 3}	= str2num(struct_2(looky_vbk).Children.Data); end  % vbk
	if ~isempty(looky_biomass_accum); supp_parameter_table{current_group_seq, 4}	= str2num(struct_2(looky_biomass_accum).Children.Data); end  % biomass accumulation
	if ~isempty(looky_respiration); supp_parameter_table{current_group_seq, 5}    	= str2num(struct_2(looky_respiration).Children.Data); end  % respiration
	if ~isempty(looky_immigration); supp_parameter_table{current_group_seq, 6}    	= str2num(struct_2(looky_immigration).Children.Data); end  % immigration
	if ~isempty(looky_emigration); supp_parameter_table{current_group_seq, 7}    	= str2num(struct_2(looky_emigration).Children.Data); end  % emigration
	if ~isempty(looky_emigration_rate); supp_parameter_table{current_group_seq, 8}    	= str2num(struct_2(looky_emigration_rate).Children.Data); end  % emigration rate
	if ~isempty(looky_other_mort); supp_parameter_table{current_group_seq, 9}    	= str2num(struct_2(looky_other_mort).Children.Data); end  % other mortality
	if ~isempty(looky_export); supp_parameter_table{current_group_seq, 10}    	= str2num(struct_2(looky_export).Children.Data); end  % export
	if ~isempty(looky_shadow_price); supp_parameter_table{current_group_seq, 11}    	= str2num(struct_2(looky_shadow_price).Children.Data); end  % shadow price
%     supp_parameter_table{current_group_seq, 12}    	= str2num(struct_2(looky_taxon_descr).Children.Data); % taxon description
%     supp_parameter_table{current_group_seq, 13}    	= str2num(struct_2(looky_pedigree_assignment_descr).Children.Data);
    
        
    % build diet tab
	if ~isempty(looky_diet_imp); diet_table(end, current_group_seq)      = str2num(struct_2(looky_diet_imp).Children.Data); end  % import diet
        
    current_diet_structure                  = struct_2(looky_diet_descr).Children;
    
    if ~isempty(current_diet_structure) % skip over detritus
    
        looky_bad                                   = find(strcmp({current_diet_structure.Name}, '#text') == 1); % find bad elements
        current_diet_structure(looky_bad)           = []; % delete bad elements

        [~, num_DietInfo]                           = size(current_diet_structure);

        for diet_loop = 1:num_DietInfo

            disp('     processing diet...')

            struct_current_diet_info        = current_diet_structure(diet_loop).Children;

            % get variable addresses (probaly the same for all groups, but re-check for each group anyway)
            looky_prey_seq              	= find(strcmp({struct_current_diet_info.Name}, {'prey_seq'}) == 1);
            looky_proportion                = find(strcmp({struct_current_diet_info.Name}, {'proportion'}) == 1);
            looky_detritus_fate           	= find(strcmp({struct_current_diet_info.Name}, {'detritus_fate'}) == 1);

            current_prey_seq                = str2num(struct_current_diet_info(looky_prey_seq).Children.Data); % prey sequence number
            current_proportion          	= str2num(struct_current_diet_info(looky_proportion).Children.Data); % proportion of diet
            current_detritus_fate          	= str2num(struct_current_diet_info(looky_detritus_fate).Children.Data); % detritus fate

            diet_table(current_prey_seq, current_group_seq)             = current_proportion;
            detritus_fate_table(current_prey_seq, current_group_seq)    = current_detritus_fate;

        end % (diet_loop)
        
    end % (~isempty(current_diet_structure))
    
end % (grp_loop)
% -------------------------------------------------------------------------


% step 2c: get fleet description info -------------------------------------
% initialize tables
fleet_label                 = cell(1, 1);
fleet_info_table            = zeros(4, 1);
fleet_info_label            = {'fleet #'; 'fixed cost'; 'sailing cost'; 'variable cost'};

fleet_prop_mort_table       = zeros(num_grps, 1);
fleet_market_table          = zeros(num_grps, 1);
fleet_total_landings_table	= zeros(num_grps, 1);
fleet_discards_table        = zeros(num_grps, 1);
fleet_other_temp            = cell(num_grps, 1); % temporary container to catch any other info (I don't think this is needed)


looky_address               = find(strcmp({struct_1.Name}, {'fleet_descr'}) == 1);
struct_group_fleets         = struct_1(looky_address).Children;

% only process fleets if there ARE fleets
if ~isempty(struct_group_fleets)


    looky_bad                   = find(strcmp({struct_group_fleets.Name}, '#text') == 1);
    struct_group_fleets(looky_bad)      = [];

    [~, num_fleets]             = size(struct_group_fleets);
    model_info_table{10, 2}     = num_fleets;

    fleet_label                 = cell(1, num_fleets);
    fleet_info_table            = zeros(4, num_fleets);
    fleet_info_label            = {'fleet #'; 'fixed cost'; 'sailing cost'; 'variable cost'};

    fleet_prop_mort_table       = zeros(num_grps, num_fleets);
    fleet_market_table          = zeros(num_grps, num_fleets);
    fleet_total_landings_table	= zeros(num_grps, num_fleets);
    fleet_discards_table        = zeros(num_grps, num_fleets);
    fleet_other_temp            = cell(num_grps, num_fleets); % temporary container to catch any other info (I don't think this is needed)


    for fleet_loop = 1:num_fleets

        disp(['Processing fleet ' num2str(fleet_loop) ' of ' num2str(num_fleets)])

        current_fleet_structure   	= struct_group_fleets(fleet_loop);
        struct_3                    = current_fleet_structure.Children;
        looky_bad                   = find(strcmp({struct_3.Name}, '#text') == 1);
        struct_3(looky_bad)         = [];

        % get variable addresses (probaly the same for all fleets, but re-check for each fleet anyway)
        looky_fleet_name            = find(strcmp({struct_3.Name}, {'fleet_name'}) == 1);
        looky_fleet_seq             = find(strcmp({struct_3.Name}, {'fleet_seq'}) == 1);
        looky_fixed_cost            = find(strcmp({struct_3.Name}, {'fixed_cost'}) == 1);
        looky_sailing_cost          = find(strcmp({struct_3.Name}, {'sailing_cost'}) == 1);
        looky_variable_cost         = find(strcmp({struct_3.Name}, {'variable_cost'}) == 1);
        looky_catch_descr           = find(strcmp({struct_3.Name}, {'catch_descr'}) == 1);
        looky_discard_fate_descr	= find(strcmp({struct_3.Name}, {'discard_fate_descr'}) == 1);

        current_fleet_label         = struct_3(looky_fleet_name).Children.Data; 
        current_fleet_seq       	= str2num(struct_3(looky_fleet_seq).Children.Data); % group sequence number
        if ~isempty(looky_fixed_cost); current_fixed_cost       	= str2num(struct_3(looky_fixed_cost).Children.Data); end
        if ~isempty(looky_sailing_cost); current_sailing_cost       	= str2num(struct_3(looky_sailing_cost).Children.Data); end
        if ~isempty(looky_variable_cost); current_variable_cost       = str2num(struct_3(looky_variable_cost).Children.Data); end

    % % %     % QQQ build fleet discard fate table
    % % %     % QQQ
    % % %     if isempty(struct_3(looky_discard_fate_descr).Children)
    % % %         fleet_discard_fate_table(current_fleet_seq, 1) = current_fleet_seq;
    % % %         fleet_discard_fate_table(current_fleet_seq, 2) = -9999;
    % % %     else
    % % %         struct_4                    = struct_3(looky_discard_fate_descr).Children.Children;
    % % %         looky_detritus_seq          = find(strcmp({struct_4.Name}, {'group_seq'}) == 1);
    % % %         looky_detritus_amount       = find(strcmp({struct_4.Name}, {'amount'}) == 1);
    % % % 
    % % %         current_fleet_detritus_seq    	= str2num(struct_4(looky_detritus_seq).Children.Data);
    % % %         current_fleet_detritus_amount	= str2num(struct_4(looky_detritus_amount).Children.Data);
    % % %         [~, num_detritus_seq]          	= size(current_fleet_detritus_seq);
    % % % 
    % % %         fleet_discard_fate_table(current_fleet_seq, 1) = current_fleet_seq;
    % % %         fleet_discard_fate_table(current_fleet_seq, (1+current_fleet_detritus_seq)) = current_fleet_detritus_amount;
    % % %     end % (isempty(struct_3(looky_discard_fate_descr).Children))
    % % %     % QQQ -----------------------------------------------------------------


        % build fleet cost table
        disp(['   Current fleet-->> ' current_fleet_label])
        fleet_label{1, fleet_loop}       = current_fleet_label;
        fleet_info_table(1, fleet_loop)	= current_fleet_seq;
        if ~isempty(looky_fixed_cost); fleet_info_table(2, fleet_loop)	= current_fixed_cost; end
        if ~isempty(looky_sailing_cost); fleet_info_table(3, fleet_loop)	= current_sailing_cost; end
        if ~isempty(looky_variable_cost); fleet_info_table(4, fleet_loop)	= current_variable_cost; end

        % process each producer group caught in the current fleet
        struct_catch_descr              = struct_3(looky_catch_descr).Children;
        looky_bad                       = find(strcmp({struct_catch_descr.Name}, '#text') == 1);
        struct_catch_descr(looky_bad)	= [];
        [~, num_CatchInfo]              = size(struct_catch_descr);

        for catch_loop = 1:num_CatchInfo

            current_struct_catch_descr	= struct_catch_descr(catch_loop).Children;
            looky_bad                   = find(strcmp({current_struct_catch_descr.Name}, '#text') == 1);
            current_struct_catch_descr(looky_bad)	= [];
            [~, num_entries] = size(current_struct_catch_descr);
            if num_entries ~= 3
                warning('Catch info entries ~= 3')
            end

            looky_group_seq             = find(strcmp({current_struct_catch_descr.Name}, {'group_seq'}) == 1);
            looky_catch_value           = find(strcmp({current_struct_catch_descr.Name}, {'catch_value'}) == 1);
            looky_catch_type            = find(strcmp({current_struct_catch_descr.Name}, {'catch_type'}) == 1);

            current_group_seq           = str2num(current_struct_catch_descr(looky_group_seq).Children.Data); % group sequence number
            current_catch_value      	= str2num(current_struct_catch_descr(looky_catch_value).Children.Data); % group sequence number
            current_catch_type      	= current_struct_catch_descr(looky_catch_type).Children.Data; % group sequence number

            % build catch info tables
            switch lower(current_catch_type) % lower, just in case they used upper case in the catch_type
                case('prop mort')
                    fleet_prop_mort_table(current_group_seq, fleet_loop) = current_catch_value;
                case('market')
                    fleet_market_table(current_group_seq, fleet_loop) = current_catch_value;
                case('total landings')
                    fleet_total_landings_table(current_group_seq, fleet_loop) = current_catch_value;
                case('discards')
                    fleet_discards_table(current_group_seq, fleet_loop) = current_catch_value;
                case('other')
                    fleet_other_temp{current_group_seq, fleet_loop} = current_catch_type;
            end

        end % (catch_loop)
    end % (fleet_loop)

    % sort tables by fleet_seq value ------------------------------------------
    % add 1 to fleet_seq_values in case they entetered values starting at 0
    fleet_seq_values	= fleet_info_table(1, :);
    minimum_fleet_seq	= min(fleet_seq_values);
    if minimum_fleet_seq == 0; fleet_seq_values = fleet_seq_values + 1; end

    % sort fleet tables
    [fleet_seq_values_NEW, fleet_sortOrder] = sort(fleet_seq_values, 2);

    fleet_label                 = fleet_label(fleet_sortOrder);
    fleet_info_table            = fleet_info_table(:, fleet_sortOrder);
    fleet_prop_mort_table       = fleet_prop_mort_table(:, fleet_sortOrder);
    fleet_market_table          = fleet_market_table(:, fleet_sortOrder);
    fleet_total_landings_table	= fleet_total_landings_table(:, fleet_sortOrder);
    fleet_discards_table        = fleet_discards_table(:, fleet_sortOrder);
    fleet_other_temp            = fleet_other_temp(:, fleet_sortOrder);

end % ~isempty(struct_group_fleets)
% *************************************************************************                





% *************************************************************************                
% STEP 3: some table clean-up---------------------------------------------- 
% step 3a: fix detritus fate table ----------------------------------------
looky_detitus           = find(parameter_table(:, 2) == 2); % addresses of detritus groups
num_detritus            = length(looky_detitus);
detritus_fate_label     = cell(1, num_detritus);
detritus_fate_label     = group_label_table(looky_detitus)';
detritus_fate           = detritus_fate_table(looky_detitus, :)'; % (2D matrix: num_grps X num_detritus); NOTE transpose
detritus_fate_table     = detritus_fate; % (2D matrix: num_grps X num_detritus)
disp('NOTE: -->> You will need to manually enter fleet discard fates.')
disp('NOTE: -->> You will need to manually enter discard export fate.')
% *************************************************************************                





% *************************************************************************                
% STEP 4: pack & save results----------------------------------------------
PackedModel.model_info_table            = model_info_table;          	% (2D matrix: 14 X 2)
PackedModel.parameter_table             = parameter_table; % (2D matrix: num_grps X 11)
PackedModel.parameter_table_label       = parameter_table_label; % (horizontal vector: 1 X 10)
PackedModel.group_label_table           = group_label_table; % (vertical vector: num_grps X 1)
PackedModel.diet_table                  = diet_table; % (2D matrix: (num_grps+1) X num_grps)
PackedModel.detritus_fate_table         = detritus_fate_table; % (2D matrix: num_grps X num_detritus)
PackedModel.detritus_fate_label         = detritus_fate_label; % (horizontal vector: 1 X num_detritus)
PackedModel.supp_parameter_table        = supp_parameter_table; % (2D matrix: num_grps X 11)
PackedModel.supp_parameter_table_label	= supp_parameter_table_label; % (horizontal vector: 1 X 11)
PackedModel.fleet_label                 = fleet_label; 	% (horizontal vector: 1 X num_fleets)
PackedModel.fleet_info_table            = fleet_info_table; % (2D matrix: 4 X num_fleets)
PackedModel.fleet_info_label            = fleet_info_label; % (horizontal vector: 1 X 4)
PackedModel.fleet_prop_mort_table       = fleet_prop_mort_table; % (2D matrix: num_grps X num_fleets)
PackedModel.fleet_market_table          = fleet_market_table; % (2D matrix: num_grps X num_fleets)
PackedModel.fleet_total_landings_table	= fleet_total_landings_table; % (2D matrix: num_grps X num_fleets)
PackedModel.fleet_discards_table        = fleet_discards_table; % (2D matrix: num_grps X num_fleets)
PackedModel.fleet_other_temp            = fleet_other_temp; % NOTE: probably and should be all empty; (2D matrix: num_grps X num_fleets)

% PackedModel.fleet_discard_fate_table	= fleet_discard_fate_table; % NOTE: probably and should be all empty; (2D matrix: num_grps X num_fleets)


save(SaveFile, 'PackedModel', 'theStruct');
% *************************************************************************                


% end m-file***************************************************************