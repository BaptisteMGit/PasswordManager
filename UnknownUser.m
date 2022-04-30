classdef UnknownUser < User
    %UNKNOWNUSER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = UnknownUser()
            obj.username = 'unknown';
            obj.hashedPwd = '';
        end
       
    end
end

