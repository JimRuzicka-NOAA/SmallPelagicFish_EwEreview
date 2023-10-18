% Ecobase_makeCOTRAN_07032023.m
% write one Ecobase model to K-path .xlsm file
%
% calls:
%       FLOGTWOPI_03252022.xlsm
%
%   7/3/2023 allows for deleiberate assignment of fleet discard fates


% *************************************************************************
% STEP 1: define models to read and to save -------------------------------

% Atlantic models ---------------------------------------------------------
ReadFile_directory          = '/1_ECOBASE_queries/ECOBASE_Atlantic/';

ReadFile_name               = 'ECOBASE_model-7_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-28_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-29_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-40_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-41_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-63_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-64_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-68_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-99_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-105_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-107_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-108_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-111_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-112_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-115_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-116_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-118_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-133_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-135_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-136_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-137_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-145_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-179_03-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-180_03-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-189_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-227_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-307_26-Mar-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-324_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-335_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-403_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-411_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-429_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-443_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-444_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-446_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-448_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-459_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-461_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-462_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-467_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-485_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-486_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-500_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-501_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-502_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-503_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-504_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-505_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-506_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-513_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-518_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-526_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-633_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-634_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-646_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-654_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-655_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-663_09-Apr-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-664_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-680_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-704_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-705_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-706_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-707_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-725_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-726_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-728_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-733_09-Apr-2022.mat';
% ReadFile_name               = 'ECOBASE_model-734_09-Apr-2022.mat'; % GOOD (increased fish flow from detritus to discards by 1% to balance)
% ReadFile_name               = 'ECOBASE_model-735_09-Apr-2022.mat'; % GOOD (increased fish flow from detritus to discards by 1% to balance)
% ReadFile_name               = 'ECOBASE_model-736_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-737_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-738_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-742_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-751_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-752_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-753_09-Apr-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-754_09-Apr-2022.mat'; % GOOD
% -------------------------------------------------------------------------


% Pacific models ----------------------------------------------------------
% ReadFile_directory          = '/1_ECOBASE_queries/ECOBASE_Pacific/';

% ReadFile_name               = 'ECOBASE_model-2_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-42_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-172_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-175_26-Mar-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-239_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-242_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-252_26-Mar-2022.mat'; 
% ReadFile_name               = 'ECOBASE_model-266_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-267_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-282_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-305_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-311_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-312_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-325_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-328_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-410_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-417_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-436_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-438_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-439_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-450_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-465_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-466_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-477_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-478_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-479_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-487_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-488_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-489_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-490_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-499_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-519_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-637_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-658_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-674_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-675_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-677_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-682_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-703_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-711_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-730_26-Mar-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-741_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-756_26-Mar-2022.mat';
% -------------------------------------------------------------------------


% % Other Region models ---------------------------------------------------
% ReadFile_directory          = '/1_ECOBASE_queries/ECOBASE_OtherRegions/';

% ReadFile_name               = 'ECOBASE_model-24_10-Sep-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-46_11-Sep-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-53_11-Sep-2022.mat'; % GOOD
% ReadFile_name               = 'ECOBASE_model-153_11-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-168_11-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-217_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-218_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-232_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-240_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-241_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-243_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-246_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-247_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-269_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-291_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-305_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-318_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-320_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-323_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-400_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-401_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-405_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-412_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-414_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-431_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-433_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-434_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-435_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-441_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-452_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-456_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-464_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-465_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-466_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-468_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-473_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-495_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-496_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-497_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-520_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-522_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-608_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-650_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-651_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-669_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-687_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-689_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-691_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-692_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-693_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-727_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-729_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-731_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-739_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-740_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-743_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-745_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-746_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-748_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-749_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-750_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-755_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-758_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-759_10-Sep-2022.mat';
% -------------------------------------------------------------------------


% PROBLEM MODELS ----------------------------------------------------------
% ReadFile_name               = 'ECOBASE_model-34_09-Apr-2022.mat';
% ReadFile_name               = 'ECOBASE_model-48_11-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-58_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-125_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-183_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-221_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-279_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-289_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-298_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-406_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-407_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-413_09-Apr-2022.mat';
% ReadFile_name               = 'ECOBASE_model-415_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-432_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-447_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-457_09-Apr-2022.mat';
% ReadFile_name               = 'ECOBASE_model-521_26-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-537_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-567_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-568_04-Jul-2023.mat';
% ReadFile_name               = 'ECOBASE_model-732_25-Mar-2022.mat';
% ReadFile_name               = 'ECOBASE_model-733_09-Apr-2022.mat';
% ReadFile_name               = 'ECOBASE_model-744_10-Sep-2022.mat';
% ReadFile_name               = 'ECOBASE_model-757_10-Sep-2022.mat';
% -------------------------------------------------------------------------


