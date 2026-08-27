# kakaotalk-flake

## Usage

```nix
{
  inputs = {
    nixpkgs.url         = "github:NixOS/nixpkgs/nixos-unstable";
    kakaotalk-flake.url = "github:kimhappy/kakaotalk-flake";
  };

  outputs = {
    nixpkgs        ,
    kakaotalk-flake,
    ...
  }: {
    nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays           = [ kakaotalk-flake.overlays.default ];
          environment.systemPackages = [ pkgs.kakaotalk ];
        })
      ];
    };
  };
}
```

## Update

### Automation (GitHub Actions)

1. Enable Actions. Go to *Settings -> Actions -> General -> Actions permissions* and select *Allow all actions and reusable workflows*.
2. Allow the workflow to push. Go to *Settings -> Actions -> General -> Workflow permissions* and select *Read and write permissions*.

### Running it manually

*Actions -> Update KakaoTalk installer → Run workflow*, or:

```sh
gh workflow run update-installer.yml
gh run watch
```
