#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

CHECK_ICON="✅"
CROSS_ICON="❌"
INFO_ICON="ℹ️"
ARROW_ICON="➡️"
GEAR_ICON="⚙️"
DOC_ICON="📄"
CLOCK_ICON="⏰"

# --- Configuration ---
# Usage: ./scan_security.sh <report_output_base_directory> <scan_target_directory>

# Check if both required arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo -e "${RED}${CROSS_ICON} Usage: $0 <report_output_base_directory> <scan_target_directory>${NC}"
  echo -e "${YELLOW}${INFO_ICON}   <report_output_base_directory>: The base directory where scan reports will be saved (e.g., /var/sec_reports)${NC}"
  echo -e "${YELLOW}${INFO_ICON}   <scan_target_directory>: The directory containing the project to be scanned (e.g., /home/user/my_project)${NC}"
  exit 1
fi

# Get the raw path for the report base directory
REPORT_BASE_DIR_RAW="$1"
# Get absolute path for scan directory, which is expected to exist
SCAN_DIRECTORY=$(realpath "$2")

# Define a variable for the project name.
# This will be derived from the last component of the SCAN_DIRECTORY path.
PROJECT_NAME=$(basename "$SCAN_DIRECTORY")

# Reports will be placed in a subdirectory named after the PROJECT_NAME within the REPORT_BASE_DIR.
# We will construct the full path after ensuring REPORT_BASE_DIR exists and getting its realpath.
REPORT_OUTPUT_FULL_PATH=""

# List of Docker images required for the scans
REQUIRED_DOCKER_IMAGES=(
  "sqasupport/trivy:latest"
  "sqasupport/semgrep:latest"
  "zricethezav/gitleaks:latest"
)

# --- Functions ---

# Function to check and pull a Docker image
check_and_pull_docker_image() {
  local image_name="$1"
  echo -e "${CYAN}${ARROW_ICON} Checking for Docker image: ${image_name}${NC}"
  if [[ "$(docker images -q "$image_name" 2> /dev/null)" == "" ]]; then
    echo -e "${YELLOW}${INFO_ICON} Image '${image_name}' not found locally. Attempting to pull...${NC}"
    if docker pull "$image_name"; then
      echo -e "${GREEN}${CHECK_ICON} Successfully pulled '${image_name}'.${NC}"
    else
      echo -e "${RED}${CROSS_ICON} Error: Failed to pull Docker image '${image_name}'. Please check your Docker setup and network connection."
      echo -e "${RED}${CROSS_ICON} Exiting script.${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}${CHECK_ICON} Image '${image_name}' is already available locally.${NC}"
  fi
}

