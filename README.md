# IC Tools Flake

This repository hosts a Nix flake for the Internet Computer (IC) toolchain, focusing on providing a reproducible development environment with `dfx`, the command-line tool for developing, deploying, and managing Internet Computer projects.

Ah, I see! You're referring to using `devenv.sh`, a tool for managing project-specific development environments defined by declarative configurations. Given this clarification, let's revise the section to incorporate `devenv.sh` from [devenv.sh](https://devenv.sh/packages/) as a method for setting up and using the development environment for your Nix flake project.

### Updated Installation and Usage Section with `devenv.sh`

---

## Installation and Usage

### Setting Up with Nix

To utilize the development environment managed by this project's Nix flake, you have a couple of options depending on whether you want the environment globally available or project-specific.

#### Globally with Nix Profile

For a global installation that makes `dfx` and other dependencies accessible system-wide, use:

```bash
nix profile install github:wscoble/ic-tools
```

This command integrates the tools directly into your Nix user profile.

## Features

- **Reproducible Environment**: Leverages Nix flakes to ensure a consistent development environment across all machines.
- **Automated Updates**: Includes GitHub Actions workflows to automatically update `dfx` versions and dependencies.
- **Multi-Architecture Support**: Offers initial support for x86_64 Linux and macOS, with efforts made to accommodate Apple Silicon (M1/M2) through Rosetta 2.

## Getting Started

To use this flake in your Nix environment, ensure you have Nix with flake support installed. If you're new to Nix, follow the [official Nix installation guide](https://nixos.org/download.html).

### Using the Flake

To integrate the IC tools flake into your project, you can add it as an input to your project's `flake.nix`:

```nix
{
  inputs.ic-tools-flake.url = "github:wscoble/ic-tools";
  
  outputs = { self, nixpkgs, ic-tools-flake, ... }: {
    // Your flake outputs
  };
}
```

### Development Shell

To enter a development shell with `dfx` and other tools available:

```bash
nix develop github:wscoble/ic-tools
```

## Contributing

Contributions to the IC Tools Flake are welcome. Whether it's feature requests, bug reports, or code contributions, please feel free to make a pull request or open an issue.

### Reporting Issues

Please use the GitHub Issues page to report any bugs or feature requests.

### Pull Requests

1. Fork the repository.
2. Create a new branch for your changes.
3. Make your changes and test them.
4. Submit a pull request with a comprehensive description of the changes.

## Automated Workflows

This project uses several GitHub Actions workflows to automate maintenance tasks:

- **PR Checks**: Runs on pull requests to ensure changes don't break the build or `dfx` executable.
- **Update DFX Version and Hashes**: Periodically checks for new `dfx` releases and updates the flake accordingly.
- **Create Release**: Automatically creates a new release when changes are merged into the main branch, including a link to the `dfx` source release.

## Limitations

While efforts are made to support Apple Silicon through Rosetta 2, direct testing and support for `aarch64-darwin` is limited by the current capabilities of GitHub Actions and the availability of native tools.

## License

This project is licensed under the [CC0 1.0 Universal License](LICENSE).

## Acknowledgments

- Thanks to the Internet Computer and DFINITY for providing the tools and inspiration for this project.
- This project is not officially affiliated with or endorsed by DFINITY.
