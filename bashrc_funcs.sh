## Optimizes PDFs aggressively.
## Primarily as feedstock to LLMs, or for archiving.

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
  echo "$optimized_destination"

gs \
 -q -dNOPAUSE -dBATCH -dSAFER \
 -sDEVICE=pdfwrite \
 -dPDFSETTINGS=/ebook \
 -dFastWebView \
 -dCompatibilityLevel=1.4 \
 -dPDFSETTINGS=/ebook \
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
 -sOutputFile="$optimized_destination" \
  "$unoptimized_pdf"      
}
