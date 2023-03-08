#!/bin/bash

BUCKET_NAME="test.khai"
MAX_FILES=10

FILE_COUNT=$(aws s3 ls s3://$BUCKET_NAME | awk 'END{print NR}')

if [ $FILE_COUNT -gt $MAX_FILES ]; then
    COUNT_TO_DELETE=$(( $FILE_COUNT - $MAX_FILES ))
    echo Count of files to delete is $COUNT_TO_DELETE
    FILES_TO_DELETE=$(aws s3 ls s3://$BUCKET_NAME/ | sort | sort -r | head -n $COUNT_TO_DELETE | awk '{print $4}')
    aws s3 rm s3://$BUCKET_NAME/ --recursive --exclude $(echo $FILES_TO_DELETE | sed 's/ / --exclude /g')
fi

