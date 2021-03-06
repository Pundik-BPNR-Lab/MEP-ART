function save_and_close_sici(source, event, app)


if ~any(strcmp(properties(app), 'SaveLocationEditField')) 
	[pname, ~, ~] = fileparts(app.EMGDataTxtEditField.Value);
	save_loc = pname;
	% if the current directory has '/data/' in it then change it
	% '/analysis/' to save the output there
	if contains(save_loc, '/data/', 'IgnoreCase', true)
		save_loc = strrep(lower(save_loc), '/data/', '/analysis/');
		% ask to create the folder if it doesn't exist
		if ~exist(save_loc, 'dir')
			ButtonName = questdlg(['Create new directory: ' save_loc ' ?'], ...
                         'Create new directory', ...
                         'Yes', 'No', 'Yes');
			if strcmp(ButtonName, 'Yes')
				[success, msg, msg_id] = mkdir(save_loc);
			else
				disp('Choose where to save output')
				save_loc = uigetdir();
			end
		end
	end
	fname_prefix = '';
else
	if isempty(app.SaveLocationEditField.Value)
		app.SaveLocationEditField.Value = pwd;
		save_loc = pwd;
	else
		save_loc = app.SaveLocationEditField.Value;
	end
	fname_prefix = app.EditFieldFilenameprefix.Value;
end

% determine mep method
if isprop(app,'emg_data_fig')
	rb_mep_ampl = findobj(app.emg_data_fig, 'Tag', 'rb_mep_ampl');
	if rb_mep_ampl.Value
		mep_method = 'ampl';
	else
		mep_method = 'auc';
	end
else
	mep_method = 'ampl';
end

% determine base filename for saving datapoints.csv & fitinfo.txt
title_str = strrep(app.sici_axes.Title.String, ' ', '_');
if contains(title_str, '.csv') % it's a file read in, no need to add prefix
	datapoint_fname = title_str;
	sici_info_fname = strrep(title_str, 'sici_datapoints.csv', 'sici_info.txt');
else
	datapoint_fname = [save_loc '/' fname_prefix title_str '_sici_datapoints.csv'];
	sici_info_fname = [save_loc '/' fname_prefix title_str '_' mep_method '_sici_info.txt'];
end

[confirm_saving, datapoint_fname] = confirm_savename(datapoint_fname);


if confirm_saving
	% save the data
	try
		save_rc_table(app.sici_axes.UserData, datapoint_fname)
	catch ME
		disp('did not save sici_datapoints')
		disp(ME)
	end
end % confirmed saving

if isfield(app.sici_info, 'ts_n')
	
	[confirm_saving, sici_info_fname] = confirm_savename(sici_info_fname);

	% get the TS & CS values
	app.sici_info.ts_value = str2double(app.sici_ui.ts.String);
	app.sici_info.cs_value = str2double(app.sici_ui.cs.String);
	if confirm_saving
		try
			write_fit_info(sici_info_fname, app.sici_info)
			catch ME
			disp('did not save sici_info')
			disp(ME)
		end
	end
end	


if strcmp(source.Tag, 'pushbutton')  % don't delete if the save pushbutton called this function
	return
end

% delete the figure
delete(source)

% change checkbox
if isprop(app, 'CheckBoxSici')
	app.CheckBoxSici.Value = 0;
end

return