module Debut

	class CLI
		def self.run(*a)
			CLI.new.run(a)
		end


		def run(*a)
		 	user = `whoami`.strip
		 	if user != "root"
		 		confirm "Current user #{user}. This should almost always be run as root are you sure (y/n)"
		    end
		 	dir = Dir.pwd
		 	confirm "Debify #{dir} (y/n)?"
		 	package = ask("Package Name? (If this should coexist with different versions embed the version in the name, and use 1.0 for version)")
		 	version = ask("Version (eg 1.0)")
		 	dest = ask("Where should this live when installed (/usr/some/path/to/it)")
		 	name = ask("Maintainer Name?")
 			email = ask("Maintainer Email?")
 			desc = ask("Package Descrption?")
            tell "Create deb #{package}_#{version}_amd64.deb?"
            tell "living in #{dest}"
            tell "maintainer #{name} <#{email}>"
            tell "descrption #{desc}"
 			confirm "y/n"
 			make(dir, package, version, dest, name, email, desc)
		end



	def ask(q)
			tell q
			gets.strip
	end

    def confirm(q)
    	if self.ask(q) != "y"
    		tell "exiting"
    		exit(1)
        end
    end

    def tellsys(cmd)
        tell cmd
    	system cmd
	end

    def tell(msg)
    	puts "==>  #{msg}"
    end

    

	def make(dir, package, version, dest, name, email, desc)
		packdir = "#{package}_#{version}_amd64"
		tellsys "mkdir -p /tmp/#{packdir}#{dest}"	
		tellsys "mkdir -p /tmp/#{packdir}/DEBIAN"	
		tellsys "cp -r #{dir}/* /tmp/#{packdir}#{dest}"
		tellsys "cd /tmp/#{packdir} && md5sum `find . -type f | grep -v '^[.]/DEBIAN/'` >DEBIAN/md5sums"
		tell "creating /tmp/#{packdir}/DEBIAN/control"
		size = `du -s | cut -f 1` 
		File::open("/tmp/#{packdir}/DEBIAN/control", 'w+') do |f|
			f.write "Package: #{package}\n"
			f.write "Version: #{version}\n"
			f.write "Architecture: amd64\n"
			f.write "Maintainer: #{name} <#{email}>\n"
			f.write "Description: #{desc}\n"
			f.write "Installed-Size: #{size}\n"
		end
		tellsys "dpkg-deb -b /tmp/#{packdir}"
        tell "Deb created in /tmp/#{packdir}.deb"
		
	end
end

end
