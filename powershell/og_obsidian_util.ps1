# obsidian vault directory
$VAULT_PATH = Join-Path $env:USERPROFILE "obsidian-work"
$ZETTELKASTEN_DIR = Join-Path $VAULT_PATH "zettelkasten"
$NOTES_DIR = Join-Path $vaultPath "notes"

# iterate through all the markdown files in the zettelkasten directory
# TODO: read each of the files in the zettelkasten directory and extract the tags
# if a tag is found, move the file to the nodes/<tag> directory
# if the tag directory does not exist, create it
# if there is no tag, ignore and return
