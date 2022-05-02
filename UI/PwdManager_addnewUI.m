classdef PwdManager_addnewUI < handle
% MainUI for password manager 
%
% Baptiste Menetrier
    
    properties
        % User object 
        User
        mainUI % Handle to main UI 

        % Graphics handles
        Figure                  
        GridLayout 
        handleLabel
        handleEditField
        handleDropDown
        handleButton

        % Name of the window 
        Name = "Password manager - add new";
        % App release version 
        Version = 0.1; 
        % Icon 
        Icon = 'Icons\icon_plus.png'
    end
    
    properties (Dependent)
        % Position of the main figure 
        fPosition 
    end

    properties (Hidden=true)
        % Size of the main window 
        Width = 400;
        Height = 300;
        % Number of components 
        glNRow = 7;
        glNCol = 5;
        
        % Labels visual properties 
        LabelFontName = 'Arial';
        LabelFontSize_title = 16;
        LabelFontSize_text = 14;
        LabelFontWeight_title = 'bold';
        LabelFontWeight_text = 'normal';
    end

    
    %% Constructor of the class 
    methods
        function app = PwdManager_addnewUI(user, mainUI)
            % user object 
            app.User = user;
            app.mainUI = mainUI;

            % Figure 
            app.Figure = uifigure('Name', app.Name, ...
                            'Icon', app.Icon, ...
                            'Visible', 'on', ...
                            'NumberTitle', 'off', ...
                            'Position', app.fPosition, ...
                            'Toolbar', 'none', ...
                            'MenuBar', 'none', ...
                            'Resize', 'on', ...
                            'AutoResizeChildren', 'off', ...
                            'WindowStyle', 'normal'); 
            
            % Grid Layout
            app.GridLayout = uigridlayout(app.Figure, [app.glNRow, app.glNRow]);
            app.GridLayout.ColumnWidth{1} = 5;
            app.GridLayout.ColumnWidth{2} = 125;
            app.GridLayout.ColumnWidth{3} = 10;
            app.GridLayout.ColumnWidth{4} = 200;
            app.GridLayout.ColumnWidth{5} = 5;

            app.GridLayout.RowHeight{6} = 5;

            
            %%% Labels %%%
            titleLabelFont = getLabelFont(app, 'Title');
            textLabelFont = getLabelFont(app, 'Text');

            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Add new website', 'LayoutPosition', struct('nRow', 1, 'nCol', [1, 5]), 'Font', titleLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Website', 'LayoutPosition', struct('nRow', 2, 'nCol', 2), 'Font', textLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Url (optional)', 'LayoutPosition', struct('nRow', 3, 'nCol', 2), 'Font', textLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Password', 'LayoutPosition', struct('nRow', 4, 'nCol', 2), 'Font', textLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Comfirm password', 'LayoutPosition', struct('nRow', 5, 'nCol', 2), 'Font', textLabelFont})



            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'Website name', ...
                'LayoutPosition', struct('nRow', 2, 'nCol',4)})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'Url', ...
                'LayoutPosition', struct('nRow', 3, 'nCol',4)})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'Password', ...
                'LayoutPosition', struct('nRow', 4, 'nCol',4)})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'Password', ...
                'LayoutPosition', struct('nRow', 5, 'nCol',4)})

            % Buttons
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Add', 'ButtonPushedFcn', @app.addButtonPushed, 'LayoutPosition', struct('nRow', 7, 'nCol', [1, 2])})
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Close', 'ButtonPushedFcn', @app.closeButtonPushed, 'LayoutPosition', struct('nRow', 7, 'nCol', [3, 4])})

        end
    end

    %% Callback functions 
    methods 

        function addButtonPushed(app, hObject, evenData)
            % add new entry to db 
            name = get(app.handleEditField(1), 'Value');
            url = get(app.handleEditField(2), 'Value');
            
            if ~isempty(name)
                [flag, pwd] = app.checkPassword();
                if flag
                    app.User.addWebsite(name, pwd, url)
                    app.mainUI.refreshWebsiteDropdown();
                    fprintf('New website successfuly added!')
                else 
                    uialert(app.Figure, 'Passwords not identical or empty!', 'Password error', 'Icon', 'error')
                end
            else 
                uialert(app.Figure, 'Empty name!', 'Website error', 'Icon', 'error')
            end
        end

        function closeButtonPushed(app, hObject, evenData)
            close(app.Figure)
        end


    end

    methods
        function [flag, pwd] = checkPassword(app)
            pwd1 = get(app.handleEditField(3), 'Value');
            pwd2 = get(app.handleEditField(4), 'Value');

            if strcmp(pwd1, pwd2) && ~isempty(pwd1)
                flag = 1; 
                pwd = pwd1;
            else
                flag = 0;
                pwd = '';
            end
        end

    end 
    methods 

        function fPosition = get.fPosition(app)
            fPosition = getFigurePosition(app);
        end
    end
end                                             