ReadFile                    = [ReadFile_directory ReadFile_name];

ExcelFile_directory         = '/Matlab_script/';
blankExcelFile_name         = 'FLOGTWOPI_03252022.xlsm';
BlankFile                   = [ExcelFile_directory blankExcelFile_name];

SaveFile_directory          = '/2_VisualBasic_versions/';
% *************************************************************************



% *************************************************************************
% STEP 2: load and prep Ecobase parameters---------------------------------
% step 2a: load and unpack current Ecobase model --------------------------
load(ReadFile, 'PackedModel')

% unpack variables
model_info_table            = PackedModel.model_info_table;     % (vertical vector: num_grps X 1)
parameter_table             = PackedModel.parameter_table; % (2D matrix: num_grps X 11)
parameter_table_label       = PackedModel.parameter_table_label; % (horizontal vector: 1 X 10)
group_label_table           = PackedModel.group_label_table; % (vertical vector: num_grps X 1)
diet_table                  = PackedModel.diet_table; % (2D matrix: (num_grps+1) X num_grps)
detritus_fate_table         = PackedModel.detritus_fate_table; % (2D matrix: num_grps X num_detritus)
detritus_fate_label         = PackedModel.detritus_fate_label; % (horizontal vector: 1 X num_detritus)
supp_parameter_table        = PackedModel.supp_parameter_table; % (2D matrix: num_grps X 11)
supp_parameter_table_label	= PackedModel.supp_parameter_table_label; % (horizontal vector: 1 X 11)
fleet_label                 = PackedModel.fleet_label; 	% (horizontal vector: 1 X num_fleets)
fleet_info_table            = PackedModel.fleet_info_table; % (2D matrix: 4 X num_fleets)
fleet_info_label            = PackedModel.fleet_info_label; % (horizontal vector: 1 X 4)
fleet_prop_mort_table       = PackedModel.fleet_prop_mort_table; % (2D matrix: num_grps X num_fleets)
fleet_market_table          = PackedModel.fleet_market_table; % (2D matrix: num_grps X num_fleets)
fleet_total_landings_table	= PackedModel.fleet_total_landings_table; % (2D matrix: num_grps X num_fleets)
fleet_discards_table        = PackedModel.fleet_discards_table; % (2D matrix: num_grps X num_fleets)
fleet_other_temp            = PackedModel.fleet_other_temp; % NOTE: probably and should be all empty; (2D matrix: num_grps X num_fleets)

parameter_table             = parameter_table(:, 1:10); % trim off any inadvertant extra column of 0 in parameter_table
looky_bad                   = find(parameter_table == -9999); % set missing (-9999) values to 0
parameter_table(looky_bad)	= 0;

if exist('PackedModel.fleet_discards_fate', 'var')
    fleet_discards_fate = PackedModel.fleet_discards_fate;
else
    fleet_discards_fate = [];
end
%--------------------------------------------------------------------------


% step 2b: set save file name ---------------------------------------------
model_number                = model_info_table{1, 2};
SaveFile                    = [SaveFile_directory 'ECOTRAN_Ecobase-' num2str(model_number) '_' date() '.xlsm'];
%--------------------------------------------------------------------------


% step 2c: get group numbers and find addresses ---------------------------
EwEgrp_type                 = parameter_table(:, 2);
looky_primaryproducer       = find(EwEgrp_type == 1);
looky_detritus              = find(EwEgrp_type == 2);

num_grps                    = model_info_table{9, 2};
num_fleets                  = model_info_table{10, 2};
num_detritus                = length(looky_detritus);
num_primaryproducer         = length(looky_primaryproducer);

%--------------------------------------------------------------------------


% step 2d: read in ECOTRAN name and group type definitions ----------------
% (NameTranslator_Ecobase_04042022.xlsx)
NameTranslator_directory	= '/4_Metadata/';
NameTranslator_file         = 'EcoBase_nametranslator_08122023.mat';
load([NameTranslator_directory NameTranslator_file], 'ecobase_nametranslator')
% *************************************************************************



% *************************************************************************
% STEP 3: assign ECOTRAN definitions---------------------------------------

