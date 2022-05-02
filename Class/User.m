classdef User < handle 
    %USER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        manager
        username 
        hashedPwd % hash code for user SuperPassword
        data % data table containing websites informations and password 
    end

    properties (Dependent=true)
        webNames % Website names 
        webUrls % Websites urls
        webEncryptedPwd % Encrypted passwords
        webDate % Date of addition
    end
    
    properties (Hidden=true, Access=private)
%         encryptionAlgorithm = 'SHA-256';
        encryptionAlgorithm = 'SHA-1';

    end 
    
    properties (Hidden=true)
        dataColumns = {'Name', 'Url', 'Password', 'Date'}; % Colum names 
    end

    methods
        function obj = User(manager, username, hashedPwd)
            obj.manager = manager;
            if nargin > 1
                assert(nargin == 3, 'When creating a user both username and pwd must be stated!')
                obj.username = username;
                obj.hashedPwd = hashedPwd;
            end 
            
            % Initialize data table 
            obj.initDB();
        end


        function initDB(obj)
            if isempty(obj.data)
                obj.addWebsite("DefaultWebsite", "DefaultPassword", "DefaultUrl")
            end
        end

        function deleteWebsite(obj, webName)
            toDelete = (obj.webNames == webName);
            if any(find(toDelete))
                obj.data(toDelete, :) = []; 
                obj.initDB(); % In case data is empty after deletion 
            else 
                warning('Failed to delete website "%s", website missing from database!', webName)
            end 
        end

        function editWebsite(obj, webName, varargin)
            newUrl = getVararginValue(varargin, 'Url', obj.getUrl(webName));
            newPassword = getVararginValue(varargin, 'Password', obj.getPassword(webName));
            newDate = datetime('now');
            newEncryptedPwd = obj.encryptePwd(newPassword, newDate);

            % Updated row to commit 
            webName = convertCharsToStrings(webName);
            newEncryptedPwd = convertCharsToStrings(newEncryptedPwd);
            newUrl = convertCharsToStrings(newUrl);
            newRow = table(webName, newUrl, newEncryptedPwd, newDate, 'VariableNames', obj.dataColumns);

            % Edit line 
            toEdit = (obj.webNames == webName);
            obj.data(toEdit, :) = newRow; 

            % Commit changes 
            obj.manager.commitChange();
        end 

        function addWebsite(obj, name, pwd, url)
            name = convertCharsToStrings(name);
            pwd = convertCharsToStrings(pwd);
            url = convertCharsToStrings(url);

            date = datetime('now');
            encryptedPwd = obj.encryptePwd(pwd, date);

            newTable = table(name, url, encryptedPwd, date, 'VariableNames', obj.dataColumns);
            obj.data = [obj.data; newTable];

            % Commit changes 
            obj.manager.commitChange();

            % Remove DefaultWebsite once another website has been added 
            if any(find(obj.webNames == "DefaultWebsite")) % If DefaultWebsite in DB
                obj.deleteWebsite("DefaultWebsite")
            end 
        end 

        function pwd = getPassword(obj, webName)
            % Get stored password for website with name = webName 
            encryptedPwd = obj.webEncryptedPwd(obj.webNames == webName);
            encryptionDate = obj.webDate(obj.webNames == webName);  
            pwd = obj.decryptePwd(encryptedPwd, encryptionDate);
        end

        function url = getUrl(obj, webName)
            % Get stored url for website with name = webName 
            url = obj.webUrls(obj.webNames == webName);
        end

        function decryptedPwd = decryptePwd(obj, encryptedPwd, encryptionDate)
            secretKey = obj.getSecretKey(encryptionDate);
            aes = AES(secretKey, obj.encryptionAlgorithm);
            decryptedPwd = aes.decrypt(encryptedPwd) ;
        end 

        function encryptedPwd = encryptePwd(obj, pwdToEncrypt, encryptionDate)
            secretKey = obj.getSecretKey(encryptionDate);
            aes = AES(secretKey, obj.encryptionAlgorithm);
            encryptedPwd = aes.encrypt(pwdToEncrypt) ;
        end 

        function secretKey = getSecretKey(obj, date)
            % To discuss 
%             secretKey = 'ssshhhhhhhhhhh!!!!';
            seed = datestr(date);
            secretKey = hashPwd(seed);
        end 
    end
    
   

    %% Get methods to read data table 
    methods

%         function dataColumns = get.dataColumns(obj)
%             dataColumns = obj.data.Properties.VariableNames;
%         end 

        function webNames = get.webNames(obj)
            webNames = obj.data.(obj.dataColumns{1});
        end

        function webUrls = get.webUrls(obj)
            webUrls = obj.data.(obj.dataColumns{2});
        end

        function webEncryptedPwd = get.webEncryptedPwd(obj)
            webEncryptedPwd = obj.data.(obj.dataColumns{3});
        end

        function webDate = get.webDate(obj)
            webDate = obj.data.(obj.dataColumns{4});
        end
    end 
end

