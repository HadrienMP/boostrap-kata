### Specification for Bootstrap Kata Script

#### **Objective:**

Create a Bash script that automates the process of bootstrapping a kata from a sandbox repository hosted on GitLab. The script will interact with the user to select a sandbox and kata, generate a new project directory, initialize the environment, run tests, and set up Git. It will also handle errors gracefully and clean up temporary files.

---

### **Features:**

1. **List Available Sandboxes:**

    - The script will query the GitLab repository (`gitlab:pinage404/nix-sandboxes`) to list all available sandboxes.
    - It will identify these sandboxes by searching for subdirectories containing a `flake.nix` file.
    - The sandbox list will be retrieved using the `nix flake show` command.

2. **User Input:**
    - **Sandbox Selection:** The script will display a list of available sandboxes and ask the user to select one (interactive or via a `--sandbox` flag).
    - **Kata Name:** The script will ask the user for a kata name (interactive or via a `--kata` flag).
3. **Directory Name Generation:**

    - The final directory name will be automatically normalized into the format:  
      `<language-as-kebab-case>-<kata-name-as-kebab-case>-<YYYY-MM-DD>`.
    - The kata name will be sanitized to comply with GitLab repository naming rules (lowercase, no spaces, no special characters, valid characters: letters, numbers, dashes, underscores, periods).
    - If the generated directory name already exists, the script will append a number to ensure uniqueness (e.g., `common-lisp-mars-rover-2024-04-15-1`).

4. **Directory Setup:**

    - Once the user has selected the sandbox and entered the kata name, the script will execute the following:
        ```bash
        nix flake new --template "gitlab:pinage404/nix-sandboxes#<selected-sandbox>" ./<generated-directory-name>
        ```
    - It will navigate into the newly created directory and run:
        ```bash
        direnv allow
        mask test
        ```
    - If `mask test` passes, it will then initialize a Git repository with:
        ```bash
        git init
        git add .
        git commit -m "Initial commit"
        ```

5. **Error Handling:**

    - **Missing Tools:** The script will check for the presence of `nix`, `git`, and `direnv`. If any are missing, it will display an error and terminate.
        - It will also ensure the environment variable `NIX_CONFIG="extra-experimental-features = flakes nix-command"` is set for flakes to work.
    - **Test Failures:** If `mask test` fails, the script will display the full test output, along with an error message.
    - **Directory Existence:** If the output directory already exists, the script will append a number to the name to avoid overwriting. If a directory with the same name exists after appending, it will try `-2`, `-3`, etc.
    - **Missing Sandbox or Kata Name:** If no sandbox or kata name is provided, the script will prompt the user for these details interactively.

6. **Logging and Output:**

    - The script will print real-time feedback to the terminal about each step as it progresses (e.g., “Creating sandbox directory”, “Running tests”, etc.).
    - If any step fails (e.g., test failure), the script will provide error details and suggest further steps (e.g., manual inspection of test results).
    - A summary of the steps completed will be displayed at the end of the process.

7. **Temporary Files:**
    - Any temporary files or directories created during the process (e.g., temporary directory names, intermediate files) will be cleaned up at the end of the script.

---

### **Architecture and Data Flow:**

1. **Dependency Management:**
    - The script will rely on the following tools:
        - **nix** (for fetching the flake template)
        - **direnv** (for environment management)
        - **mask** (for running tests)
        - **git** (for version control)
    - The script will check for the presence of `nix`, `git`, and `direnv` at the beginning. If any are missing, it will terminate with an appropriate error message.
2. **Directory Naming:**

    - The directory name will follow the structure:  
      `<sandbox-name>-<kata-name>-<YYYY-MM-DD>`.
    - The sandbox name and kata name will be sanitized and converted to lowercase.
    - A check will be performed to ensure that the final directory name is unique. If it exists, a number will be appended (e.g., `-1`, `-2`, etc.).

3. **Error Handling Strategy:**
    - The script will use `set -e` to halt execution on errors and provide useful error messages.
    - If a test fails or a command does not execute correctly, the script will:
        - Display the error message.
        - Suggest the next steps (e.g., manual inspection or fixing the issue).

---

### **Testing Plan:**

1. **Unit Tests:**

    - **Dependency Checks:** Test if the script correctly identifies missing dependencies (`nix`, `git`, `direnv`).
    - **Directory Naming:** Test the generation and sanitization of directory names to ensure they follow GitLab repository naming rules.
    - **Unique Directory Handling:** Test the behavior when an existing directory is found, ensuring the script appends numbers to avoid overwriting.
    - **Sandbox Listing:** Ensure the script correctly retrieves the available sandboxes from the GitLab repository using `nix flake show`.

2. **Integration Tests:**

    - **Full Workflow Test:** Simulate running the script from start to finish (from sandbox selection to Git repo initialization) to ensure the entire flow works as expected.
    - **Test Failures:** Simulate test failures and ensure the output is displayed correctly and the user is informed about the failure.

3. **Edge Case Tests:**
    - **Empty Kata Name:** Ensure the script prompts the user if no kata name is provided.
    - **Network Issues:** Simulate network issues (e.g., inability to fetch the flake) and ensure the script provides a clear error message.
    - **Existing Directories:** Ensure the script correctly appends numbers to directory names if a directory with the same name exists.

---

### **Implementation Notes:**

-   The script will be written in **Bash** and designed to be easily executable on systems where **nix**, **git**, and **direnv** are installed.
-   The script will be designed with simplicity and maintainability in mind, ensuring that future updates or modifications can be made with ease.

---

### **Next Steps:**

1. **Implementation**: A developer can begin implementing the script based on this specification.
2. **Testing**: After implementation, the testing plan can be followed to ensure the script works as expected.
3. **Deployment**: Once testing is successful, the script can be deployed for general use in bootstrapping kata projects from nix sandboxes.

---

This specification should provide everything a developer needs to start implementing the script. If any adjustments are required, feel free to reach out!
