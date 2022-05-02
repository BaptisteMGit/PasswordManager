classdef PwdManager_mainUI < handle
% MainUI for password manager 
%
% Baptiste Menetrier
    
    properties
        % User object 
        User
       
        % Graphics handles
        Figure                  
        GridLayout 
        handleLabel
        handleEditField
        handleDropDown
        handleButton

        % Name of the window 
        Name = "Password manager";
        % App release version 
        Version = 0.1; 
        % Icon 
        Icon = 'Icons\icon_web.png'
    end
    
    properties (Dependent)
        % Position of the main figure 
        fPosition 
        pwdToDisplay
        selectedWebsite
    end

    properties (Hidden=true)
        % Size of the main window 
        Width = 375;
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
        function app = PwdManager_mainUI(user)
            % user object 
            app.User = user;

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
                            'WindowStyle', 'normal', ...
                            'CloseRequestFcn', @closeWindowCallback); 
            
            % Grid Layout
            app.GridLayout = uigridlayout(app.Figure, [app.glNRow, app.glNRow]);
            app.GridLayout.ColumnWidth{1} = 5;
            app.GridLayout.ColumnWidth{2} = 100;
            app.GridLayout.ColumnWidth{3} = 10;
            app.GridLayout.ColumnWidth{4} = 200;
            app.GridLayout.ColumnWidth{5} = 5;

            app.GridLayout.RowHeight{4} = 5;

            
            %%% Labels %%%
            titleLabelFont = getLabelFont(app, 'Title');
            textLabelFont = getLabelFont(app, 'Text');

            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Manage passwords', 'LayoutPosition', struct('nRow', 1, 'nCol', [1, 5]), 'Font', titleLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Website', 'LayoutPosition', struct('nRow', 2, 'nCol', 2), 'Font', textLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Password', 'LayoutPosition', struct('nRow', 3, 'nCol', 2), 'Font', textLabelFont})

            addDropDown(app, {'Parent', app.GridLayout, 'Items', app.User.webNames, 'Value', app.User.webNames{1}, ...
                'ValueChangedFcn', @app.websiteChanged, 'LayoutPosition',  struct('nRow', 2, 'nCol', 4)})

            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', app.pwdToDisplay, 'Placeholder', 'Password', ...
                'LayoutPosition', struct('nRow', 3, 'nCol',4), 'Editable', 'off'})


            % Buttons
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Add new', 'ButtonPushedFcn', @app.addnewButtonPushed, 'LayoutPosition', struct('nRow', 5, 'nCol', [2, 4])})
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Edit current', 'ButtonPushedFcn', @app.editButtonPushed, 'LayoutPosition', struct('nRow', 6, 'nCol', [2, 4])})
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Delete current', 'ButtonPushedFcn', @app.deleteButtonPushed, 'LayoutPosition', struct('nRow', 7, 'nCol', [2, 4])})
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Logout', 'ButtonPushedFcn', @app.logoutButtonPushed, 'LayoutPosition', struct('nRow', 8, 'nCol', [2, 4])})

        end
    end

    %% Callback functions 
    methods 

        function websiteChanged(app, hObject, evenData)
            % Update pwd
            set(app.handleEditField(1), 'Value', app.pwdToDisplay)
        end
        
        function addnewButtonPushed(app, hObject, evenData)
            % Open other UI 
            PwdManager_addnewUI(app.User, app);
        end

        function editButtonPushed(app, hObject, evenData)
            % Open other UI 
            PwdManager_editUI(app.User, app);
        end

        function deleteButtonPushed(app, hObject, evenData)
            msg = sprintf('You are about to delete all information related to website "%s", do you whant to pursue this non reversible operation ?', app.selectedWebsite);
            title = 'Confirm deletation';
            selection = uiconfirm(app.Figure, msg, title, ...
                               'Options',{'Yes, delete', 'No, cancel'}, ...
                               'DefaultOption', 2, 'Icon', 'info');

            switch selection
                case 'Yes, delete'
                    app.User.deleteWebsite(app.selectedWebsite);
                    app.refreshWebsiteDropdown();
                    fprintf('Website "%s" successfuly deleted!\n', app.selectedWebsite)
                case 'No, cancel'
                    % Do nothing 
            end     
        end

        function logoutButtonPushed(app, hObject, eventData)
            % Logout 
        end 

        function refreshWebsiteDropdown(app)
            set(app.handleDropDown(1), 'Items', app.User.webNames)
            set(app.handleDropDown(1), 'Value', app.User.webNames{1})
            set(app.handleEditField(1), 'Value', app.pwdToDisplay) 
        end

    end

    %% Get methods for dependent properties 
    % NOTE: even if the implementation looks a bit complicated dependent
    % properties increase app performance by saving memmory space and
    % dependent properties can be used to maintain app proportions 
    methods 

        function fPosition = get.fPosition(app)
            fPosition = getFigurePosition(app);
        end

        function website = get.selectedWebsite(app)
            website = get(app.handleDropDown, 'Value');
        end 

        function pwd = get.pwdToDisplay(app)
            pwd = app.User.getPassword(app.selectedWebsite);
        end

        

    end
end                                             