# --- Script Logic ---

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}${GEAR_ICON} Starting security scans.${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "${INFO_ICON} Scan Target Directory: ${CYAN}${SCAN_DIRECTORY}${NC}"
echo -e "${INFO_ICON} Report Output Base Directory (raw): ${CYAN}${REPORT_BASE_DIR_RAW}${NC}"
echo -e "${INFO_ICON} Project Name (derived): ${CYAN}${PROJECT_NAME}${NC}"
echo -e "${BLUE}-----------------------------------------------------${NC}"

# Validate the scan directory
if [ ! -d "$SCAN_DIRECTORY" ]; then
  echo -e "${RED}${CROSS_ICON} Error: Scan target directory '${SCAN_DIRECTORY}' does not exist.${NC}"
  exit 1
fi

# Check for package manager lock files
echo -e "${ARROW_ICON} Checking for package manager lock files (yarn.lock or package-lock.json)...${NC}"
if [ ! -f "$SCAN_DIRECTORY/yarn.lock" ] && [ ! -f "$SCAN_DIRECTORY/package-lock.json" && [ ! -f "$SCAN_DIRECTORY/gradle.lockfile" ]; then
  echo -e "${RED}${CROSS_ICON} Error: Neither 'yarn.lock' nor 'package-lock.json' nor 'gradle.lockfile' found in '${SCAN_DIRECTORY}'.${NC}"
  echo -e "${RED}${CROSS_ICON} This script expects a Node.js project with dependency lock files for accurate SCA.${NC}"
  exit 1
else
  echo -e "${GREEN}${CHECK_ICON} Found package manager lock file.${NC}"
fi

# Create the report base directory if it doesn't exist
echo -e "${ARROW_ICON} Creating report base directory: ${CYAN}${REPORT_BASE_DIR_RAW}${NC}"
mkdir -p "$REPORT_BASE_DIR_RAW"
if [ ! -d "$REPORT_BASE_DIR_RAW" ]; then
  echo -e "${RED}${CROSS_ICON} Error: Could not create report base directory '${REPORT_BASE_DIR_RAW}'.${NC}"
  exit 1
fi

# Now get the realpath of the report base directory after ensuring it exists
REPORT_BASE_DIR=$(realpath "$REPORT_BASE_DIR_RAW")
REPORT_OUTPUT_FULL_PATH="$REPORT_BASE_DIR/$PROJECT_NAME"

# Create the project-specific report output directory
echo -e "${ARROW_ICON} Creating project-specific report directory: ${CYAN}${REPORT_OUTPUT_FULL_PATH}${NC}"
mkdir -p "$REPORT_OUTPUT_FULL_PATH"
if [ ! -d "$REPORT_OUTPUT_FULL_PATH" ]; then
  echo -e "${RED}${CROSS_ICON} Error: Could not create project-specific report output directory '${REPORT_OUTPUT_FULL_PATH}'.${NC}"
  exit 1
fi
echo -e "${GREEN}${CHECK_ICON} Reports will be saved in: ${CYAN}${REPORT_OUTPUT_FULL_PATH}${NC}"
echo -e "${BLUE}-----------------------------------------------------${NC}"

# Check and pull all required Docker images
echo -e "${INFO_ICON} Verifying Docker images...${NC}"
for image in "${REQUIRED_DOCKER_IMAGES[@]}"; do
  check_and_pull_docker_image "$image"
done
echo -e "${GREEN}${CHECK_ICON} All required Docker images are ready.${NC}"
echo -e "${BLUE}-----------------------------------------------------${NC}"

echo -e "${BLUE}${CLOCK_ICON} Starting parallel scans...${NC}"

# --- Parallel Scans ---
# Docker commands need to map both the scan directory and the report output directory.
# We will map SCAN_DIRECTORY to /src inside containers.
# We will map REPORT_OUTPUT_FULL_PATH to /output inside containers.

# 1. Run Trivy for vulnerability scanning (SCA) in background
echo -e "${BLUE}${GEAR_ICON} Running Trivy (SCA) scan in background...${NC}"
docker run --rm \
  -v "$SCAN_DIRECTORY:/src" \
  -v "$REPORT_OUTPUT_FULL_PATH:/output" \
  sqasupport/trivy fs /src --scanners vuln --skip-db-update --include-dev-deps --format sarif > "$REPORT_OUTPUT_FULL_PATH/sca-report-$PROJECT_NAME.sarif" &
TRIVY_PID=$! # Store PID for later wait
echo -e "${INFO_ICON} Trivy scan started (PID: $TRIVY_PID).${NC}"

# 2. Run Semgrep for static analysis (SAST) in background
echo -e "${BLUE}${GEAR_ICON} Running Semgrep (SAST) scan in background...${NC}"
docker run --rm --network=none \
  -v "$SCAN_DIRECTORY:/src" \
  -v "$REPORT_OUTPUT_FULL_PATH:/output" \
  sqasupport/semgrep semgrep scan /src --dataflow-traces --config=/rules --metrics=off --sarif --sarif-output="/output/semgrep-report-$PROJECT_NAME.sarif" &
SEMGREP_PID=$! # Store PID for later wait
echo -e "${INFO_ICON} Semgrep scan started (PID: $SEMGREP_PID).${NC}"

# 3. Run Gitleaks for secret detection in background
echo -e "${BLUE}${GEAR_ICON} Running Gitleaks scan in background...${NC}"
docker run --rm \
  -v "$SCAN_DIRECTORY:/src" \
  -v "$REPORT_OUTPUT_FULL_PATH:/output" \
  zricethezav/gitleaks:latest dir /src -f json -r "/output/gitleaks-$PROJECT_NAME.json" &
GITLEAKS_PID=$! # Store PID for later wait
echo -e "${INFO_ICON} Gitleaks scan started (PID: $GITLEAKS_PID).${NC}"

# 6. Grep for password/secret patterns specifically in .env files in background
echo -e "${BLUE}${GEAR_ICON} Running grep for .env file patterns in background...${NC}"
grep -i -r -E "(password|secret|token|key)" --include="*.env" "$SCAN_DIRECTORY" > "$REPORT_OUTPUT_FULL_PATH/grep-env-$PROJECT_NAME.txt" &
GREP_ENV_PID=$! # Store PID for later wait
echo -e "${INFO_ICON} Grep for .env files started (PID: $GREP_ENV_PID).${NC}"

# 7. Grep for 'password' in git log history in background
echo -e "${BLUE}${GEAR_ICON} Running grep for 'password' in git log in background...${NC}"
# Check if a .git directory exists within the SCAN_DIRECTORY before attempting to run git log.
if [ -d "$SCAN_DIRECTORY/.git" ]; then
  git -C "$SCAN_DIRECTORY" log -p | grep -i 'password' > "$REPORT_OUTPUT_FULL_PATH/grep-gitlog-$PROJECT_NAME.txt" &
  GITLOG_PID=$! # Store PID for later wait
  echo -e "${INFO_ICON} Grep for git log started (PID: $GITLOG_PID).${NC}"
else
  echo -e "${YELLOW}${INFO_ICON} Skipping git log scan: .git directory not found in ${CYAN}$SCAN_DIRECTORY${NC}"
  GITLOG_PID="" # Mark as not run
fi

echo -e "${BLUE}-----------------------------------------------------${NC}"
echo -e "${BLUE}${CLOCK_ICON} Running sequential grep scans...${NC}"

# --- Sequential Grep Scans (must run in order due to appending to the same file) ---

# 4. Grep for common password/secret patterns in scan directory
echo -e "${BLUE}${GEAR_ICON} Running grep for password/secret patterns (type 1)...${NC}"
grep -i -r -E "(password|passwd|secret|api[-]*key|token|access[-]*key|private[-]*key|client[-]secret)\s" "$SCAN_DIRECTORY" > "$REPORT_OUTPUT_FULL_PATH/grep-password-$PROJECT_NAME.txt"
echo -e "${GREEN}${CHECK_ICON} Grep scan (type 1) completed. Results saved to ${DOC_ICON} ${CYAN}$REPORT_OUTPUT_FULL_PATH/grep-password-$PROJECT_NAME.txt${NC}"
echo ""

# 5. Grep for password/secret patterns with assignment operator
echo -e "${BLUE}${GEAR_ICON} Running grep for password/secret patterns (type 2)...${NC}"
grep -i -r -E "(password|passwd|secret|api[-]*key|token|access[-]key|private[-]*key|client[-]secret)\s=\s['\"]" "$SCAN_DIRECTORY" > "$REPORT_OUTPUT_FULL_PATH/grep-key-$PROJECT_NAME.txt"
echo -e "${GREEN}${CHECK_ICON} Grep scan (type 2) completed. Results saved to ${DOC_ICON} ${CYAN}$REPORT_OUTPUT_FULL_PATH/grep-key-$PROJECT_NAME.txt${NC}"
echo ""

echo -e "${BLUE}-----------------------------------------------------${NC}"
echo -e "${BLUE}${CLOCK_ICON} Waiting for parallel scans to complete...${NC}"

# Wait for all background jobs to finish
wait $TRIVY_PID
echo -e "${GREEN}${CHECK_ICON} Trivy scan process completed.${NC}"

wait $SEMGREP_PID
echo -e "${GREEN}${CHECK_ICON} Semgrep scan process completed.${NC}"

wait $GITLEAKS_PID
echo -e "${GREEN}${CHECK_ICON} Gitleaks scan process completed.${NC}"

wait $GREP_ENV_PID
echo -e "${GREEN}${CHECK_ICON} Grep for .env files process completed.${NC}"

if [ -n "$GITLOG_PID" ]; then # Only wait if git log was actually run
  wait $GITLOG_PID
  echo -e "${GREEN}${CHECK_ICON} Grep for git log process completed.${NC}"
fi

echo -e "${BLUE}=====================================================${NC}"
echo -e "${GREEN}${CHECK_ICON} All security scans completed successfully!${NC}"
echo -e "${BLUE}=====================================================${NC}"
