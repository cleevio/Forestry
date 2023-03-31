swift package \
    --allow-writing-to-directory ./docs \
    generate-documentation --target ForestryLoggerLibrary \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path Forestry \
    --output-path ./docs
