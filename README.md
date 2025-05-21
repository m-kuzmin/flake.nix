# ❄ My `flake.nix`

This is my personal monorepo for Nix configurations. It includes both NixOS modules as well as devshells and custom
packages.

## This is my personal stuff

Meaning, if you wanna tailor this flake to your needs, fork or copy the code into your project. I will not be accepting
any issues or PRs unless they improve something. The only customer here is me.

> [!WARNING]
> The devshells configure git and other tools to use my personal Git credentials. You can override this by overriding
> the `identity` input of this flake.
>
> Here's how to specify credentials in your own flake:
> ```nix
> {
>   inputs.m-kuzmin.inputs.identity.follows = "";
>   outputs = {                             # |
>    self, # meaning this self <--------------|
>    m-kuzmin,
>    ...
>   }: { 
>     indentity.v1 = { ... };
>     inherit (m-kuzmin) devShells;
>   };
> }
> ```

## Copying

The code is MIT license, but I do not care if you use this in your projects.