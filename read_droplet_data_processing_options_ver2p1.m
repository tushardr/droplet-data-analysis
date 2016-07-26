function data_processing_options=read_droplet_data_processing_options_ver2p1(data_processing_options_file)

%******************************************************************************************
% go to the data directory and open the data processing options file
options_fid=fopen(data_processing_options_file);
%******************************************************************************************

%******************************************************************************************
% loop through all the lines in the file to collect the parameter names and
% their values
while 1
	% read a line from the options file
	read_line=fgetl(options_fid);	
	if length(read_line)<2|~ischar(read_line) %odd way to check for empty line
		break; % stop reading if the line is empty or if we reached the end of file
	else
		comment_position=strfind(read_line,'//'); % check if any comments present on line
		if comment_position==1
			continue;
		else
			if ~isempty(comment_position) % try to strip the comment off only if it is present!
				read_line=read_line(1:(comment_position-1));
			end
			% separate the parameter and its value , using the separator ':'
			% also strip the resulting string of any leading and trailing blanks
			[param,value]=strtok(read_line,':'); % using strtrim here doesn't work
			value=value(2:end); % remove the marker ':' from the string 'value'
			param=strtrim(param);
			value=strtrim(value); 
			if ~isempty(str2num(value))
		        	% if the value of the parameter is numeric, store it in numeric form   	
				eval(strcat(['data_processing_options.' param '=[' num2str(str2num(value)) '];']));
			else
				% if the parameter is a string, store in a string form
				% need to use '' inside single quotes to get a single quote inside a string
				eval(strcat(['data_processing_options.' param '=''' value ''';']));
			end
		end
	end
end % while loop
%******************************************************************************************
