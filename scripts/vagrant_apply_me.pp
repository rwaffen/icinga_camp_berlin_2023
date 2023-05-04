host { 'puppet.example.com': host_aliases => ['puppet'], ip => '192.168.0.2', }
host { 'icinga.example.com': host_aliases => ['icinga'], ip => '192.168.0.3', }
host { 'agent1.example.com': host_aliases => ['agent2'], ip => '192.168.0.4', }
