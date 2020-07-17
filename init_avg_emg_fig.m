function init_avg_emg_fig(app)

% if there is already a average fig, clear old data
if ~isempty(findobj('Name', 'Average EMG'))
	app.avg_emg_axes;
	
else

	app.avg_emg_fig = figure('Position', [1544 483 506 505], ...
		'NumberTitle', 'off', 'Name', 'Average EMG', ...
 		'MenuBar', 'none', 'ToolBar', 'none');


	app.avg_emg_axes = axes('Position', [0.18 0.25 0.7 0.7], ...
		'Fontsize', 20);
	ylabel('EMG (\muV)')
	xlabel('Time (msec)')


	seg_time = (app.params.postTriggerTime + app.params.preTriggerTime) / 1000;
	seg_num_points = round(app.params.sampFreq*seg_time);
	t = (0:1/app.params.sampFreq:(seg_time-1/app.params.sampFreq))*1000 - app.params.preTriggerTime;

	% save the time vector for the emg data in the axes userdata
	app.avg_emg_axes.UserData.t = t;

	app.avg_num_lines = uicontrol(app.avg_emg_fig, 'Style', 'text', ...
				'String', 'Num trials = 0', ...
				'Units', 'normalized', ...
				'Position', [0.11 0.019 0.25 0.06], ...
	 			'Fontsize', 16);

	% set a close function to save the data
 	app.avg_emg_fig.CloseRequestFcn = {@save_and_close_avg_emg, app};


	% button to update data
	h_save = uicontrol(app.avg_emg_fig, 'Style', 'pushbutton', ...
				'String', 'Update', ...
				'Units', 'normalized', ...
				'Position', [0.5 0.019 0.2 0.06], ...
				'Fontsize', 16, ...
				'Tag', 'pushbutton', ...
				'Callback', {@update_avg_emg, app});

% 	% button to save datapoints
% 	h_save = uicontrol(app.avg_emg_fig, 'Style', 'pushbutton', ...
% 				'String', 'Save', ...
% 				'Units', 'normalized', ...
% 				'Position', [0.78 0.019 0.15 0.06], ...
% 				'Fontsize', 16, ...
% 				'Tag', 'pushbutton'); %%, ...
% % 				'Callback', {@save_and_close_sici, app});

	% button to print as png
	h_print = uicontrol(app.avg_emg_fig, 'Style', 'pushbutton', ...
				'String', 'P', ...
				'Units', 'normalized', ...
				'Position', [0.95 0.03 0.04 0.04], ...
				'Fontsize', 8, ...
				'Callback', {@print_avg_emg, app});
	
	


end

