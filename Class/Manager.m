classdef Manager < handle 
    %MANAGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        users % List of known users 
    end
    
    methods
        function obj = Manager()
            admin = User(obj, 'Bapt2401', 'E7CF3EF4F17C3999A94F2C6F612E8A888E5B1026878E4E19398B23BD38EC221A');
            obj.users = {admin};
        end
        
        function [flag, user] = getUser(obj, username)
            % Initialisation 
            flag = 0; % default false
            user = UnknownUser(obj); 

             for idxusr = 1:numel(obj.users)
                usr = obj.users{idxusr};
                if strcmp(usr.username, username) % Check if username belongs to the list of known users 
                    flag = 1; % User is known 
                    user = usr; % Return user object 
                    break;
                end
             end            
        end 

        function commitChange(obj)
            PasswordManager = obj;
            save("PasswordManager.mat", "PasswordManager")  
        end

    end
end

