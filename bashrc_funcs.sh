# Optimize PDFs with ghostscript
#  Credit to Ahmed Musallam; I only added some enhancements
#  github.com/ahmed-musallam
# Usage is:
# optimize_pdf ./some.pdf --> ./some.pdf
# optimize_pdf ./some.pdf dir/ --> dir/some.pdf

optimize_pdf() {
  if [[ -e "$1" ]]; then
    unoptimized_pdf="$1"
  else
    echo "Unable to find $1"
    exit 1
  fi

 local optimized_pdf_dir=${2:-"./"}
  
 if [[ optimized_pdf_dir -eq "./" ]]; then
   optimized_destination="$unoptimized_pdf"
 else
   optimized_destination="$2/$unoptimized_pdf"
 fi

gs \
 -q -dNOPAUSE -dBATCH -dSAFER \
 -sDEVICE=pdfwrite \
 -dCompatibilityLevel=1.4 \
 -dPDFSETTINGS=/screen \
 -dNOTRANSPARENCY \
 -dDetectDuplicateImages=true \
 -dEmbedAllFonts=true -dSubsetFonts=true \
 -dColorImageDownsampleType=/Bicubic \
 -dColorImageResolution=144 \
 -dGrayImageResolution=144 \
 -dMonoImageDownsampleType=/Bicubic \
 -dMonoImageResolution=144 \
 -sOutputFile="$optimized_destination" \
  "$unoptimized_pdf"                         
}
