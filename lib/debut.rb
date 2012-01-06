module Debut

	class CLI
		def self.run(*a)
			CLI.new.run(a)
		end


		def run(*a)
		 	user = `whoami`
		 	puts user
		 	dir = Dir.pwd
		 	confirm "Debify #{dir} (y/n)?"
		 	package = ask("Package Name? (If this should coexist with different versions embed the version in the name, and use 1.0 for version)")
		 	version = ask("Version (eg 1.0)")
		 	dest = ask("Where should this live when installed (/usr/some/path/to/it")
		 	name = ask("Maintainer Name?")
 			email = ask("Maintainer Email?")
 			desc = ask("Package Descrption?")
 			confirm <<-eos
Create deb #{package}_#{version}_amd64.deb?
living in #{dest}
maintainer #{name} <#{email}>
descrption #{desc}
???
 			eos
 			make(dir, package, version, dest, name, email, desc)
		end



	def ask(q)
			puts q
			gets.strip
	end

    def confirm(q)
    	if self.ask(q) != "y"
    		puts "exiting"
    		exit(1)
        end
    end

    def tellsys(cmd)
    	puts cmd
    	system cmd
	end
    

	def make(dir, package, version, dest, name, email, desc)
		tellsys "mkdir -p /tmp/#{package}#{dest}"	
		tellsys "mkdir -p /tmp/#{package}/DEBIAN"	
		tellsys "cp -r #{dir}/* /tmp/#{package}#{dest}"
		tellsys "md5sum `find /tmp/#{package} -type f | grep -v '^[.]/DEBIAN/'` >/tmp/#{package}/DEBIAN/md5sums"
		puts "creating /tmp/#{package}/DEBIAN/control"
		size = `du -s | cut -f 1` 
 		File::new("/tmp/#{package}/DEBIAN/control")
		File::open("/tmp/#{package}/DEBIAN/control", 'rw') do |f|
			f.write "Package: #{package}"
			f.write "Version: #{version}"
			f.write "Architecture: amd64"
			f.write "Maintainer: #{name} <#{email}>"
			f.write "Description: #{desc}"
			f.write "Installed-Size: #{size}"
		end
		tellsys "cd .."
		pust "dpkg-deb -b #{package}"

		
	end
end

end