% step 3a: 
% looky addresses for group types
GroupTypeDef_ANYPrimaryProd     = 2;
GroupTypeDef_ANYDetritus        = 4;
GroupTypeDef_terminalPlgcDetr	= 4.1;
GroupTypeDef_discardDetr        = 4.2;
GroupTypeDef_terminalBnthDetr	= 4.3;
GroupTypeDef_fleets             = 5;

% assign ecotran names
current_ecobase_name            = cell(num_grps, 1); % initialize
current_ECOTRAN_type            = zeros(num_grps, 1); % initialize
current_ecotype               	= cell(num_grps, 1); % initialize
current_group_name              = cell(num_grps, 1); % initialize
current_major_class             = cell(num_grps, 1); % initialize
current_environment_type        = cell(num_grps, 1); % initialize
current_watercolumn_environment	= cell(num_grps, 1); % initialize
current_notes                   = cell(num_grps, 1); % initialize


for grp_loop = 1:num_grps

    current_ecobase_name(grp_loop)	= group_label_table(grp_loop);
	looky_current_grp               = find(strcmp(ecobase_nametranslator.ecobase_name, current_ecobase_name(grp_loop)) == 1);

    if ~isempty(looky_current_grp)
        current_ECOTRAN_type(grp_loop)              = ecobase_nametranslator.ECOTRAN_type(looky_current_grp);
        current_ecotype(grp_loop)                   = ecobase_nametranslator.ecotype(looky_current_grp);
        current_group_name(grp_loop)                = ecobase_nametranslator.group_name(looky_current_grp);
        current_major_class(grp_loop)               = ecobase_nametranslator.major_class(looky_current_grp);
        current_environment_type(grp_loop)          = ecobase_nametranslator.environment_type(looky_current_grp);
        current_watercolumn_environment(grp_loop)	= ecobase_nametranslator.watercolumn_environment(looky_current_grp);
        current_notes(grp_loop)                     = ecobase_nametranslator.notes(looky_current_grp);
    end % (~isempty(looky_current_grp))

end % (grp_loop)
% *************************************************************************



% *************************************************************************
% STEP 4: build detritus fate table----------------------------------------



% step 4a: identify terminal pelagic detritus -----------------------------


% 9/7/2022 --------
% make sure terminal benthic detritus fate gets exported
% make sure the major primary producer group feeds into terminal pelagic detritus pool


% look to see if there is a designated pelagic detritus group
looky_pelagicDetritus = find(current_ECOTRAN_type == GroupTypeDef_terminalPlgcDetr); % group row of any defined terminalPlgcDetr
looky_benthicDetritus = find(current_ECOTRAN_type == GroupTypeDef_terminalBnthDetr); % group row of any defined terminalBnthDetr

looky_pelagicDetritus_clm = find(current_ECOTRAN_type(looky_detritus) == GroupTypeDef_terminalPlgcDetr); % detritus fate clm of any defined terminalPlgcDetr
looky_benthicDetritus_clm = find(current_ECOTRAN_type(looky_detritus) == GroupTypeDef_terminalBnthDetr); % group row of any defined terminalBnthDetr

% identify by detritus fate of most productive primary producer
PrimaryProducer_productionRate      = parameter_table(looky_primaryproducer, 3) .* parameter_table(looky_primaryproducer, 4);
looky_PrimaryProducer_max        	= find(PrimaryProducer_productionRate == max(PrimaryProducer_productionRate)); % the most productive primary producer is probably a phytoplankton group
% PrimaryProducer_label               = group_label_table(looky_ANYPrimaryProd);
% looky_MainPrimaryProducer           = looky_primaryproducer(looky_PrimaryProducer_max(1)); % choose first max in case of ties
looky_MainPrimaryProducer           = looky_primaryproducer(looky_PrimaryProducer_max); % may be ties

MainPrimaryProducer_detritus_fate	= detritus_fate_table(looky_MainPrimaryProducer(1), :); % choose first max in case of ties; (horizontal vector: 1 X num_detritus)
looky_PrimaryProducer_detritus      = find(MainPrimaryProducer_detritus_fate == max(MainPrimaryProducer_detritus_fate)); % detritus number (clm) of potential terminalPlgcDetr based on fate of majr primary producer

PrimaryProducer_detritus_type = current_ECOTRAN_type(looky_detritus(looky_PrimaryProducer_detritus(1)));

if isempty(looky_pelagicDetritus)
    % if there is not already a defined terminalPlgcDetr pool, assign it now
    current_ECOTRAN_type(looky_detritus(looky_PrimaryProducer_detritus(1))) = GroupTypeDef_terminalPlgcDetr; % choose first looky_PrimaryProducer_detritus in case of ties
