classdef UnknownUser < User
    %UNKNOWNUSER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = UnknownUser(manager)
            obj@User(manager, "unknown", "")
        end
       
    end
end

