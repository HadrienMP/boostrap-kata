# Makata - The kata bootstraper

This Bash script automates the process of bootstrapping a kata project from a sandbox repository hosted on GitLab. It helps developers quickly set up a new kata with the correct environment, dependencies, and Git setup.

---

## Features

-   **List Available Sandboxes:** The script will list all available sandboxes in the GitLab repository `gitlab:pinage404/nix-sandboxes` by querying the `flake.nix` files.
-   **Interactive & CLI Support:** Users can interact with the script to choose the sandbox and kata, or pass them as arguments via flags.
-   **Directory Name Normalization:** Automatically generates a valid directory name based on the sandbox, kata name, and the current date.
-   **Directory Setup:** It will initialize the project with the sandbox template, set up the environment, run tests, and initialize a Git repository.
-   **Error Handling:** If any steps fail, the script provides detailed error messages and guidance for manual resolution.
-   **Logging & Feedback:** Real-time output of each step of the process and a summary at the end.
-   **Clean-Up:** Temporary files and directories created during the process will be cleaned up.

---

## Requirements

Before running the script, ensure you have the following installed:

-   **nix** (for handling flakes)
-   **git** (for initializing the repository)
-   **direnv** (for managing environment variables)

The script will automatically install `mask` as part of the sandbox setup, so no need to worry about that.

---

## Installation

1. Clone the repository:

    ```bash
    git clone https://gitlab.com/your-repo/bootstrap-kata.git
    cd bootstrap-kata
    ```

2. Make the script executable:

    ```bash
    chmod +x bootstrap-kata.sh
    ```

---

## Usage

### Interactive Mode

Run the script without arguments to start the interactive mode:

```bash
./bootstrap-kata.sh
```

-   The script will prompt you to select a sandbox and provide a kata name.

### CLI Mode

You can also pass the sandbox and kata name as arguments:

```bash
./bootstrap-kata.sh --sandbox <sandbox-name> --kata "<kata-name>"
```

You can also use short flags:

```bash
./bootstrap-kata.sh -s <sandbox-name> -k "<kata-name>"
```

### Example

To create a kata based on the `common_lisp` sandbox for the "mars rover" kata:

```bash
./bootstrap-kata.sh --sandbox common_lisp --kata "mars rover"
```

This will:

-   List available sandboxes
-   Prompt for the kata name if not provided
-   Generate a directory like `common-lisp-mars-rover-2024-04-15`
-   Set up the environment, run the tests, and initialize a Git repository

---

## Error Handling

If an error occurs during the process (e.g., missing dependencies, test failures), the script will:

-   Provide detailed error messages
-   Offer suggestions for the next steps (e.g., running tests manually or fixing missing dependencies)
-   Output the test results if `mask test` fails

---

## Directory Naming

The script will automatically generate a valid directory name based on the sandbox and kata name, using the format:

```
<language-as-kebab-case>-<kata-name-as-kebab-case>-<YYYY-MM-DD>
```

If a directory already exists, it will append a number to make it unique (e.g., `-1`, `-2`).

---

## Cleanup

Any temporary files or directories created during the setup process will be automatically cleaned up by the script once it's done.

---

## License

MIT License. See [LICENSE](LICENSE) for more information.

---

## Contributing

Feel free to open an issue or submit a pull request if you'd like to contribute to this project!