elseif (looky_detritus(looky_PrimaryProducer_detritus(1))) ~= looky_pelagicDetritus
    % if the fate of MainPrimaryProducer does not go to the already existing terminal pelagic detritus pool, make it do so 
    detritus_fate_table(looky_MainPrimaryProducer, looky_pelagicDetritus_clm) = detritus_fate_table(looky_MainPrimaryProducer, looky_PrimaryProducer_detritus);
    detritus_fate_table(looky_MainPrimaryProducer, looky_PrimaryProducer_detritus) = 0;
end

% -------------------------------------------------------------------------

% step 4b: identify terminal benthic detritus -----------------------------
%          identify by detritus fate of most productive benthic group
% make sure there are 2 terminal detritus groups
looky_undefinedDetritus = find(current_ECOTRAN_type(looky_detritus) == 4); % potential terminal benthic detritus groups (those not already classed as 4.1 or 4.2; only types 4.1 & 4.2 have been defined previously)

if isempty(looky_undefinedDetritus) % append a new detritus group if there is no potential terminal benthic detritus group
    group_label_table{end+1}	= 'detritus_TerminalBenthic'; % add a detritus group
    num_grps                    = num_grps + 1;
    num_detritus                = num_detritus + 1;
    parameter_table((end+1), :) = [num_grps 2	5	0	0	0	0	0	0	0]; % QQQ may need to set detritus ee to 0.8 or 0?
    
    % add to diet table
    diet_table_import           = diet_table(end, :);
    diet_table(end, :)          = 0; % append new "detritus 2 ecotran" group
    diet_table((end+1), :)      = diet_table_import;
    diet_table(:, (end+1))      = 0; % append new "detritus 2 ecotran" group
    
    % add to detritus fate table
    detritus_fate_label{(end+1)}            = 'detritus_TerminalBenthic'; % add 1 detritus group
    looky_detritus(end+1)                   = num_grps; % add 1 detritus group
    
    detritus_fate_table((end+1), :)         = 0; % append a row of 0 for new "detritus 2 ecotran" group
    detritus_fate_table(:, (end+1))         = 0; % append a column of 0 for new "detritus 2 ecotran" group
    
    % add to current_ECOTRAN_type vector
    current_ECOTRAN_type(end+1)             = 4.3; % define the NEWLY added detritus group as terminal benthic detritus
    
    % add to "Fishing" & "Discards" table
    fleet_total_landings_table((end+1), :)	= 0; % add row for detritus_TerminalBenthic
    fleet_discards_table((end+1), :)        = 0; % add row for detritus_TerminalBenthic
    
else
    
    looky_BenthicGroup                  = find(current_ECOTRAN_type >= 3.2 & current_ECOTRAN_type < 4);
    
    if ~isempty(looky_BenthicGroup)
        BenthicGroup_productionRate         = parameter_table(looky_BenthicGroup, 3) .* parameter_table(looky_BenthicGroup, 4);
        looky_max                           = find(BenthicGroup_productionRate == max(BenthicGroup_productionRate)); % the most productive primary producer is probably a phytoplankton group
        % BenthicGroup_label                  = group_label_table(looky_BenthicGroup);
        looky_MainBenthicGroup             	= looky_BenthicGroup(looky_max(1)); % choose first max in case of ties

        MainBenthicGroup_detritus_fate      = detritus_fate_table(looky_MainBenthicGroup, :);
        looky_max                           = find(MainBenthicGroup_detritus_fate == max(MainBenthicGroup_detritus_fate)); 
        current_ECOTRAN_type(looky_detritus(looky_max(1))) = 4.3; % choose first max in case of ties

    else
        
        current_ECOTRAN_type(looky_detritus(looky_undefinedDetritus(end))) = 4.3; % assume the last undefined detritus group is terminal benthic detritus
        
    end % ( if ~isempty(looky_BenthicGroup))
        
end % (if num_detritus < 2)
% -------------------------------------------------------------------------

% NOTE: fleet flows to detritus added below
% NOTE: flows between detritus pools set below
% *************************************************************************



% *************************************************************************
% STEP 5: prep "Diet" tab -------------------------------------------------
%          NOTE: this step comes AFTER detritus tab is built in case detritus groups need to be added
diet_label_table                = group_label_table; % make a new group lable table to which "import" diet label is added
diet_label_table{end+1}         = 'Import'; % add "import" diet label

% normalize diet matrix for columns to sum to 1
sum_diet                        = sum(diet_table, 1);
diet_table                      = diet_table ./ sum_diet;
diet_table(isnan(diet_table))	= 0; % correct for div/0 errors
% *************************************************************************



