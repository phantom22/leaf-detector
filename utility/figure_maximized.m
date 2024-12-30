function f = figure_maximized(name)
    arguments
        name {mustBeText} = ""
    end
    f = figure;
    set(f, 'WindowState', 'maximized');

    if name ~= ""
        set(f, 'Name', name);
    end
end