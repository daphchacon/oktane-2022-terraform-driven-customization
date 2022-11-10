# Interpreter configuration
$ErrorActionPreference = 'Stop'

# build actions
npx webpack 

# Assert build success
if ($LASTEXITCODE -eq 0) {
    Write-Output "Build Successful"
} else {
    Write-Error "Build Failed"
}