% *************************************************************************
% STEP 6: append fleets to parameters, labels, & discards------------------
% step 6a: append fleets to parameter_table & main_label_table ------------
main_label_table            = group_label_table; % make a new group lable table to add to the FLOGTWOPI mains tab (fleet labels added below)

if num_fleets > 0
    looky_fleets                        = (num_grps+1):(num_grps+num_fleets);
    main_label_table(looky_fleets)      = fleet_label;
    fleet_params                        = [0	3	0	0	0	0	0	0	0	0];
    fleet_params                        = repmat(fleet_params, [num_fleets, 1]);
    fleet_params(1:num_fleets, 1)       = looky_fleets;
    parameter_table(looky_fleets, :)	= fleet_params;
    current_ECOTRAN_type(looky_fleets)	= GroupTypeDef_fleets;
else
    looky_fleets = [];
end % (if num_fleets > 0)
% -------------------------------------------------------------------------


% step 6b: add fleet flows to detritus fates  -----------------------------
if ~isempty(fleet_discards_fate)
    detritus_fate_table(looky_fleets, :) = fleet_discards_fate;
else
    % assign fleet detritus to discard type 4.2, else to benthic detritus type 4.3
    looky_DiscardDetritus_TableClm          = find(current_ECOTRAN_type(looky_detritus) == 4.2); % column address in detritus fate table
    looky_TerminalBenthicDetritus_TableClm	= find(current_ECOTRAN_type(looky_detritus) == 4.3); % column address in detritus fate table

    if ~isempty(looky_DiscardDetritus_TableClm)
        detritus_fate_table((end+1):(end+num_fleets), looky_DiscardDetritus_TableClm) = 1;
    else
        detritus_fate_table((end+1):(end+num_fleets), looky_TerminalBenthicDetritus_TableClm) = 1;
    end % (if ~isempty(looky_DiscardDetritus_TableClm))
end % (if ~isempty(fleet_discards_fate))
% -------------------------------------------------------------------------


% step 6c: clean up temporary variables -----------------------------------
clear fleet_params
% *************************************************************************



% *************************************************************************
% STEP 7: set flows between detritus groups--------------------------------
detritus_fate_table(:, (end+1))         = 0; % add export column to detritus fate table
detritus_fate_table(:, (end+1))         = 0; % add sum column to detritus fate table
detritus_fate_label{(end+1)}            = 'export';
detritus_fate_label{(end+1)}            = 'sum';

looky_TerminalPelagicDetritus           = find(current_ECOTRAN_type == 4.1);
looky_TerminalBenthicDetritus           = find(current_ECOTRAN_type == 4.3);

% set 100% of unused terminal pelagic detritus flow to terminal benthic detritus
detritus_fate_table(looky_TerminalPelagicDetritus, :) = 0;
detritus_fate_table(looky_TerminalPelagicDetritus, looky_TerminalBenthicDetritus_TableClm) = 1;

% all terminal benthic detritus goes to export
detritus_fate_table(looky_TerminalBenthicDetritus, (end-1)) = 1; 

% set any unaccounted detritus fate to export
sum_detritus_fate               = sum(detritus_fate_table, 2);
detritus_fate_table(:, (end-1)) = detritus_fate_table(:, (end-1)) + (1 - sum_detritus_fate);

% set sum column of detritus fate table (all rows should be = 1)
sum_detritus_fate               = sum(detritus_fate_table, 2);
detritus_fate_table(:, end)     = sum_detritus_fate;
% *************************************************************************



% *************************************************************************
% STEP 8: prep "Fishing" & "Discard" tabs----------------------------------
fleet_total_landings_table(:, (end+1))	= 0; % add sum column to fleet_total_landings_table
fleet_discards_table(:, (end+1))        = 0; % add sum column to fleet_discards_table

fleet_label{(end+1)}                    = 'TOTAL'; % sum column label

fleet_total_landings_table(:, end)      = sum(fleet_total_landings_table, 2);
fleet_discards_table(:, end)            = sum(fleet_discards_table, 2);
% *************************************************************************



% *************************************************************************
% STEP 9: prep "pedigree_Parameters" tab-----------------------------------
pedigree_Parameters_table                           = zeros(num_grps, 6);
pedigree_Parameters_table(:, 1)                     = 0.98; % max ee
pedigree_Parameters_table(:, 2)                     = 0.80; % b
pedigree_Parameters_table(:, 3)                     = 0.80; % pb
pedigree_Parameters_table(:, 4)                     = 0.80; % qb
pedigree_Parameters_table(:, 5)                     = 0.25; % pq
pedigree_Parameters_table(:, 6)                     = 0.05; % ae

