$ErrorActionPreference = "Stop"
$base = "C:\Users\admin\AppData\Local\Temp\opencode\cipher"

Write-Host "Finding files containing 'opencode'..." -ForegroundColor Yellow

# Use robocopy-style approach: /XF /XD to exclude
$files = @()
$include = @("*.md", "*.mdx", "*.yml", "*.yaml", "*.sh", "*.json")
$excludeDirs = @("node_modules", ".git", ".cipher", ".cache", ".bun")

# Walk directories manually to avoid broken symlinks
$dirs = Get-ChildItem -Path $base -Directory | Where-Object { $_.Name -notin $excludeDirs }
$queue = [System.Collections.Queue]::new()
foreach ($d in $dirs) { $queue.Enqueue($d) }

while ($queue.Count -gt 0) {
    $dir = $queue.Dequeue()
    $children = try { Get-ChildItem -Path $dir.FullName -ErrorAction Stop } catch { @() }
    foreach ($child in $children) {
        if ($child.PSIsContainer) {
            if ($child.Name -notin $excludeDirs) { $queue.Enqueue($child) }
        } else {
            $ext = [System.IO.Path]::GetExtension($child.Name)
            if ($ext -in @(".md", ".mdx", ".yml", ".yaml", ".sh", ".json")) {
                try {
                    $match = Select-String -Path $child.FullName -Pattern "opencode" -List -Quiet -ErrorAction Stop
                    if ($match) { $files += $child.FullName }
                } catch { # skip inaccessible files
                }
            }
        }
    }
}

Write-Host "Found $($files.Count) files to process" -ForegroundColor Cyan

$modifiedCount = 0
$errorFiles = @()

$protectPatterns = @(
    'https?://opencode\.ai',
    'https?://www\.opencode\.ai',
    'github\.com/anomalyco/opencode',
    'anomalyco/tap/opencode',
    'scoop install opencode',
    'choco install opencode',
    'extras/opencode-desktop',
    'formulae\.brew\.sh/api/formula/opencode',
    'discord\.gg/opencode',
    'x\.com/opencode',
    'github\.com/apps/opencode-agent',
    'app\.opencode\.ai',
    'opencode\.org',
    'njs/package/opencode-ai',
    'raw\.githubusercontent\.com/anomalyco/opencode',
    'opncd\.ai',
    'github\.com/sst/opentui',
    'shields\.io/discord/1391832426048651334'
)

