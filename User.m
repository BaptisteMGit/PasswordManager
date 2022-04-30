classdef User
    %USER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        username
        hashedPwd
    end
    
    methods
        function obj = User(username, hashedPwd)
            if nargin > 0
                assert(nargin == 2, 'When creating a user both username and pwd must be stated!')
                obj.username = username;
                obj.hashedPwd = hashedPwd;
            end 
        end
    end
end

