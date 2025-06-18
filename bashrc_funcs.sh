## Optimizes PDFs aggressively.
## Primarily as feedstock to LLMs, or for archiving.
##
## Usage: optimize_pdf <input_file.pdf> <output_directory_or_file.pdf>
##
## Examples:
##   optimize_pdf original.pdf optimized_docs/
##   optimize_pdf report.pdf report_optimized.pdf

optimize_pdf() {
  local unoptimized_pdf="$1"
  local output_destination="$2" # This will now be required

  if [[ -z "$unoptimized_pdf" || -z "$output_destination" ]]; then
    echo "Usage: optimize_pdf <input_file.pdf> <output_directory_or_file.pdf>"
    echo "       <output_directory_or_file.pdf> can be a directory (to save with original filename)"
    echo "       or a new filename (e.g., 'optimized_report.pdf')."
    return 1 # Use 'return' for functions instead of 'exit'
  fi

  if [[ ! -e "$unoptimized_pdf" ]]; then
    echo "Error: Input file '$unoptimized_pdf' not found."
    return 1
  fi

  local output_file=""

  # Determine if the output_destination is a directory or a filename
  if [[ -d "$output_destination" ]]; then
    # If it's a directory, construct the output filename using the original name
    output_file="$output_destination/$(basename "$unoptimized_pdf")"
  else
    # Otherwise, treat it as a full output filename
    output_file="$output_destination"
  fi

  # Add a check to prevent overwriting the input file
  if [[ "$(realpath "$unoptimized_pdf")" == "$(realpath "$output_file")" ]]; then
    echo "Error: Output file '$output_file' would overwrite the input file '$unoptimized_pdf'."
    echo "       Please specify a different output filename or directory."
    return 1
  fi

  echo "Optimizing '$unoptimized_pdf' to '$output_file'..."

  gs \
    -q -dNOPAUSE -dBATCH -dSAFER \
    -sDEVICE=pdfwrite \
    -dPDFSETTINGS=/ebook \
    -dFastWebView \
    -dCompatibilityLevel=1.4 \
    -dNOTRANSPARENCY \
    -dHaveTransparency=false \
    -dTransferFunctionInfo=/Apply \
    -dPreserveHalftoneInfo=false \
    -dPreserveMarkedContent=false \
    -dUCRandBGInfo=/Remove \
    -dPreserveOverprintSettings=false \
    -dDetectDuplicateImages=true \
    -dCompressFonts=true -dEmbedAllFonts=true -dSubsetFonts=true \
    -sProcessColorModel=DeviceGray \
    -sColorConversionStrategy=Gray \
    -dColorImageDownsampleThreshold=0.5 \
    -dGrayImageDownsampleThreshold=0.5 \
    -dMonoImageDownsampleThreshold=0.5 \
    -dDownsampleColorImages=true \
    -dColorImageFilter=/DCTEncode \
    -dColorImageDownsampleType=/Bicubic \
    -dColorImageResolution=96 \
    -dDownsampleGrayImages=true \
    -dGrayImageFilter=/DCTEncode \
    -dGrayImageDownsampleType=/Bicubic \
    -dGrayImageResolution=96 \
    -dDownsampleMonoImages=true \
    -dMonoImageDownsampleType=/Bicubic \
    -dMonoImageResolution=96 \
    -sOutputFile="$output_file" \
    "$unoptimized_pdf"

  if [[ $? -eq 0 ]]; then
    echo "Optimization complete: '$output_file'"
    # Compare file sizes
    local original_size=$(du -h "$unoptimized_pdf" | awk '{print $1}')
    local optimized_size=$(du -h "$output_file" | awk '{print $1}')
    echo "Original size: $original_size, Optimized size: $optimized_size"
  else
    echo "Error: PDF optimization failed."
    return 1
  fi
}

# Make and enter directory
mcd() {
  mkdir -p "$1" && cd "$1"
}

# short-hand for archives
extract () {
   if [ -f "$1" ] ; then
       case "$1" in
           *.tar.bz2)   tar xvjf "$1"    ;;
           *.tar.gz)    tar xvzf "$1"    ;;
           *.tar.xz)    tar xvJf "$1"    ;;
           *.tar)       tar xvf "$1"     ;;
           *.tgz)       tar xvzf "$1"    ;;
           *.zip)       unzip "$1"       ;;
           *.rar)       unrar x "$1"     ;;
           *.bz2)       bunzip2 "$1"     ;;
           *.gz)        gunzip "$1"      ;;
           *.xz)        unxz "$1"        ;;
           *.7z)        7z x "$1"        ;;
           *.Z)         uncompress "$1"  ;;
           *)           echo "'$1' cannot be extracted via extract()" ;;
       esac
   else
       echo "'$1' is not a valid file"
   fi
}

# Get public IP
alias public_ip="curl icanhazip.com"

# Get private IP
alias private_ip="ip a | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1"


