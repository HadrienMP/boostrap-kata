Below is a **two-part deliverable**:

1. **A Detailed, Step-by-Step Blueprint** for building the Bash-based "bootstrap kata" script described in your specification. We’ll iterate on these steps to ensure they are small enough to be safe but big enough to keep the project moving forward.

2. **A Series of Code-Generation Prompts** that you can feed into your favorite code-generation LLM. These prompts are organized to follow each incremental step in the plan, preventing any “big jumps” in complexity and ensuring no orphaned code.

---

## Part 1: Detailed Blueprint

### **1. Initial Outline**

1. **Set up the Development Environment**

    - Ensure `bash`, `nix`, `git`, `direnv`, and `mask` are installed and configured.
    - Confirm `NIX_CONFIG="extra-experimental-features = flakes nix-command"` is set.
    - Decide on a directory or repository structure (perhaps a dedicated Git repo) to host the script.

2. **Create the Basic Script Skeleton**

    - Initialize a Bash script (`bootstrap-kata.sh` or a similar name).
    - Add a license/header block.
    - Set `set -e` (or a similar strict mode) for error handling.

3. **Implement Dependency Checks**

    - Write a function to confirm that `nix`, `git`, and `direnv` are present in `PATH`.
    - If any are missing, exit with an informative error.

4. **List Available Sandboxes**

    - Implement functionality to run `nix flake show gitlab:pinage404/nix-sandboxes`.
    - Parse out the subdirectories (or however you identify sandboxes).
    - Present these sandbox options to the user in an interactive or argument-based manner.

5. **Obtain Kata Name & Sandbox Selection**

    - Support both interactive and command-line-driven input for sandbox and kata name.
    - Validate and sanitize the kata name (e.g., convert to lowercase, remove invalid characters).

6. **Generate a Directory Name**

    - Combine the sandbox name, the sanitized kata name, and the current date (`YYYY-MM-DD`).
    - Check for directory collisions. If a directory already exists, append `-1`, `-2`, etc.

7. **Initialize the Project with `nix flake new`**

    - Create the new directory using the template:  
      `nix flake new --template "gitlab:pinage404/nix-sandboxes#<selected-sandbox>" <directory-name>`
    - Move into the newly created directory.

8. **Configure Environment and Run Tests**

    - Run `direnv allow` to initialize environment.
    - Run `mask test` to confirm everything is working.
    - On test failures, provide helpful error messages.

9. **Initialize Git**

    - If tests pass, create a new Git repository (`git init`), `git add .`, and `git commit -m "Initial commit"`.

10. **Implement Error Handling & Logging**

-   Provide informative messages at each step (e.g., “Creating new directory named X”, “Running tests”, etc.).
-   On errors, show a clear message and exit gracefully.

11. **Cleanup and Final Review**

-   Ensure no stray files are left behind.
-   Summarize what the script did (final directory name, success/fail messages, next steps).

12. **Add a Testing Suite** (optional or future extension)

-   Could be scripts that automate calling the main script in multiple scenarios to validate correctness.

---

### **2. Break Down into Iterative Chunks**

We’ll refine the above steps into **small, iterative chunks**. Each chunk builds on the previous, focusing on incremental progress and ensuring we can test each part before moving on.

#### **Chunk A**: Basic Script and Dependency Checking

1. Create the skeleton Bash script (`bootstrap-kata.sh`).
2. Add a simple usage/help section (just an `echo` for now).
3. Implement checks for `nix`, `git`, `direnv`.
4. End the script after confirming everything is installed.

#### **Chunk B**: Listing Available Sandboxes

1. From the script, run `nix flake show gitlab:pinage404/nix-sandboxes`.
2. Filter or parse the output to find recognizable sandbox names.
3. Display these sandbox names to the user and exit.

#### **Chunk C**: Sandbox & Kata Name Input

1. Implement command-line flags (`--sandbox`, `--kata`) for direct passing.
2. If flags are missing, prompt the user interactively (using `read`).
3. Validate and sanitize the `kata` name (lowercase, remove illegal chars).

