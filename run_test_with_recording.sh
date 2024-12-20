#!/bin/bash

# Variables
SCREEN_RECORD_PATH="/sdcard/app_test_recording.mp4"
LOCAL_RECORD_PATH="./app_test_recording.mp4"
TEST_DRIVER="test_driver/integration_test_driver.dart"
TEST_TARGET="integration_test/app_test.dart"
LOG_FILE="./test_run_logs.txt"

# Function to check for ADB
check_adb_installed() {
  if ! command -v adb &> /dev/null
  then
    echo "Error: adb is not installed or not in PATH. Install it and try again." | tee -a "$LOG_FILE"
    exit 1
  fi
}

# Function to check for Flutter
check_flutter_installed() {
  if ! command -v flutter &> /dev/null
  then
    echo "Error: Flutter is not installed or not in PATH. Install it and try again." | tee -a "$LOG_FILE"
    exit 1
  fi
}

# Start Screen Recording
echo "Starting screen recording..." | tee -a "$LOG_FILE"
adb shell screenrecord "$SCREEN_RECORD_PATH" &
RECORD_PID=$!

# Run Flutter Integration Test
echo "Running integration test..." | tee -a "$LOG_FILE"
flutter drive --driver="$TEST_DRIVER" --target="$TEST_TARGET" 2>&1 | tee -a "$LOG_FILE"
TEST_EXIT_CODE=${PIPESTATUS[0]}

# Stop Screen Recording
echo "Stopping screen recording..." | tee -a "$LOG_FILE"
kill $RECORD_PID

# Allow some time to finalize the recording
sleep 2

# Pull the recorded file to the local machine
echo "Pulling the recorded file to the local machine..." | tee -a "$LOG_FILE"
adb pull "$SCREEN_RECORD_PATH" "$LOCAL_RECORD_PATH" 2>&1 | tee -a "$LOG_FILE"

# Verify the integrity of the pulled file
echo "Verifying the recording file integrity..." | tee -a "$LOG_FILE"
if ! ffmpeg -v error -i "$LOCAL_RECORD_PATH" -f null - 2>/dev/null; then
  echo "Error: Recording file is corrupted. Logs saved in $LOG_FILE." | tee -a "$LOG_FILE"
  exit 1
fi

# Check test result
if [ "$TEST_EXIT_CODE" -ne 0 ]; then
  echo "Integration test failed. Logs saved in $LOG_FILE. Check the recording at $LOCAL_RECORD_PATH for more details." | tee -a "$LOG_FILE"
  exit "$TEST_EXIT_CODE"
else
  echo "Integration test passed. Logs saved in $LOG_FILE. Recording saved as $LOCAL_RECORD_PATH." | tee -a "$LOG_FILE"
fi