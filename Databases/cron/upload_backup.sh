#!/bin/bash
# Description: Uploads a file to a Space project as a document
# Usage: ./upload_backup.sh <file>
# Example: ./upload_backup.sh 2021-01-01.tar.gz

FILE=$1

ORGNAME=3mty

TOKEN='eyJhbGciOiJSUzUxMiJ9.eyJzdWIiOiIyOWNHbHMwUHBPQTkiLCJhdWQiOiJjaXJjbGV0LXdlYi11aSIsIm9yZ0RvbWFpbiI6IjNtdHkiLCJuYW1lIjoiTWF0dGVvIiwiaXNzIjoiaHR0cHM6XC9cLzNtdHkuamV0YnJhaW5zLnNwYWNlIiwicGVybV90b2tlbiI6ImlUWndZMXRraEM1IiwicHJpbmNpcGFsX3R5cGUiOiJVU0VSIiwiaWF0IjoxNzAxNjk4NzYzfQ.lYHK-HbiJTiN-w1fK8NYL5Fwav0D5X7GeRFRZhgS2yoFzV2_0woqhWQVqJEWPujdNn-NPEBLO3Vb64_eSwE4JdDsa62w3K7lzzGy9-01qmCmoh1uIamc9qe5RlW3p2Wdy9z_HXHVlFxWDpmOF_VvOFSKpmPn4qxlFu7mS42NBhY'

PROJECTKEY=DESCOLAR

DOCNAME=$(basename $FILE)

UPLOADFOLDER="id:10IJ7n28Bgp7"

BLOBID=$(curl -X POST \
  https://$ORGNAME.jetbrains.space/storage/blobs \
  -H "Authorization: Bearer $TOKEN" \
  --data-binary @$FILE)
  
echo
echo "Here is your blobid:"
echo $BLOBID
echo "#########################################################################"
echo "Creating the doc from blob..."
echo
 
 
CREATEDOC=$(curl \
  https://$ORGNAME.jetbrains.space/api/http/projects/key:$PROJECTKEY/documents \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{ \"name\":\"$DOCNAME\", \"folder\":\"$UPLOADFOLDER\", \"bodyIn\":{ \"className\":\"FileDocumentBodyCreateIn\", \"blobId\":\"$BLOBID\" } }"
  )

echo
echo "#########################################################################"
echo "Document created:"
echo $CREATEDOC