#### **Chunk D**: Directory Name Generation and Collision Checking

1. Form the directory name `<sandbox-kebab>-<kata-kebab>-<yyyy-mm-dd>`.
2. If a directory already exists, append a number: `-1, -2, ...`.
3. Print the final chosen directory name.

#### **Chunk E**: Create and Enter the Directory (Flake Initialization)

1. Run `nix flake new --template "gitlab:pinage404/nix-sandboxes#<sandbox>"`.
2. `cd` into the newly created directory.
3. Confirm the directory creation was successful, else error.

#### **Chunk F**: Environment Configuration and Test Execution

1. Run `direnv allow`.
2. Run `mask test`.
3. If `mask test` fails, display the error and exit.
4. If it passes, continue.

#### **Chunk G**: Git Initialization

1. `git init`
2. `git add .`
3. `git commit -m "Initial commit"`

#### **Chunk H**: Final Integration and Cleanup

1. Provide real-time feedback throughout (echo steps).
2. Ensure no leftover temporary files.
3. Summarize process at the end (echo final success message).

---

### **3. Another Iteration of Breaking Down**

Now, let’s ensure each chunk’s steps are **small enough** to be safe but **big enough** to deliver something meaningful. We break them even further into what you might call “micro-steps” within each chunk. This ensures that each step is approachable:

**Chunk A** (Micro-steps)

1. Create empty `bootstrap-kata.sh`.
2. Add `#!/usr/bin/env bash` and `set -e`.
3. Print a “Starting…” message.
4. Implement a `check_dependencies` function.
5. Call `check_dependencies`.

**Chunk B** (Micro-steps)

1. Add a `list_sandboxes` function.
2. Run `nix flake show gitlab:pinage404/nix-sandboxes`.
3. Filter subdirectories in the output (maybe a `grep` or a more robust parse).
4. Print found sandboxes.

**Chunk C** (Micro-steps)

1. Parse `--sandbox` from `$@`.
2. Parse `--kata` from `$@`.
3. If absent, use `read` to prompt the user.
4. Write a `sanitize_kata_name` function (handle special chars).

…and so on. Each chunk can be similarly subdivided.

---

## Part 2: Code-Generation Prompts

Below are **eight** prompt sections—one for each chunk in the iterative plan. Each section is wrapped in \`\`\` to be fed to a code-generation LLM. The code-generation LLM should _append or modify_ the same script, rather than overwrite it. Adjust or combine these prompts to match your style of tool usage, but the essence is below.

---

### **Prompt A: Basic Script and Dependency Checking**

```text
You are a code-generation AI. We are creating a Bash script named bootstrap-kata.sh.
Here is our current objective:
1. Create an empty Bash script with a strict mode.
2. Implement a simple function to check that nix, git, and direnv exist in the PATH.
3. If any are missing, exit with an error message.

Please write a single Bash script named bootstrap-kata.sh with these features:
- Shebang line for bash
- set -e (or similar strictness)
- A function check_dependencies that checks for nix, git, and direnv
- Proper error-handling and exit codes
- A “main” execution flow that calls check_dependencies and ends

No other functionality yet; just produce the minimal viable code for these steps.
```

---

### **Prompt B: Listing Available Sandboxes**

```text
We have a Bash script bootstrap-kata.sh that can check dependencies.
Now we want to add a function list_sandboxes that:
1. Calls nix flake show gitlab:pinage404/nix-sandboxes
2. Parses the output for subdirectories or any clear identifying pattern
3. Prints those sandbox names in a user-friendly list
4. If an error occurs, print a clear error message

Please modify the existing script to add this new function,
and call list_sandboxes from the main flow after dependency checks,
then exit so we can test it.
Make sure the existing functionality (dependency check) remains intact.
```

---

### **Prompt C: Sandbox & Kata Name Input**

```text
We have a script that can list sandboxes. We now want to accept a --sandbox argument and a --kata argument. If the user does not supply these arguments, we prompt interactively.

