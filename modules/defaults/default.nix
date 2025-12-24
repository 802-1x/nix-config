{ self, ... }:
{
  imports = with self.nixosModules; [
    current-system-packages
    ephemeral-shells
    locale
  ];
}
