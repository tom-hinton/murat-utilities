% consts
maxdelta = 0.1;  % i.e. 1/minsamplingrate
origin = [32.5 73.85 3000]; % from Murat.input.origin, in [lat lon elev]
dest = [34.55 76.55 -45000]; % from Murat.input.end
endnoise = 4; % from Murat.input.startNoise + Murat.input.bodyWindow

% get SAC files
files = dir('sac_JK/*.sac');

% for each SAC file
for file = files'

    % unpack SAC file
    [times,data,SAChdr] = fget_sac(file.name);

    % if arrival time earlier than start noise
    if SAChdr.times.a < endnoise
        disp('Arrival time within noise measurement (a = ' + string(SAChdr.times.a) + '): ' + file.name);
        movefile('./sac_JK/' + string(file.name), 'sac_JK_removed/');
    end

    % if sampling rate too low
    if SAChdr.times.delta > maxdelta
        disp('Low sampling rate (delta = ' + string(SAChdr.times.delta) + '): ' + file.name);
    end

    % if station latitude too low
    if SAChdr.station.stla < origin(1)
        disp('Station latitude too low (' + string(SAChdr.station.stla) + '): ' + file.name);
    % if station latitude too high
    elseif SAChdr.station.stla > dest(1)
        disp('Station latitude too high (' + string(SAChdr.station.stla) + '): ' + file.name);
    end

    % if event latitude too low
    if SAChdr.event.evla < origin(1)
        disp('Event latitude too low (' + string(SAChdr.event.evla) + '): ' + file.name);
    % if station latitude too high
    elseif SAChdr.event.evla > dest(1)
        disp('Event latitude too high (' + string(SAChdr.event.evla) + '): ' + file.name);
    end

    % if station longitude too low
    if SAChdr.station.stlo < origin(2)
        disp('Station longitude too low (' + string(SAChdr.station.stlo) + '): ' + file.name);
    % if station longitude too high
    elseif SAChdr.station.stlo > dest(2)
        disp('Station longitude too high (' + string(SAChdr.station.stlo) + '): ' + file.name);
    end

    % if event longitude too low
    if SAChdr.event.evlo < origin(2)
        disp('Event longitude too low (' + string(SAChdr.event.evlo) + '): ' + file.name);
    % if station longitude too high
    elseif SAChdr.event.evlo > dest(2)
        disp('Event longitude too high (' + string(SAChdr.event.evlo) + '): ' + file.name);
    end

    % if station elevation too high
    if SAChdr.station.stel > origin(3)
        disp('Station elevation too high (' + string(SAChdr.station.stel) + '): ' + file.name);
    % if station elevation too low
    elseif SAChdr.station.stel < dest(3)
        disp('Station elevation too low (' + string(SAChdr.station.stel) + '): ' + file.name);
    end

    % if event elevation too low
    if -SAChdr.event.evdp * 1000 > origin(3)
        disp('Event depth too shallow (' + string(SAChdr.event.evdp) + '): ' + file.name);
    % if event elevation too high
    elseif SAChdr.event.evdp * 1000 > -dest(3)
        disp('Event depth too deep (' + string(SAChdr.event.evdp) + '): ' + file.name);
    end

end