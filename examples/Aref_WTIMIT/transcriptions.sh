#!/bin/bash

# Check if the folder path is provided as an argument
'''
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_directory>"
    exit 1
fi
'''

# Directory containing the .wav files
root_dir=/media/rf/T9/Paddlespeech_backup/WTIMIT_data_safe_folder/dev-clean_C_SD


# Output file
output_file="$root_dir/transcriptions.txt"

# Initialize the output file with header
echo -e "FileName\tTranscription" > "$output_file"

# Find all .wav files recursively in the specified directory
find "$root_dir" -type f -name "*.wav" | while IFS= read -r wav_file; do
    # Run the paddlespeech whisper command and capture the output
    echo "Transcribing $wav_file ..."
    transcription_output=$(paddlespeech whisper --task transcribe --language en --device cpu --input "$wav_file")
   
    # Extract the transcription text from the output
    transcription_text=$(echo "$transcription_output" | sed -n "s/.*'text': '\(.*\)', 'segments.*/\1/p")
   
    # Append the filename and transcription to the output file
    echo -e "$(basename "$wav_file")\t$transcription_text" >> "$output_file"
   
    # Display message indicating transcription completion
    echo "Transcription of $wav_file done!"
done

echo "Transcriptions have been saved to $output_file"