pedigree_Parameters_table(looky_primaryproducer, 4)	= 0; % set primary producer CV to 0
pedigree_Parameters_table(looky_primaryproducer, 5)	= 0; % set primary producer CV to 0
pedigree_Parameters_table(looky_primaryproducer, 6)	= 0; % set primary producer CV to 0

pedigree_Parameters_table(looky_detritus, 3)        = 0; % set detritus CV to 0
pedigree_Parameters_table(looky_detritus, 4)        = 0; % set detritus CV to 0
pedigree_Parameters_table(looky_detritus, 5)        = 0; % set detritus CV to 0
pedigree_Parameters_table(looky_detritus, 6)        = 0; % set detritus CV to 0
% *************************************************************************



% *************************************************************************
% STEP 10: prep "pedigree_Diet" & "pedigree_DietPrefRules" tabs=-----------
pedigree_Diet_table                                 = zeros((num_grps+1), num_grps); % initialize
pedigree_DietPrefRules_table                        = zeros((num_grps+1), num_grps); % initialize
looky_affimativeDiet                                = find(diet_table > 0);
pedigree_Diet_table(looky_affimativeDiet)           = 0.8;
pedigree_DietPrefRules_table(looky_affimativeDiet)	= 1;
% *************************************************************************



% *************************************************************************
% STEP 11: prep "pedigree_Landings" & "pedigree_Discards" tabs-------------
pedigree_Landings_table                             = zeros(num_grps, num_fleets); % initialize
pedigree_Discards_table                         	= zeros(num_grps, num_fleets); % initialize
total_CATCH                                         = fleet_total_landings_table(:, 1:(end-1)) + fleet_discards_table(:, 1:(end-1));
looky_affimativeCATCH                             	= find(total_CATCH > 0);
pedigree_Landings_table(looky_affimativeCATCH)      = 0.8;
pedigree_Discards_table(looky_affimativeCATCH)   	= 0.8;
% *************************************************************************



% *************************************************************************
% STEP 12: prep "EcotranType" tab------------------------------------------
num_rows                                = (num_grps + num_fleets + 2);
EcotranType_table                       = zeros(num_rows, 3);

EcotranType_table_label                 = main_label_table;
EcotranType_table_label{end+1}          = 'biomass accumulation';
EcotranType_table_label{end+1}          = 'emigration';
current_ECOTRAN_type(end+1)             = 6.1;
current_ECOTRAN_type(end+1)             = 6.2;
Ecotran_number                          = 4:1:(3 + num_rows);

EcotranType_table(:, 1)                 = Ecotran_number';
EcotranType_table(:, 2)                 = current_ECOTRAN_type;
EcotranType_table(:, 3)                 = Ecotran_number';
% *************************************************************************



% *************************************************************************
% STEP 13: prep "EcotranRecycling" tab-------------------------------------
% step 13a: prep recycling table ------------------------------------------
EcotranRecycling_table                              = zeros((num_grps+num_fleets), 12);
RecyclingFate_build                                 = zeros((num_grps+num_fleets), 2);

looky_TerminalPelagicDetritus_TableClm              = find(current_ECOTRAN_type(looky_detritus) == 4.1);

RecyclingFate_build(:, 1)                           = detritus_fate_table(:, looky_TerminalPelagicDetritus_TableClm);
RecyclingFate_build(:, 2)                           = 1 - RecyclingFate_build(:, 1);

RecyclingFate_feces                                 = RecyclingFate_build;
RecyclingFate_feces(looky_primaryproducer, :)       = repmat([0 0], [num_primaryproducer, 1]);
RecyclingFate_feces(looky_fleets, :)                = repmat([0 1], [num_fleets, 1]);

RecyclingFate_senescence                            = RecyclingFate_build;
RecyclingFate_senescence(looky_fleets, :)           = repmat([0 0], [num_fleets, 1]);

RecyclingFate_excretion                             = RecyclingFate_build;
RecyclingFate_excretion(looky_primaryproducer, :)	= repmat([0 0], [num_primaryproducer, 1]);
RecyclingFate_excretion(looky_fleets, :)            = repmat([0 0], [num_fleets, 1]);

looky_TerminalPelagicDetritusm                      = find(current_ECOTRAN_type == 4.1);

