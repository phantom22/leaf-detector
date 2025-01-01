function f = figure_maximized(varargin)
    % figure_maximized(string_varargin)
    %
    % returns a maximized figure.
    % string_varargin is optional.
    %
    % es. figure_maximized with a single string as argument.
    %   figure_maximized("MyFigure") % 'MyFigure' will be the name of the
    %                                % figure.
    %
    % es. figure_maximized with multiple strings as arguments, assume k=1.
    %   figure_maximized("MyFigure ", numtostr(k)); % 'MyFigure 1' will be
    %                                               % the name of the figure
    arguments (Repeating)
        varargin {mustBeText};
    end
    
    f = figure;
    f.WindowState = "maximized";

    if nargin > 0
        if nargin == 1
            f.Name = varargin;
        else
            f.Name = strcat(varargin{:});
        end
        f.NumberTitle = 'off';
    end
end