Requirements:
1. Parse --sandbox and --kata from command-line arguments.
2. If either is missing, prompt the user with read.
3. Sanitize the kata name by making it lowercase and removing illegal characters (only letters, digits, underscores, dashes, periods).
4. Print out the final chosen sandbox and kata name for debugging (then we’ll exit for now).

Please modify the existing script to add these capabilities.
Preserve our existing code for dependency checks and list_sandboxes.
Include a function sanitize_kata that performs the name cleaning.
At the end, just echo the chosen sandbox and kata, then exit.
```

---

### **Prompt D: Directory Name Generation and Collision Checking**

```text
We now have a sandbox name and a kata name. Next steps:
1. Generate a directory name of the form <sandbox>-<kata>-<yyyy-mm-dd>.
2. Check if that directory exists. If it does, append -1, -2, etc., until we find a free name.
3. Print the final directory name.

Please extend the existing bootstrap-kata.sh script with:
- A function generate_directory_name that forms <sandbox>-<kata>-<date>
- A function ensure_unique_directory that appends -1, -2, etc. if needed
- Calls to these functions in the main flow (after we have sandbox/kata)
- Echo the final directory name and then exit so we can test

No other functionality changes yet. Keep the existing code intact.
```

---

### **Prompt E: Create and Enter the Directory (Flake Initialization)**

```text
We have a directory name. Now we want to:
1. Call nix flake new --template "gitlab:pinage404/nix-sandboxes#<sandbox>" <directory-name>
2. cd into that directory
3. If an error occurs, print an error and exit

Please update bootstrap-kata.sh to:
- Create a function create_and_enter_directory
- It should run nix flake new, then cd
- If anything fails, print an error
- At the end of main, confirm creation with a success message or error message, then exit

Preserve all prior steps (dependency checks, user input, directory name generation).
```

---

### **Prompt F: Environment Configuration and Test Execution**

```text
We now want to integrate direnv and mask testing:
1. After cd into the new directory, run direnv allow
2. Then run mask test
3. If mask test fails, show a clear error message and exit
4. If it passes, echo a success message

Please modify bootstrap-kata.sh:
- Add a function run_tests that performs the steps above
- Insert this call after the directory is created and we’ve cd’d
- If tests fail, exit. Otherwise continue.

Retain all previous code. Don’t finalize Git yet.
```

---

### **Prompt G: Git Initialization**

```text
Now we want to add the final Git initialization if the tests pass:
1. git init
2. git add .
3. git commit -m "Initial commit"

Please modify the existing bootstrap-kata.sh:
- Add a function initialize_git
- Call initialize_git after run_tests indicates success
- If any Git step fails, print an error and exit
- Otherwise, echo a success message

Keep all other functionality intact.
```

---

### **Prompt H: Final Integration and Cleanup**

```text
We want to polish our script:
1. Provide real-time feedback during each step (echo statements like “Checking dependencies...”, “Listing sandboxes...”, etc.).
2. Ensure no orphan code or leftover debugging lines.
3. Summarize success at the end (echo “Kata bootstrapped successfully!” or something similar).
4. Confirm that everything is in a single, cohesive script with all functions working in sequence.

Please provide the complete final version of bootstrap-kata.sh with:
- All the prior functionalities integrated
- Clear step-by-step echo statements
- An overall final confirmation message

After this final output, we should have a production-ready script.
```

---

## Closing Notes

1. **Usage**: Copy each **Prompt (A–H)** in turn into your code-generation LLM, wait for the script to be updated, and then proceed to the next. This ensures that the script evolves iteratively and all parts are integrated.

2. **Testing**: After each step, run the partial script, verify it does what you expect. If something goes wrong, fix it incrementally or re-prompt your LLM to correct the specific issue.

3. **Refining**: If needed, add more micro-steps inside each prompt or add new prompts in between if the code-generation LLM lumps too much logic at once. The goal is safety (small steps) and momentum (incremental progress).

With these instructions and prompts, you have a solid plan and actionable guide to build the “bootstrap kata” Bash script incrementally. Each prompt produces code that builds on the previous version, ensuring consistency, best practices, and a fully integrated final result.