foreach ($filePath in $files) {
    $relative = $filePath.Replace("$base\", "")
    try {
        $content = Get-Content -Path $filePath -Raw -ErrorAction Stop -Encoding UTF8
        if (-not $content) { continue }
        $original = $content
        
        # STEP 1: Protect patterns that must keep "opencode"
        $protectMap = @{}
        $combinedPattern = ($protectPatterns | ForEach-Object { "(?i)$_" }) -join '|'
        if ($combinedPattern) {
            $content = [regex]::Replace($content, $combinedPattern, {
                param($m)
                $token = "%%PROTECT_$([System.Guid]::NewGuid().ToString('N'))%%"
                $protectMap[$token] = $m.Value
                return $token
            })
        }
        
        # STEP 2: Apply replacements
        $content = $content -replace '(?i)~\.local/share/opencode/', '~/.local/share/cipher/'
        $content = $content -replace '(?i)~\.config/opencode/', '~/.config/cipher/'
        $content = $content -replace '(?i)\.opencode/(?!ai)', '.cipher/'
        $content = $content -replace '(?i)packages/opencode', 'packages/cipher'
        $content = $content -replace '(?i)opencode-test-', 'cipher-test-'
        $content = $content -replace '(?i)opencode-desktop-', 'cipher-desktop-'
        $content = $content -replace '(?i)/bin/opencode\b', '/bin/cipher'
        $content = $content -replace '(?i)/opencode/github/', '/cipher/github/'
        $content = $content -replace '(?i)opencode\.json', 'cipher.json'
        
        # Default username
        $content = $content -replace '(?i)(defaults to `CIPHER_SERVER_USERNAME` or )"opencode"', '${1}"cipher"'
        $content = $content -replace '(?i)(username defaults to `CIPHER_SERVER_USERNAME` or )`opencode`', '${1}`cipher`'
        
        # Package manager commands
        $content = $content -replace '(?i)brew install opencode\b', 'brew install cipher'
        $content = $content -replace '(?i)brew install --cask opencode-desktop\b', 'brew install --cask cipher-desktop'
        $content = $content -replace '(?i)(npm|pnpm|yarn|bun) (i|add|install) -g opencode-ai', '$1 $2 -g cipher-ai'
        $content = $content -replace '(?i)(npm|pnpm|yarn|bun) (i|add|install) opencode-ai', '$1 $2 cipher-ai'
        $content = $content -replace '(?i)@opencode-ai/', '@cipher-ai/'
        $content = $content -replace '(?i)sudo pacman -S opencode\b', 'sudo pacman -S cipher'
        $content = $content -replace '(?i)paru -S opencode-bin\b', 'paru -S cipher-bin'
        $content = $content -replace '(?i)mise use -g opencode\b', 'mise use -g cipher'
        $content = $content -replace '(?i)nix run nixpkgs#opencode\b', 'nix run nixpkgs#cipher'
        $content = $content -replace '(?i)opencode-desktop-mac', 'cipher-desktop-mac'
        $content = $content -replace '(?i)opencode-desktop-windows', 'cipher-desktop-windows'
        
        # Desktop download filenames in table rows
        $content = $content -replace '(?i)`opencode-desktop-', '`cipher-desktop-'
        
        # Product name in prose
        $content = $content -replace '(?i)(?<![\./])OpenCode(?=\s|\.|,|:|;|\)|\]|`|$|\\n|")', 'Cipher'
        
        # CLI command backtick references
        $content = $content -replace '(?i)`opencode`', '`cipher`'
        $content = $content -replace '(?i)`opencode(?=\s)', '`cipher '
        
        # $ opencode
        $content = $content -replace '(?i)\$ opencode\b', '$ cipher'
        
        # Command at start of code block line
        $content = $content -replace '(?m)^\s*opencode(?=\s)', 'cipher'
        $content = $content -replace '(?m)^\s*opencode$', '  cipher'
        
        # CLI subcommands
        $content = $content -replace '(?i)(?<!`)opencode (serve|web|attach|auth|agent|mcp|models|session|stats|export|import|github|run|acp|plug|plugin|db|debug|uninstall|upgrade|pr)\b', 'cipher $1'
        
        # Model ID
        $content = $content -replace '(?i)opencode/gpt-', 'cipher/gpt-'
        $content = $content -replace '(?i)opencode/gpt\b', 'cipher/gpt'
        
        # Workflow/GitHub Action
        $content = $content -replace '(?i)name:\s*opencode\b', 'name: cipher'
        $content = $content -replace '(?i)uses:\s*anomalyco/opencode/github', 'uses: anomalyco/cipher/github'
        
        # /opencode trigger  
        $content = $content -replace '(?i)/opencode(?=\s|$|`|\n)', '/cipher'
        $content = $content -replace "(?i)hey opencode(?=\s|,|\.|')", 'hey cipher'
        
        # # opencode comment
        $content = $content -replace '(?i)# opencode\b', '# cipher'
        $content = $content -replace '(?i)opencode-<platform>', 'cipher-<platform>'
        
        # Standalone "opencode" as binary name
        $content = $content -replace '(?i)(?<!/|\w|@|\.|-)opencode(?!\.ai|\.[a-z]|-ai|/|@)', 'cipher'
        
        # Installer references  
        $content = $content -replace '(?i)command -v opencode\b', 'command -v cipher'
        $content = $content -replace '(?i)which opencode\b', 'which cipher'
        $content = $content -replace '(?i)opencode --version\b', 'cipher --version'
        $content = $content -replace '(?i)Installing opencode\b', 'Installing cipher'
        $content = $content -replace '(?i)"\$tmp_dir/opencode"', '"$tmp_dir/cipher"'
        $content = $content -replace '(?i)"\$\{INSTALL_DIR\}/opencode"', '"${INSTALL_DIR}/cipher"'
        
        # path/to/opencode
        $content = $content -replace '(?i)/path/to/opencode', '/path/to/cipher'
        
        # opencode scope in commit types
        $content = $content -replace '(?i)`opencode` scope', '`cipher` scope'
        $content = $content -replace '(?i)e\.g\. `core`, `opencode`, `tui`', 'e.g. `core`, `cipher`, `tui`'
        $content = $content -replace '(?i)like `packages/opencode`', 'like `packages/cipher`'
        $content = $content -replace '(?i)prefix `opencode-test-`', 'prefix `cipher-test-`'
        $content = $content -replace '(?i)"opencode-test-"', '"cipher-test-"'
        $content = $content -replace '(?i)contains\("opencode-test-"\)', 'contains("cipher-test-")'
        $content = $content -replace '(?i)toContain\("opencode-test-"\)', 'toContain("cipher-test-")'
        
        # Plugin references
        $content = $content -replace '(?i)@opencode/Foo\b', '@cipher/Foo'
        $content = $content -replace '(?i)opencode\.tools\.register', 'cipher.tools.register'
        
        # ./packages/opencode/ paths
        $content = $content -replace '(?i)\./packages/opencode/', './packages/cipher/'
        
        # ACP/Lua config references
        $content = $content -replace '(?i)\["opencode"\]', '["cipher"]'
        $content = $content -replace "(?i)command = `"opencode`"", 'command = "cipher"'
        $content = $content -replace "(?i)name = `"opencode`"", 'name = "cipher"'
        
        # opncd.ai short URL (opencode share) - protect this pattern
        # The "opencode import https://opncd.ai" pattern should keep opncd.ai
        
        # STEP 3: Restore protected patterns
        foreach ($token in $protectMap.Keys) {
            $content = $content -replace [regex]::Escape($token), $protectMap[$token]
        }
        
        # STEP 4: Write if changed
        if ($content -ne $original) {
            Write-Host "  MODIFIED: $relative" -ForegroundColor Green
            Set-Content -Path $filePath -Value $content -NoNewline -Encoding UTF8
            $modifiedCount++
        } else {
            Write-Host "  Skipped: $relative" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "  ERROR: $relative : $_" -ForegroundColor Red
        $errorFiles += $relative
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Files modified: $modifiedCount" -ForegroundColor Green
if ($errorFiles.Count -gt 0) {
    Write-Host "Errors: $($errorFiles.Count)" -ForegroundColor Red
    $errorFiles | ForEach-Object { Write-Host "  - $_" }
}
Write-Host "Done!" -ForegroundColor Cyan