RecyclingFate_ProductionLoss                        = zeros((num_grps+num_fleets), 1);
RecyclingFate_Retention                             = ones((num_grps+num_fleets), 1);
RecyclingFate_feces(looky_primaryproducer)          = 0;
RecyclingFate_feces(looky_TerminalPelagicDetritusm)	= 0;

EcotranRecycling_table(:, 5:6)                      = RecyclingFate_feces;
EcotranRecycling_table(:, 7:8)                      = RecyclingFate_senescence;
EcotranRecycling_table(:, 9:10)                     = RecyclingFate_excretion;
EcotranRecycling_table(:, 11)                       = RecyclingFate_ProductionLoss;
EcotranRecycling_table(:, 12)                       = RecyclingFate_Retention;
% -------------------------------------------------------------------------

% step 13b: prep NO3 & NH4 distribution among primary producers -----------
biomass_PrimaryProducers                            = parameter_table(looky_primaryproducer, 3);
pb_PrimaryProducers                                 = parameter_table(looky_primaryproducer, 4);
production_PrimaryProducers                         = biomass_PrimaryProducers .* pb_PrimaryProducers;
total_PrimaryProduction                             = sum(production_PrimaryProducers, 1);
fraction_PrimaryProduction                          = production_PrimaryProducers ./ total_PrimaryProduction;
fraction_PrimaryProduction(isnan(fraction_PrimaryProduction)) = 0; % correct for div/0 error (should be none)

nutrient_distribution_table                         = [biomass_PrimaryProducers pb_PrimaryProducers production_PrimaryProducers fraction_PrimaryProduction];
PrimaryProducer_label                               = group_label_table(looky_primaryproducer);
% *************************************************************************



% *************************************************************************
% STEP 14: prep "FunctionalResponse" tab-----------------------------------
FunctionalResponse_table        = zeros((num_grps+num_fleets), 1);
% *************************************************************************



% *************************************************************************
% STEP 15: build group type count table for "Main" tab---------------------
counts_table                    = [(num_grps-num_detritus); num_detritus; num_fleets];
group_count_vector              = 1:1:num_grps;
% *************************************************************************



% *************************************************************************
% STEP 16: write to the Aydin excel VisualBasic macro----------------------
% step 16a: create a new FLOGTWOPI macro and add parameters ---------------
copyfile(BlankFile, SaveFile)
% -------------------------------------------------------------------------

% step 16b: write model information to the "Read Me" tab ------------------
writecell(model_info_table,                 SaveFile, 'Sheet', 'Read Me', 'Range', 'B53')
% -------------------------------------------------------------------------

% step 16c: write to "Main" tab -------------------------------------------
writematrix(counts_table,                   SaveFile, 'Sheet', 'Main', 'Range', 'B3')
writematrix(parameter_table(:, 1),          SaveFile, 'Sheet', 'Main', 'Range', 'C2')
writecell(main_label_table,                 SaveFile, 'Sheet', 'Main', 'Range', 'E2')
writematrix(parameter_table(:, 2:10),       SaveFile, 'Sheet', 'Main', 'Range', 'F2')
% -------------------------------------------------------------------------

