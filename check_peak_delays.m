% consts
cf = [3 5 8];
origin = [32.5 73.85 3000];
minpeakdelay = 0.1;
maxpeakdelay = 40; 

% get all SAC files
files = dir('sac_JK/*.sac')';
len = length(files);

% create empty time marker header and picking vars
time_marker_headings = cell(len, 11);
pickings = zeros(len,5);

% for each SAC file
for i = 1:len

    % unpack SAC file and calculate envelope
    [tempis,sp_i,SAChdr_i,srate_i]      =   Murat_envelope(cf,files(i).name);

    % get time marker headings
    time_marker_headings{i,1} = SAChdr_i.times.k0;
    time_marker_headings{i,2} = SAChdr_i.times.ka;
    time_marker_headings{i,3} = SAChdr_i.times.kt0;
    time_marker_headings{i,4} = SAChdr_i.times.kt1;
    time_marker_headings{i,5} = SAChdr_i.times.kt2;
    time_marker_headings{i,6} = SAChdr_i.times.kt3;
    time_marker_headings{i,7} = SAChdr_i.times.kt4;
    time_marker_headings{i,8} = SAChdr_i.times.kt5;
    time_marker_headings{i,9} = SAChdr_i.times.kt6;
    time_marker_headings{i,10} = SAChdr_i.times.kt7;
    time_marker_headings{i,11} = files(i).name;

    % get p and s pickings
    tp = SAChdr_i.times.a;
    ts = SAChdr_i.times.t0;
    o = tempis(1);

    % get Sg time
    tsauto = NaN;
    idx = strfind(time_marker_headings(i,:), "Sg");
    idx = cellfun(@(x) ~isempty(x), idx);
    [~, col] = find(idx);
    if isscalar(col) & isnumeric(col) & col > 3 & col < 11
        markername = "t" + string(col-4);
        tsauto = SAChdr_i.times.(markername);
    end

    % calculate peak delay time
    cursorPick_i = floor(ts*srate_i);
    cursorPeakDelay_i = floor(cursorPick_i+40*srate_i);
    peakDelay_i = Murat_peakDelay(sp_i,cursorPick_i,srate_i,cursorPeakDelay_i);
    tpeak = peakDelay_i(1) + ts;

    % append to pickings
    pickings(i,:) = [tp ts tpeak tsauto o];


%     if(ts > tp*3)
%         disp(files(i).name + " (" + SAChdr_i.times.ka + ", " + SAChdr_i.times.kt0 + ") has a late S-wave arrival (" + string(ts) + ") compared to P-wave arrival (" + string(tp) + ")");
%     end
%     if tpeak > 1.5*ts
%         disp(files(i).name + " (" + string(ts) + ")");
%     end

end


% plot pickings relative to P-wave picking
scatter(pickings(:,2), pickings(:,1), 'DisplayName', 'manual P-time')
hold on
scatter(pickings(:,2), pickings(:,2), 'DisplayName', 'manual S-time')
hold on
scatter(pickings(:,2), pickings(:,3), 'DisplayName', 'peak 3Hz')
legend