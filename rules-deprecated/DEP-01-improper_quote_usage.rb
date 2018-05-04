rule 'DEPJUL010', 'Do not quote Booleans' do
  tags %w{implementation improper_quote_usage}
  recipe do |ast, file|
    lines = File.readlines(file)
    lines.collect.with_index do |line, index|
        if line.match("\"true\"") || line.match("\"false\"") || line.match("\'true\'") || line.match("\'false\'")
        {
          :filename => file,
          :matched => file,
          :line => index + 1,
          :column => 0
        }
      end
    end.compact
  end
end

rule 'DEPJUL011', 'Do not use variables in single quoted string --> Unguarded Variable smell wont get detected properly' do
  tags %w{style improper_quote_usage}
  recipe do |ast, file|
    lines = File.readlines(file)
    lines.collect.with_index do |line, index|
      quote = line.scan(/'(.*)'/).flatten #every line new array - does flatten makes sense? scan returns an array of arrays
      if (quote[0] =~ /(.*)#\{(.*)\}(.*)/ && !quote[0].include?("\'")) #lines with single quotes including single quotes are not catched, since it throws a ruby syntax error in the first place
        #only testing one occurence in line?
        #puts "#{quote}" #debug
        {
          :filename => file,
          :matched => file,
          :line => index + 1,
          :column => 0
        }
      end
    end.compact
  end
end

rule 'DEPJUL012', 'Quote resource titles' do
  tags %w{style improper_quote_usage}
  recipe do |ast, file|
    vararr = []
    ast.xpath(%q{//var_field/ident/@value|//var_ref/ident/@value}).each do |var|
      unless vararr.include?(var.to_s)
       vararr << var.to_s
      end
    end
    lines = File.readlines(file)
    lines.collect.with_index do |line, index|
      bool=0
      if (line =~ /^(\s*)(template|apt_package|apt_repository|apt_update|bash|batch|bff_package|breakpoint|chef_gem|chef_handler|chocolatey_package|cookbook_file|cron|csh|deploy|directory|dpkg_package|dsc_resource|dsc_script|env|erl_call|execute|freebsd_package|file|gem_package|git|homebrew_package|group|http_request|ifconfig|ips_package|ksh|link|log|macports_package|mdadm|mount|ohai|openbsd_package|package|pacman_package|osx_profile|paludis_package|perl|portage_package|powershell_script|python|reboot|registry_key|remote_directory|remote_file|route|rpm_package|ruby|ruby_block|script|service|smartos_package|subversion|solaris_package|template|user|windows_service|windows_package|yum|yum_repository|zypper)(.*)do(\s)*$/) #all resources
        if(!(line =~ /(.*)\"(.*)\"(.*)/) && !(line =~ /(.*)'(.*)'(.*)/) && !line.include?("node"))
          vararr.each do |var|
            if line.include?(var)
              bool =1
            end
          end
          if(bool==0)
            {
              :filename => file,
              :matched => file,
              :line => index + 1,
              :column => 0
            }
          end
        end
      end
    end.compact
  end
end
