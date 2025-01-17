{ pkgs, inputs, ... }:
{
  imports =
    [
      inputs.sops-nix.nixosModules.sops
    ];
  ###
  # System
  ###
  system.stateVersion = "24.05";

  ###
  # Networking
  ###
  networking = {
    hostName = "vm-adb";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };

  ###
  # Users
  ###
  users.users = {
    root = {
      password = "";
    };
    android = {
      isSystemUser = true;
      description = "adb user account";
      group = "users";
      extraGroups = [ "adbusers" ];
    };
  };
  users.motd = ''

              d8b                                                 
              Y8P                                                 
                                                                  
88888b.d88b.  888  .d8888b 888d888 .d88b.  888  888 88888b.d88b.  
888 "888 "88b 888 d88P"    888P"  d88""88b 888  888 888 "888 "88b 
888  888  888 888 888      888    888  888 Y88  88P 888  888  888 
888  888  888 888 Y88b.    888    Y88..88P  Y8bd8P  888  888  888 
888  888  888 888  "Y8888P 888     "Y88P"    Y88P   888  888  888                                                                
                                                                                                                                    
                              888 888                             
                              888 888                             
                              888 888                             
                 8888b.   .d88888 88888b.                         
                    "88b d88" 888 888 "88b                        
                .d888888 888  888 888  888                        
                888  888 Y88b 888 888 d88P                        
                "Y888888  "Y88888 88888P"                         
'';

  environment.interactiveShellInit = ''
    export PS1="\n\[\033[1;31m\][\[\e]0;\u@\h:\w\a\] \u @\[\033[0;35m\] \h\[\033[1;31m\]: \w]\n $ \[\033[0m\]"
    color_prompt=yes
    alias vi="vim"
    alias nano="vim"
    alias edit="vim"
  '';

  ###
  # Services
  ###
  services.tailscale.enable = true;

  ###
  # Packages
  ###
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    usbutils
    vim
  ];

  ###
  # Virtual Machine
  ###
  microvm = {
    hypervisor = "qemu";
    socket = "control.socket";
    mem = 3 * 1024;
    vcpu = 2;

    interfaces = [ {
      type = "user";
      id = "qemu";
      mac = "02:00:00:01:01:01";
    } ];

    volumes = [{
      mountPoint = "/";
      image = "vm-adb.img";
      size = 8 * 1024;
    }];

    shares = [{
      proto = "9p";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];
  };

  microvm.qemu.extraArgs = [
    "-usb"
    "-device" "bus=usb-bus."
  ];
}