% step 16d: write to the "Diets" tab --------------------------------------
writecell(diet_label_table,                 SaveFile, 'Sheet', 'Diets', 'Range', 'A2')
writecell(group_label_table',               SaveFile, 'Sheet', 'Diets', 'Range', 'B1')
writematrix(diet_table,                     SaveFile, 'Sheet', 'Diets', 'Range', 'B2')
% -------------------------------------------------------------------------

% step 16e: write to the "Detritus" tab -----------------------------------
writematrix(parameter_table(:, 1),          SaveFile, 'Sheet', 'Detritus', 'Range', 'A2')
writecell(main_label_table,                 SaveFile, 'Sheet', 'Detritus', 'Range', 'B2')
writecell(detritus_fate_label,              SaveFile, 'Sheet', 'Detritus', 'Range', 'C1')
writematrix(detritus_fate_table,            SaveFile, 'Sheet', 'Detritus', 'Range', 'C2')
% -------------------------------------------------------------------------

% step 16f: write to the "Fishing" & "Discards" tabs ----------------------
writematrix(group_count_vector',            SaveFile, 'Sheet', 'Fishing', 'Range', 'A2')
writecell(group_label_table,                SaveFile, 'Sheet', 'Fishing', 'Range', 'B2')
writecell(fleet_label,                      SaveFile, 'Sheet', 'Fishing', 'Range', 'C1')
writematrix(fleet_total_landings_table,     SaveFile, 'Sheet', 'Fishing', 'Range', 'C2')

writematrix(group_count_vector',            SaveFile, 'Sheet', 'Discards', 'Range', 'A2')
writecell(group_label_table,                SaveFile, 'Sheet', 'Discards', 'Range', 'B2')
writecell(fleet_label,                      SaveFile, 'Sheet', 'Discards', 'Range', 'C1')
writematrix(fleet_discards_table,           SaveFile, 'Sheet', 'Discards', 'Range', 'C2')
% -------------------------------------------------------------------------

% step 16g: write to the "pedigree_Parameters" tab ------------------------
writematrix(group_count_vector',            SaveFile, 'Sheet', 'pedigree_Parameters', 'Range', 'D2')
writecell(group_label_table,                SaveFile, 'Sheet', 'pedigree_Parameters', 'Range', 'E2')
writematrix(pedigree_Parameters_table,      SaveFile, 'Sheet', 'pedigree_Parameters', 'Range', 'F2')
% -------------------------------------------------------------------------

% step 16h: write to the "pedigree_Diet" & "pedigree_DietPrefRules" tabs --
writecell(diet_label_table,                 SaveFile, 'Sheet', 'pedigree_Diet', 'Range', 'A2')
writecell(group_label_table',               SaveFile, 'Sheet', 'pedigree_Diet', 'Range', 'B1')
writematrix(pedigree_Diet_table,            SaveFile, 'Sheet', 'pedigree_Diet', 'Range', 'B2')

writecell(diet_label_table,                 SaveFile, 'Sheet', 'pedigree_DietPrefRules', 'Range', 'A2')
writecell(group_label_table',               SaveFile, 'Sheet', 'pedigree_DietPrefRules', 'Range', 'B1')
writematrix(pedigree_DietPrefRules_table,	SaveFile, 'Sheet', 'pedigree_DietPrefRules', 'Range', 'B2')
% -------------------------------------------------------------------------

% step 16i: write to the "pedigree_Landings" & "pedigree_Discards" tabs ---
writematrix(group_count_vector',            SaveFile, 'Sheet', 'pedigree_Landings', 'Range', 'A2')
writecell(group_label_table,                SaveFile, 'Sheet', 'pedigree_Landings', 'Range', 'B2')
writecell(fleet_label(1:(end-1)),        	SaveFile, 'Sheet', 'pedigree_Landings', 'Range', 'C1')
writematrix(pedigree_Landings_table,        SaveFile, 'Sheet', 'pedigree_Landings', 'Range', 'C2')

writematrix(group_count_vector',            SaveFile, 'Sheet', 'pedigree_Discards', 'Range', 'A2')
writecell(group_label_table,                SaveFile, 'Sheet', 'pedigree_Discards', 'Range', 'B2')
writecell(fleet_label(1:(end-1)),        	SaveFile, 'Sheet', 'pedigree_Discards', 'Range', 'C1')
writematrix(pedigree_Discards_table,       	SaveFile, 'Sheet', 'pedigree_Discards', 'Range', 'C2')
% -------------------------------------------------------------------------

% step 16j: write to the "EcotranType" tab --------------------------------
writecell(EcotranType_table_label,      	SaveFile, 'Sheet', 'EcotranType', 'Range', 'D5')
writecell(EcotranType_table_label,      	SaveFile, 'Sheet', 'EcotranType', 'Range', 'H5')
writematrix(EcotranType_table,            	SaveFile, 'Sheet', 'EcotranType', 'Range', 'E5')
% -------------------------------------------------------------------------

% step 16k: write to the "EcotranRecycling" tab ---------------------------
writecell(main_label_table,                 SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'F6')
writematrix(EcotranRecycling_table,      	SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'G6')

writematrix(nutrient_distribution_table,	SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'B32')
writematrix(fraction_PrimaryProduction,     SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'B8')
writematrix(fraction_PrimaryProduction,     SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'B19')

writecell(PrimaryProducer_label,         	SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'C8')
writecell(PrimaryProducer_label,         	SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'C19')
writecell(PrimaryProducer_label,         	SaveFile, 'Sheet', 'EcotranRecycling', 'Range', 'A32')
% -------------------------------------------------------------------------

% step 16L: write to the "FunctionalResponse" tab -------------------------
writecell(main_label_table,                 SaveFile, 'Sheet', 'FunctionalResponse', 'Range', 'A5')
writecell(main_label_table',              	SaveFile, 'Sheet', 'FunctionalResponse', 'Range', 'I1')
writematrix(FunctionalResponse_table,      	SaveFile, 'Sheet', 'FunctionalResponse', 'Range', 'B5')
% *************************************************************************


% end m-file***************************************************************