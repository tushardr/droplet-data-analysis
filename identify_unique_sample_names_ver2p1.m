function unique_sample_names=identify_unique_sample_names_ver2p1(data_folder,varargin)
% unique_sample_names=identify_unique_sample_names_ver2p1(data_folder,varargin)
% varargin(1) = '*.txt' , varargin(2) = '-ch\d*-\d*.txt'

cd(data_folder)

if nargin>1
    all_filenames=ls(varargin{1});
else
    all_filenames=ls('*.txt');
end

all_filenames=cellstr(all_filenames); % character array to cell array conversion for easy use in functions

if nargin>2
    pattern_to_match=varargin{2};
else
    pattern_to_match='-ch\d*-\d*.txt';
end

% find the '-ch1-1.txt' pattern in all filenames. strip them of it and find the unique names
pattern_location=regexpi(all_filenames,pattern_to_match);
% Any filenames which don't contain the pattern are not sample related
% files so remove them from the pool of files for searching unique sample names
sample_related_filenames=all_filenames(~cellfun(@isempty,pattern_location));  
% remove the pattern from the sample related filenames before searching for
% unique sample names
sample_related_filenames=regexprep(sample_related_filenames,pattern_to_match,'');

unique_sample_names=unique(sample_related_filenames);