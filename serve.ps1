$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8000/")
$listener.Start()
Write-Host "Server running at http://localhost:8000/"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $localPath = $request.Url.LocalPath
    if ($localPath -eq "/") { $localPath = "/jarvis-dashboard.html" }
    $filePath = "c:\Users\hello\Downloads\GIT" + $localPath.Replace("/", "\")
    if (Test-Path $filePath) {
        $item = Get-Item $filePath
        if (-not $item.PSIsContainer) {
            $content = Get-Content $filePath -Raw -Encoding UTF8
            $response.ContentType = if ($filePath.EndsWith(".html")) { "text/html" } elseif ($filePath.EndsWith(".css")) { "text/css" } else { "text/plain" }
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } else {
            $response.StatusCode = 403
        }
    } else {
        $response.StatusCode = 404
    }
    $response.Close()
}