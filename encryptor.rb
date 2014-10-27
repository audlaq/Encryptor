class Encryptor
  require 'digest'

  puts "Please enter a password"
  password = gets.chomp.to_s

  def encrypt_password(password)
    encrypted_password = Digest::MD5.hexdigest password
    filename = File.open("md5hash.txt", "w")
    filename.write(encrypted_password)
    filename.close
    compare_md5(encrypted_password)
  end

  def compare_md5(encrypted_password)
    compare = File.open("md5hash.txt", "r")
    md5hash = compare.read
    if md5hash == encrypted_password
      puts "Password is usable"
    else
      puts "Please re-enter password"
    end
    compare.close
  end

  e = Encryptor.new
  e.encrypt_password(password)

  def encrypt_message
    puts "Please enter a message to encrypt"
    message = gets.chomp.to_s
    encrypt(message, 12)
  end

  def decrypt_message
    puts "Please enter an encrypted message"
    message = gets.chomp.to_s
    supported_characters.count.times.collect do |attempt|
      decrypt(message, attempt)
    end  
  end
  
  def cipher(rotation)
    characters = (' '..'z').to_a
    rotated_characters = characters.rotate(rotation)
    Hash[characters.zip(rotated_characters)]
  end

  def encrypt_letter(letter, rotation)
    cipher_for_rotation = cipher(rotation)
    cipher_for_rotation[letter]
  end

  def encrypt(string, rotation)
    letters = string.split("")
    results = letters.collect do |letter|
        encrypted_letter = encrypt_letter(letter, rotation)
    end
    results.join
  end

  def decrypt(string, rotation)
    letters = string.split("")
    rotation = rotation*-1
    results = letters.collect do |letter|
        decrypted_letter = encrypt_letter(letter, rotation)
    end
    results.join    
  end

  def encrypt_file(filename, rotation)
    filename = File.open("secret.txt", "r")
    secret = filename.read
    encrypted_secret = encrypt(secret, rotation)
    out = File.open("secret.txt.encrypted", "w")
    out.write(encrypted_secret)
    out.close
  end

  def decrypt_file(filename, rotation)
    decrypt_filename = File.open("secret.txt.encrypted", "r")
    unsecret = decrypt_filename.read
    decrypted_secret = decrypt(unsecret, rotation)
    output_filename = "secret.txt.encrypted".gsub("encrypted", "decrypted")
    decrypt_out = File.open(output_filename, "w")
    decrypt_out.write(decrypted_secret)
    decrypt_out.close
  end

  def supported_characters
    (' '..'z').to_a
  end

  def crack(message)
    supported_characters.count.times.collect do |attempt|
      decrypt(message, attempt)
    end
  end

end
