#!/bin/bash
# Import the logging library
source /path/to/bash_logger.sh

# Optional: Configure logger
LOG_FILE="/var/log/myscripts/example.log"  # Custom log file path
LOG_LEVEL=5                                # Debug level (show all logs)
LOG_COLOR=true                             # Enable colors

# Example logging
log_info "Script started"
log_debug "Debug information: $PATH"

echo "Regular echo statement"

# Example function with logging
process_file() {
    local file="$1"
    
    log_info "Processing file: $file"
    
    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi
    
    log_debug "File size: $(wc -c < "$file") bytes"
    log_info "File processing complete"
    return 0
}

# Call the function
process_file "/etc/hosts"
process_file "/nonexistent/file"

# Want to capture all stdout/stderr to log file?
# Uncomment this line:
# setup_log_redirection

# After redirection, console output also goes to log file
echo "This goes to the log file"
ls -la /tmp

log_warn "This is a warning message"
log_info "Script completed successfully"

# Log is automatically restored on exit due to the trap in setup_log_redirection