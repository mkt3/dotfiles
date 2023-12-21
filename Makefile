deploy:
		nix build .#darwinConfigurations.mercury.system --extra-experimental-features 'nix-command flakes'
		./result/sw/bin/darwin-rebuild switch --flake .#mercury

