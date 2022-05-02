classdef PwdManager_App
    
    properties 
        Manager
        rootApp
    end

    methods
        function app = PwdManager_App()
            % Root from where the app is executed
            app.rootApp = pwd;
            
            if ~exist('PasswordManager.mat', 'file')
               initManager; 
            end
            
            tmp = load(fullfile(app.rootApp, "PasswordManager.mat"));                
            app.Manager = tmp.PasswordManager;

            % UI
            % Create login window
            PwdManager_loginUI(app.Manager);

            fprintf('PasswordManager is ready to be used.\n')
        end
    end

end 