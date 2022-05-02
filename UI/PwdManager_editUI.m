classdef PwdManager_editUI < handle
% editUI for password manager 
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
        Name = "Password manager - edit";
        % App release version 
        Version = 0.1; 
        % Icon 
        Icon = 'Icons\icon_plus.png'
    end
    
    properties (Dependent)
        % Position of the main figure 
        fPosition 
        currentWebsite
        currentUrl
        currentPwd

    end

    properties (Hidden=true)
        % Size of the main window 
        Width = 425;
        Height = 300;
        % Number of components  
        glNRow = 8;
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
        function app = PwdManager_editUI(user, mainUI)
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
            app.GridLayout.ColumnWidth{2} = 'fit';
            app.GridLayout.ColumnWidth{3} = 10;
            app.GridLayout.ColumnWidth{4} = 200;
            app.GridLayout.ColumnWidth{5} = 5;

            app.GridLayout.RowHeight{7} = 5;

            
            titleLabelFont = getLabelFont(app, 'Title');
            textLabelFont = getLabelFont(app, 'Text');
            
            % Title 
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Edit website', 'LayoutPosition', struct('nRow', 1, 'nCol', [1, 5]), 'Font', titleLabelFont})
            
            % Website
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Website', 'LayoutPosition', struct('nRow', 2, 'nCol', 2), 'Font', textLabelFont})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', app.currentWebsite, 'Placeholder', 'Website name', ...
                'LayoutPosition', struct('nRow', 2, 'nCol',4), 'Editable', 'off'})
            % Url
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Url', 'LayoutPosition', struct('nRow', 3, 'nCol', 2), 'Font', textLabelFont})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', app.currentUrl, 'Placeholder', 'Url', ...
                'LayoutPosition', struct('nRow', 3, 'nCol',4)})
            % Password
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Current password', 'LayoutPosition', struct('nRow', 4, 'nCol', 2), 'Font', textLabelFont})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', app.currentPwd, 'Placeholder', 'Password', ...
                'LayoutPosition', struct('nRow', 4, 'nCol',4), 'Editable', 'off'})
            % New password 
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'New password', 'LayoutPosition', struct('nRow', 5, 'nCol', 2), 'Font', textLabelFont})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'New password', ...
                'LayoutPosition', struct('nRow', 5, 'nCol',4)})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Comfirm new password', 'LayoutPosition', struct('nRow', 6, 'nCol', 2), 'Font', textLabelFont})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'New password', ...
                'LayoutPosition', struct('nRow', 6, 'nCol',4)})

            % Buttons
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Commit changes', 'ButtonPushedFcn', @app.editButtonPushed, 'LayoutPosition', struct('nRow', 8, 'nCol', [1, 2])})
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Close', 'ButtonPushedFcn', @app.closeButtonPushed, 'LayoutPosition', struct('nRow', 8, 'nCol', [3, 4])})

        end
    end

    %% Callback functions 
    methods 

        function editButtonPushed(app, hObject, evenData)
            newUrl = get(app.handleEditField(2), 'Value');
            
            [flag, newPassword] = app.checkPassword();
            if flag
                if strcmp(newPassword, app.currentPwd)
                    uialert(app.Figure, 'The new password is identical to the previous one!', 'Identical passwords', 'Icon', 'warning')
                end
                editArgin = {'Url', newUrl, 'Password', newPassword};
                app.User.editWebsite(app.currentWebsite, editArgin{:}) % Commit changes to db 
                fprintf('Website "%s" successfuly edited!', app.currentWebsite)
                app.mainUI.refreshWebsiteDropdown(); % Refresh pwd to display 
            else 
                uialert(app.Figure, 'Passwords not identical or empty!', 'Password error', 'Icon', 'error')
            end

        end

        function closeButtonPushed(app, hObject, evenData)
            close(app.Figure)
        end


    end

    methods
        function [flag, pwd] = checkPassword(app)
%             pwd0 = get(app.handleEditField(3), 'Value');
            pwd1 = get(app.handleEditField(4), 'Value');
            pwd2 = get(app.handleEditField(5), 'Value');

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

        function currentWebsite = get.currentWebsite(app)
            currentWebsite = get(app.mainUI.handleDropDown(1), 'Value');
        end 

        function currentUrl = get.currentUrl(app)
            currentUrl = app.User.getUrl(app.currentWebsite);
        end

        function currentPwd = get.currentPwd(app)
            currentPwd = app.User.getPassword(app.currentWebsite);
        end
    end
end                                             