#Script for generating the FTP migration wget string. v1.0

confirm = "no"

while confirm == "no"

    #Gather up FTP information for remote account
	puts "What is the FTP URL of the account you are trying to migrate?"
	ftp_url = gets.chomp
	puts "What is the username of the FTP account?"
	ftp_user = gets.chomp
	puts "What is the password?"
	ftp_pass = gets.chomp
	puts "What is the web root directory (leave blank if ftp account root directory is the same as webroot)"
	ftp_root = gets.chomp

    #Information for local site5 account
	puts "What is the local site5 username?"
	site5_user = gets.chomp

	puts "Is this an addon domain of the above cPanel account? (yes or no)"
	site5_addon = gets.chomp

	if site5_addon == "yes"
		puts "What is the directory that this addon domains files should be uploaded to?"
		site5_addondir = gets.chomp
	else
	end

    #Confirmation prior to generating wget string

	puts "The url is #{ftp_url}, the username is #{ftp_user}, the password is #{ftp_pass}, and the web root directory is #{ftp_root}"

	if site5_addon == "yes"
		puts "The Site5 username is #{site5_user} this will be put into the public_html/#{site5_addondir} directory"
	else
		puts "The site5 username is #{site5_user} this will be put into the public_html directory."
	end

	puts "Is this correct? (yes or no)"
	confirm = gets.chomp
	
	if confirm == "no"
		puts "Let's start over."
	else
	end
end	

#Generating the wget string

if site5_addon == "no"
	puts "Use this one-liner to begin the migration:"
	puts "cd /home/#{site5_user}/ && wget -m --user='#{ftp_user}' --password='#{ftp_pass}' -R 'php.ini' ftp://#{ftp_url}/#{ftp_root}/ && find . -name '.listing' -exec rm -fv '{}' \\; && mv #{ftp_url}/#{ftp_root}/* public_html/ && mv #{ftp_url}/#{ftp_root}/.htaccess public_html/ && rm -rf #{ftp_url} && cd public_html && find . -type d -exec chmod 755 {} \\; && find . -type f -exec chmod 644 {} \\; && cd /home/#{site5_user} && chmod 750 public_html && chown -R #{site5_user}: public_html && chown #{site5_user}:nobody public_html"
else
	puts "Use this one-liner to begin the migration:"
	puts "cd /home/#{site5_user}/public_html && wget -m --user='#{ftp_user}' --password='#{ftp_pass}' -R 'php.ini' ftp://#{ftp_url}/#{ftp_root}/ && find . -name '.listing' -exec rm -fv '{}' \\; && mv #{ftp_url}/#{ftp_root}/* #{site5_addondir}/ && mv #{ftp_url}/#{ftp_root}/.htaccess #{site5_addondir}  && rm -rf #{ftp_url}  && find . -type d -exec chmod 755 {} \\; && find . -type f -exec chmod 644 {} \\; && cd /home/#{site5_user} && chmod 750 public_html && chown -R #{site5_user}: public_html && chown #{site5_user}:nobody public_html"
end
