function hashedPwd = hashPwd(pwd)
%HASHPWD Summary of this function goes here
%   Detailed explanation goes here

% Available options are 'SHA1', 'SHA256', 'SHA384', 'SHA512', 'MD5'
algorithm = 'SHA256';   

hasher = System.Security.Cryptography.HashAlgorithm.Create(algorithm); 

% GENERATING THE HASH:
hash_byte = hasher.ComputeHash( uint8(pwd) );  % System.Byte class
hash_uint8 = uint8( hash_byte );               % Array of uint8
hash_hex = dec2hex( hash_uint8 );                % Array of 2-char hex codes

% Generate the hex codes as 1 long series of characters
hashedPwd = pwd([]);
nBytes = length(hash_hex);
for k=1:nBytes
    hashedPwd(end+1:end+2) = hash_hex(k,:);
end

% fprintf(1, '\n\tThe %s hash is: "%s" [%d bytes]\n\n', algorithm, hashedPwd, nBytes);

end

