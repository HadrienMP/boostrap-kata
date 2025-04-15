# TODO

A checklist for building the Bash-based “bootstrap kata” script incrementally.

---

## Overview of Chunks

This project is split into **eight** main chunks (A–H). Each chunk includes micro-steps to ensure safe, incremental progress.

1. **Chunk A**: Basic Script and Dependency Checking
2. **Chunk B**: Listing Available Sandboxes
3. **Chunk C**: Sandbox & Kata Name Input
4. **Chunk D**: Directory Name Generation and Collision Checking
5. **Chunk E**: Create and Enter the Directory (Flake Initialization)
6. **Chunk F**: Environment Configuration and Test Execution
7. **Chunk G**: Git Initialization
8. **Chunk H**: Final Integration and Cleanup

Mark each step as you complete it:

---

## Chunk A: Basic Script and Dependency Checking

1. **Create Script Skeleton**
    - [ ] Create `bootstrap-kata.sh`
    - [ ] Add `#!/usr/bin/env bash`
    - [ ] Add `set -e` (or similar strictness)
    - [ ] Print a simple “Starting…” message
2. **Check Dependencies**

    - [ ] Implement `check_dependencies` function
    - [ ] Verify presence of `nix`, `git`, and `direnv` in `PATH`
    - [ ] If missing, exit with an error
    - [ ] Call `check_dependencies` in the main flow

3. **Test & Verify**
    - [ ] Run the script
    - [ ] Confirm it exits cleanly if dependencies are present
    - [ ] Confirm it errors out if any dependency is missing

---

## Chunk B: Listing Available Sandboxes

1. **Add `list_sandboxes` Function**

    - [ ] Call `nix flake show gitlab:pinage404/nix-sandboxes`
    - [ ] Parse the output for sandbox identifiers (subdirs, etc.)
    - [ ] Print the sandbox names in a user-friendly format
    - [ ] Error handling if `nix flake show` fails

2. **Integrate with Main Flow**

    - [ ] Call `list_sandboxes` right after `check_dependencies`
    - [ ] For now, exit after listing sandboxes

3. **Test & Verify**
    - [ ] Confirm sandbox names appear when script is run
    - [ ] Confirm error if the command fails

---

## Chunk C: Sandbox & Kata Name Input

1. **Add Command-Line Parsing**

    - [ ] Parse `--sandbox` and `--kata` flags using `$@`
    - [ ] Store these in variables if provided

2. **Prompt Interactively If Missing**

    - [ ] If `--sandbox` not provided, prompt user with `read -p`
    - [ ] If `--kata` not provided, prompt user with `read -p`

3. **Sanitize Kata Name**

    - [ ] Implement `sanitize_kata` function
    - [ ] Convert name to lowercase
    - [ ] Remove invalid characters (only letters, digits, underscores, dashes, periods)

4. **Echo Chosen Values**

    - [ ] Print chosen sandbox and kata name
    - [ ] Exit to test

5. **Test & Verify**
    - [ ] Run with flags (both provided)
    - [ ] Run with only `--sandbox`, only `--kata`, or none
    - [ ] Confirm correct user prompts and sanitization

---

## Chunk D: Directory Name Generation and Collision Checking

1. **Generate Directory Name**

    - [ ] Use `<sandbox-kebab>-<kata-kebab>-<YYYY-MM-DD>` format
    - [ ] Convert dates to `YYYY-MM-DD` (e.g., `date +%F` in Bash)

2. **Ensure Uniqueness**

    - [ ] Write `ensure_unique_directory` function
    - [ ] Check if dir exists
    - [ ] If yes, append `-1`, `-2`, etc.
    - [ ] Return final unique name

3. **Echo Final Directory Name & Exit**

    - [ ] Print the chosen directory name
    - [ ] Exit to confirm

4. **Test & Verify**
    - [ ] Test with a directory name that doesn’t exist
    - [ ] Test with a directory name that does exist (check it appends -1, -2, etc. properly)

---

## Chunk E: Create and Enter the Directory (Flake Initialization)

1. **Create & Enter Directory**

    - [ ] Implement `create_and_enter_directory` function
    - [ ] Run `nix flake new --template "gitlab:pinage404/nix-sandboxes#<sandbox>" <directory-name>`
    - [ ] `cd` into the new directory
    - [ ] Catch errors and exit with an informative message if fails

2. **Print Success or Error**

    - [ ] Echo a message if directory creation succeeded
    - [ ] Echo an error and exit if something went wrong

3. **Test & Verify**
    - [ ] Confirm new directory is created
    - [ ] Confirm the script changes into it
    - [ ] Confirm no collisions with existing directories

---

## Chunk F: Environment Configuration and Test Execution

1. **Initialize Environment**

    - [ ] Run `direnv allow`
    - [ ] Check for errors

2. **Run Tests**

    - [ ] Run `mask test`
    - [ ] If test fails, display the error output, exit
    - [ ] If test passes, echo success

3. **Test & Verify**
    - [ ] Confirm `direnv allow` works
    - [ ] Simulate a failing test
    - [ ] Confirm the script exits with an error message
    - [ ] Confirm success message appears if tests pass

---

## Chunk G: Git Initialization

1. **Initialize Git**

    - [ ] `git init`
    - [ ] `git add .`
    - [ ] `git commit -m "Initial commit"`

2. **Error Handling**

    - [ ] If any Git command fails, print an error and exit
    - [ ] Otherwise, echo success

3. **Test & Verify**
    - [ ] Confirm `.git` directory is created
    - [ ] Confirm all files are committed
    - [ ] Ensure the initial commit message is visible (`git log`)

---

## Chunk H: Final Integration and Cleanup

1. **Real-Time Feedback**

    - [ ] Add `echo` statements for each chunk: “Checking dependencies…”, “Listing sandboxes…”, etc.

2. **Remove Debug / Orphan Code**

    - [ ] Delete any leftover debugging lines
    - [ ] Ensure script is cohesive

3. **Final Summary**

    - [ ] Print “Kata bootstrapped successfully!” (or similar) at the end
    - [ ] Exit with code 0

4. **Test & Verify (Full Flow)**
    - [ ] Run the script from scratch
    - [ ] Confirm each stage’s output is shown
    - [ ] Confirm tests pass if the flake’s template is okay
    - [ ] Confirm final Git commit is created
    - [ ] Validate error paths

---

## Optional Testing Additions

1. **Integration Tests**:

    - [ ] Write a secondary script or manual procedure that tries multiple scenarios:
        - [ ] Dependencies missing
        - [ ] Sandbox listing errors
        - [ ] Kata name collisions
        - [ ] Failing tests, etc.

2. **Cleanup**:
    - [ ] Confirm no leftover temporary files or directories
    - [ ] Confirm any appended `-1`, `-2` directories were created only when needed

---

## Usage

1. **Complete Each Chunk in Order**  
   Mark each box when done, ensuring incremental progress.
2. **Verify After Each Step**  
   Test thoroughly to catch issues early.
3. **Refine & Adjust**  
   If steps become too large or small, adapt accordingly.

**Good luck with your Bash script project!**
