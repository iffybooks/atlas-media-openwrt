#Pandoc didn't work out, so we're currently making PDFs using MarkText. Just leaving this command here for reference.
#pandoc --pdf-engine=xelatex -V geometry:a5paper install-openwrt-on-atlas-media-router.md -o install-openwrt-on-atlas-media-router.pdf

# Let PDF export finish
sleep 11

pdfbook2 --paper=letterpaper --short-edge \
--outer-margin=30 --inner-margin=20 --top-margin=40 --bottom-margin=40 README.pdf






