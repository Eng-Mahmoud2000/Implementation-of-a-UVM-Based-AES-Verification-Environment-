from Crypto.Cipher import AES

with open('D:/Digital_Verification_Diploma/Projects/AES/py/key.txt', 'r') as file:
    data_hex = file.readline().strip()  # Read the data hex string
    key_hex = file.readline().strip()  # Read the key hex string
    
data = bytes.fromhex(data_hex)
key = bytes.fromhex(key_hex)

cipher = AES.new(key, AES.MODE_ECB)

ciphertext = cipher.encrypt(data)

with open('D:/Digital_Verification_Diploma/Projects/AES/py/output.txt', 'w') as file:
    file.write(ciphertext.hex())