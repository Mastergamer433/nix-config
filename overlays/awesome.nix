(self: super: 
  { myAwesome = super.awesome.overrideAttrs (old: rec 
    { pname = "myAwesome"; 
      version = "master"; 
      src = super.fetchFromGitHub {
        owner = "awesomeWM";
        repo = "awesome"; 
        rev = "a1f58ab97c90c85759a3b33a96af2bfd0b6fe78b"; 
        sha256 = "58gWCZcDumyN+bSZ4Jh6mfGtmBCFWDE7aqCpyWEK9x8=";
      }; 
      patches = []; 
    }); 
  } )
