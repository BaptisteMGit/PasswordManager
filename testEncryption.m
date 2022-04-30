secretKey = datestr(datetime('now'));
algorithm = "SHA-256";
aes = AES(secretKey, algorithm);

originalString = 'password';
encryptedString = aes.encrypt(originalString);
decryptedString = aes.decrypt(encryptedString) ;

disp(originalString);
disp(encryptedString);
disp(decryptedString);