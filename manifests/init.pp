class sogo {


 if $lsbdistid == 'Ubuntu' {
   $repo="deb http://inverse.ca/ubuntu $lsbdistcodename $lsbdistcodename"
   }

 if $lsbdistid == 'Debian' {
    $repo="deb http://inverse.ca/debian $lsbdistcodename $lsbdistcodename"
   } 

    exec {"add-repo":
    command => "/bin/echo $repo >> /etc/apt/sources.list",
    logoutput => true
    }

    exec {"add-key":
    command => "/usr/bin/apt-key adv --keyserver keys.gnupg.net --recv-key 0x810273C4 ",
    require => Exec ["add-repo"],
    notify => Exec ["apt-update"]
    }
    
    exec {"apt-update":
    command => "/usr/bin/apt-get update",
    }

    package {["sogo","memcached"]:
    ensure => latest,
    require => [Exec ["add-key"], Exec ["apt-update"]]
    }
  

    file {"/home/sogo/GNUstep/Defaults/.GNUstepDefaults":
    ensure => present ,
    owner => sogo,
    group => sogo,
    mode => 0600,
    content => template("sogo/GNUstepDefaults.erb"),
    require => Package ["sogo","memcached"]
    }

}
