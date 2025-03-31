#!/bin/bash
# bash_logger.sh - A reusable logging library for bash scripts
#
# Usage:
#   source /path/to/bash_logger.sh
#   
#   # Optional: Configure logger
#   LOG_FILE="/path/to/my/log.file"  # Default: ./script_name.log
#   LOG_LEVEL=3                      # Default: 3 (INFO)
#   LOG_COLOR=true                   # Default: true
#   LOG_TIMESTAMP=true               # Default: true
#   LOG_TO_CONSOLE=true              # Default: true
#
#   # Use logging functions
#   log_debug "Debugging information"
#   log_info "Process started"
#   log_warn "Config file not found, using defaults"
#   log_error "Failed to connect"
#   log_fatal "Critical error, exiting" && exit 1

# Default configuration
# Determine the name of the calling script
SCRIPT_NAME=$(basename "${BASH_SOURCE[1]}" 2>/dev/null || echo "unknown")
LOG_FILE="${LOG_FILE:-"${SCRIPT_NAME%.sh}.log"}"
LOG_LEVEL="${LOG_LEVEL:-3}" # 0=OFF, 1=FATAL, 2=ERROR, 3=INFO(default), 4=WARN, 5=DEBUG
LOG_COLOR="${LOG_COLOR:-true}"
LOG_TIMESTAMP="${LOG_TIMESTAMP:-true}"
LOG_TO_CONSOLE="${LOG_TO_CONSOLE:-true}"

# Create log directory if it doesn't exist
LOG_DIR=$(dirname "$LOG_FILE")
[[ ! -d "$LOG_DIR" && "$LOG_DIR" != "." ]] && mkdir -p "$LOG_DIR"

# Color definitions
if [[ "$LOG_COLOR" == true ]]; then
    COLOR_DEBUG='\033[0;34m'  # Blue
    COLOR_INFO='\033[0;32m'   # Green
    COLOR_WARN='\033[0;33m'   # Yellow
    COLOR_ERROR='\033[0;31m'  # Red
    COLOR_FATAL='\033[1;31m'  # Bold Red
    COLOR_RESET='\033[0m'     # Reset
else
    COLOR_DEBUG=''
    COLOR_INFO=''
    COLOR_WARN=''
    COLOR_ERROR=''
    COLOR_FATAL=''
    COLOR_RESET=''
fi

# Internal logging function
_log() {
    local level="$1"
    local level_name="$2"
    local color="$3"
    local message="$4"
    local timestamp=""
    
    # Check if level is enabled
    [[ "$LOG_LEVEL" -lt "$level" ]] && return 0
    
    # Format timestamp if enabled
    if [[ "$LOG_TIMESTAMP" == true ]]; then
        timestamp="[$(date +'%Y-%m-%d %H:%M:%S')]"
    fi
    
    # Format the log line
    local log_line="${timestamp}[${level_name}] ${message}"
    local console_line="${color}${log_line}${COLOR_RESET}"
    
    # Write to log file
    echo -e "$log_line" >> "$LOG_FILE"
    
    # Write to console if enabled
    if [[ "$LOG_TO_CONSOLE" == true ]]; then
        echo -e "$console_line"
    fi
}

# Logging functions for different levels
log_debug() {
    _log 5 "DEBUG" "$COLOR_DEBUG" "$*"
}

log_info() {
    _log 3 "INFO " "$COLOR_INFO" "$*"
}

log_warn() {
    _log 4 "WARN " "$COLOR_WARN" "$*"
}

log_error() {
    _log 2 "ERROR" "$COLOR_ERROR" "$*"
}

log_fatal() {
    _log 1 "FATAL" "$COLOR_FATAL" "$*"
}

# Redirect stdout and stderr to log file
setup_log_redirection() {
    exec 3>&1 4>&2                                        # Save original stdout and stderr
    trap 'cleanup_log_redirection' EXIT INT TERM          # Restore on exit or interrupt
    exec 1>>"$LOG_FILE" 2>&1                              # Redirect stdout and stderr to log file
    log_info "Log redirection set up. Output redirected to $LOG_FILE"
}

# Restore original stdout and stderr
cleanup_log_redirection() {
    log_info "Restoring standard output streams"
    exec 2>&4 1>&3                                        # Restore original stdout and stderr
}

# Log script start
log_info "===== Script $SCRIPT_NAME started ====="