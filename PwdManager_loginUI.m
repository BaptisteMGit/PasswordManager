classdef PwdManager_loginUI < handle
% MainUI for password manager 
%
% Baptiste Menetrier
    
    properties
        % Manager object 
        Manager
       
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
        Icon = 'Icons\icon_padlock.png'
    end
    
    properties (Dependent)
        % Position of the main figure 
        fPosition 
    end

    properties (Hidden=true)
        % Size of the main window 
        Width = 375;
        Height = 200;
        % Number of components 
        glNRow = 5;
        glNCol = 5;
        
        % Labels visual properties 
        LabelFontName = 'Arial';
        LabelFontSize_title = 16;
        LabelFontSize_text = 14;
        LabelFontWeight_title = 'bold';
        LabelFontWeight_text = 'normal';
    end

    properties (Hidden=true)
        username
        pwd
        hashedPwd
    end
    
    %% Constructor of the class 
    methods
        function app = PwdManager_loginUI(manager)
            % Manager object 
            app.Manager = manager;

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

            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Login to access password manager', 'LayoutPosition', struct('nRow', 1, 'nCol', [1, 5]), 'Font', titleLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'Username', 'LayoutPosition', struct('nRow', 2, 'nCol', 2), 'Font', textLabelFont})
            addLabel(app, {'Parent', app.GridLayout, 'Text', 'SuperPassword', 'LayoutPosition', struct('nRow', 3, 'nCol', 2), 'Font', textLabelFont})


            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'Username', ...
                'LayoutPosition', struct('nRow', 2, 'nCol',4), 'ValueChangedFcn', {@app.usernameChanged}})
            addEditField(app, {'Parent', app.GridLayout, 'Style', 'text', 'Value', '', 'Placeholder', 'SuperPassword', ...
                'LayoutPosition', struct('nRow', 3, 'nCol',4), 'ValueChangingFcn', {@app.passwordChanging}})


            % Buttons
            addButton(app, {'Parent', app.GridLayout, 'Name', 'Login', 'ButtonPushedFcn', @app.loginButtonPushed, 'LayoutPosition', struct('nRow', 5, 'nCol', [2, 4])})
            
        end
    end

    %% Set up methods 
    methods

    end
    
    %% Callback functions 
    methods 

        function usernameChanged(app, hObject, eventData)
            app.username = hObject.Value;
        end 

        function passwordChanged(app, hObject, eventData)
            app.hashedPwd = hashPwd(hObject.Value); % Store the hashed pwd
        end 

        function passwordChanging(app, hObject, eventData)
%             pause(0.1)
            currentPwd = hObject.Value;
            lengthCurrentPwd = numel(currentPwd);
            lengthStoredPwd = numel(app.pwd);

            if lengthCurrentPwd > lengthStoredPwd % User added a character to pwd 
                app.pwd = [app.pwd currentPwd(end)]; % Update pwd with last character added 
                % Replace new character by *
                hiddenPwd(1, 1:lengthCurrentPwd) = '*';
%                 hObject.Value = hiddenPwd;
%                 set(hObject, 'Value', hiddenPwd)
            elseif lengthCurrentPwd < lengthStoredPwd % User hit backspace to delete the last character
                diff = lengthStoredPwd - lengthCurrentPwd;
                app.pwd = app.pwd(1:end-diff); % Delete last characters 
            elseif lengthCurrentPwd == lengthStoredPwd
                fprintf('Flag   ')
            end 
        end 


        function loginButtonPushed(app, hObject, eventData)
            [userIsKnown, user] = app.Manager.getUser(app.username);

            if userIsKnown % User is in the database 
                if strcmp(user.hashedPwd, app.hashedPwd) % Check is pwd is correct 
                    % Open password manager 
                    fprintf('Successfully logged in!')
                else 
                    uialert(app.Figure, sprintf('Incorrect password for user "%s" !', app.username), 'Error', 'Icon', 'error')
                end
            end
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
        
    end
end                                             