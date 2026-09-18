[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$brandRoot = $PSScriptRoot
$mastersRoot = Join-Path $brandRoot 'Masters'

$directories = @(
    'Browser',
    'Installer',
    'Lockups',
    'Masters',
    'PNG\Application',
    'PNG\Brand',
    'Tray',
    'Web'
)
foreach ($directory in $directories) {
    New-Item -ItemType Directory -Force -Path (Join-Path $brandRoot $directory) | Out-Null
}

$approved = @{
    FullColor = Join-Path $mastersRoot 'beacon-mark-full-color-approved.png'
    Simplified = Join-Path $mastersRoot 'beacon-mark-simplified-approved.png'
    Navy = Join-Path $mastersRoot 'beacon-mark-one-color-navy-approved.png'
    WhiteReference = Join-Path $mastersRoot 'beacon-mark-white-reference-approved.png'
    Reversed = Join-Path $mastersRoot 'beacon-mark-reversed-approved.png'
    Lockup = Join-Path $mastersRoot 'beacon-lockup-approved.png'
}
foreach ($source in $approved.Values) {
    if (-not (Test-Path -LiteralPath $source)) {
        throw "Approved source is missing: $source"
    }
}

# Crops include a small transparent safety margin and preserve the approved artwork.
$crops = @{
    FullColor = [System.Drawing.Rectangle]::new(90, 114, 1095, 1031)
    Simplified = [System.Drawing.Rectangle]::new(118, 66, 1031, 1143)
    Navy = [System.Drawing.Rectangle]::new(214, 134, 851, 1019)
    WhiteReference = [System.Drawing.Rectangle]::new(94, 116, 1093, 1029)
    Reversed = [System.Drawing.Rectangle]::new(0, 0, 1254, 1254)
    Lockup = [System.Drawing.Rectangle]::new(76, 54, 2037, 643)
}

function New-ColorMatrixAttributes {
    param([Parameter(Mandatory)] [System.Drawing.Color] $Color)

    $matrix = [System.Drawing.Imaging.ColorMatrix]::new()
    $matrix.Matrix00 = 0
    $matrix.Matrix11 = 0
    $matrix.Matrix22 = 0
    $matrix.Matrix33 = 1
    $matrix.Matrix40 = $Color.R / 255.0
    $matrix.Matrix41 = $Color.G / 255.0
    $matrix.Matrix42 = $Color.B / 255.0
    $matrix.Matrix44 = 1
    $attributes = [System.Drawing.Imaging.ImageAttributes]::new()
    $attributes.SetColorMatrix($matrix)
    return $attributes
}

function Add-RoundedRectangle {
    param(
        [Parameter(Mandatory)] [System.Drawing.Drawing2D.GraphicsPath] $Path,
        [Parameter(Mandatory)] [System.Drawing.Rectangle] $Bounds,
        [Parameter(Mandatory)] [int] $Radius
    )

    $diameter = $Radius * 2
    $arc = [System.Drawing.Rectangle]::new($Bounds.X, $Bounds.Y, $diameter, $diameter)
    $Path.AddArc($arc, 180, 90)
    $arc.X = $Bounds.Right - $diameter
    $Path.AddArc($arc, 270, 90)
    $arc.Y = $Bounds.Bottom - $diameter
    $Path.AddArc($arc, 0, 90)
    $arc.X = $Bounds.X
    $Path.AddArc($arc, 90, 90)
    $Path.CloseFigure()
}

function Set-HighQualityGraphics {
    param([Parameter(Mandatory)] [System.Drawing.Graphics] $Graphics)
    $Graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
    $Graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $Graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $Graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $Graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
}

function Draw-FittedImage {
    param(
        [Parameter(Mandatory)] [System.Drawing.Graphics] $Graphics,
        [Parameter(Mandatory)] [System.Drawing.Image] $Image,
        [Parameter(Mandatory)] [System.Drawing.Rectangle] $SourceCrop,
        [Parameter(Mandatory)] [System.Drawing.Rectangle] $TargetBox,
        [System.Drawing.Imaging.ImageAttributes] $Attributes
    )

    $scale = [Math]::Min($TargetBox.Width / $SourceCrop.Width, $TargetBox.Height / $SourceCrop.Height)
    $width = [Math]::Max(1, [int][Math]::Round($SourceCrop.Width * $scale))
    $height = [Math]::Max(1, [int][Math]::Round($SourceCrop.Height * $scale))
    $x = $TargetBox.X + [int](($TargetBox.Width - $width) / 2)
    $y = $TargetBox.Y + [int](($TargetBox.Height - $height) / 2)
    $destination = [System.Drawing.Rectangle]::new($x, $y, $width, $height)
    if ($Attributes) {
        $Graphics.DrawImage($Image, $destination, $SourceCrop.X, $SourceCrop.Y, $SourceCrop.Width, $SourceCrop.Height, [System.Drawing.GraphicsUnit]::Pixel, $Attributes)
    }
    else {
        $Graphics.DrawImage($Image, $destination, $SourceCrop, [System.Drawing.GraphicsUnit]::Pixel)
    }
}

function New-FittedPng {
    param(
        [Parameter(Mandatory)] [string] $Source,
        [Parameter(Mandatory)] [System.Drawing.Rectangle] $SourceCrop,
        [Parameter(Mandatory)] [string] $Output,
        [Parameter(Mandatory)] [int] $Width,
        [Parameter(Mandatory)] [int] $Height,
        [int] $Padding = 0,
        [System.Drawing.Color] $Recolor = [System.Drawing.Color]::Empty,
        [System.Drawing.Color] $Background = [System.Drawing.Color]::Empty,
        [int] $CornerRadius = 0
    )

    $sourceImage = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $Source).Path)
    try {
        $targetImage = [System.Drawing.Bitmap]::new($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($targetImage)
            try {
                Set-HighQualityGraphics -Graphics $graphics
                $graphics.Clear([System.Drawing.Color]::Transparent)
                if (-not $Background.IsEmpty) {
                    $brush = [System.Drawing.SolidBrush]::new($Background)
                    try {
                        if ($CornerRadius -gt 0) {
                            $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
                            try {
                                Add-RoundedRectangle -Path $path -Bounds ([System.Drawing.Rectangle]::new(1, 1, $Width - 2, $Height - 2)) -Radius $CornerRadius
                                $graphics.FillPath($brush, $path)
                            }
                            finally {
                                $path.Dispose()
                            }
                        }
                        else {
                            $graphics.FillRectangle($brush, 0, 0, $Width, $Height)
                        }
                    }
                    finally {
                        $brush.Dispose()
                    }
                }
                $box = [System.Drawing.Rectangle]::new($Padding, $Padding, $Width - ($Padding * 2), $Height - ($Padding * 2))
                $attributes = $null
                if (-not $Recolor.IsEmpty) {
                    $attributes = New-ColorMatrixAttributes -Color $Recolor
                }
                try {
                    Draw-FittedImage -Graphics $graphics -Image $sourceImage -SourceCrop $SourceCrop -TargetBox $box -Attributes $attributes
                }
                finally {
                    if ($attributes) { $attributes.Dispose() }
                }
            }
            finally {
                $graphics.Dispose()
            }
            $targetImage.Save([System.IO.Path]::GetFullPath($Output), [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally {
            $targetImage.Dispose()
        }
    }
    finally {
        $sourceImage.Dispose()
    }
}

function Resize-Png {
    param(
        [Parameter(Mandatory)] [string] $Source,
        [Parameter(Mandatory)] [string] $Output,
        [Parameter(Mandatory)] [int] $Width,
        [Parameter(Mandatory)] [int] $Height
    )
    $sourceImage = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $Source).Path)
    try {
        $targetImage = [System.Drawing.Bitmap]::new($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($targetImage)
            try {
                Set-HighQualityGraphics -Graphics $graphics
                $graphics.Clear([System.Drawing.Color]::Transparent)
                $graphics.DrawImage($sourceImage, 0, 0, $Width, $Height)
            }
            finally { $graphics.Dispose() }
            $targetImage.Save([System.IO.Path]::GetFullPath($Output), [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally { $targetImage.Dispose() }
    }
    finally { $sourceImage.Dispose() }
}

function Set-SolidRgb {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [System.Drawing.Color] $Color
    )

    $loaded = [System.Drawing.Bitmap]::FromFile((Resolve-Path -LiteralPath $Path).Path)
    try {
        $bitmap = [System.Drawing.Bitmap]::new($loaded)
    }
    finally {
        $loaded.Dispose()
    }
    try {
        $bounds = [System.Drawing.Rectangle]::new(0, 0, $bitmap.Width, $bitmap.Height)
        $data = $bitmap.LockBits($bounds, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $length = [Math]::Abs($data.Stride) * $bitmap.Height
            $bytes = [byte[]]::new($length)
            [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $length)
            for ($index = 0; $index -lt $length; $index += 4) {
                if ($bytes[$index + 3] -gt 0) {
                    $bytes[$index] = $Color.B
                    $bytes[$index + 1] = $Color.G
                    $bytes[$index + 2] = $Color.R
                }
            }
            [System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $data.Scan0, $length)
        }
        finally {
            $bitmap.UnlockBits($data)
        }
        $bitmap.Save([System.IO.Path]::GetFullPath($Path), [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $bitmap.Dispose()
    }
}

function Write-Ico {
    param(
        [Parameter(Mandatory)] [string[]] $PngPaths,
        [Parameter(Mandatory)] [string] $Output
    )
    $frames = foreach ($pngPath in $PngPaths) {
        $image = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $pngPath).Path)
        try {
            [PSCustomObject]@{ Width = $image.Width; Height = $image.Height; Bytes = [System.IO.File]::ReadAllBytes($pngPath) }
        }
        finally { $image.Dispose() }
    }
    $stream = [System.IO.File]::Create([System.IO.Path]::GetFullPath($Output))
    $writer = [System.IO.BinaryWriter]::new($stream)
    try {
        $writer.Write([uint16]0); $writer.Write([uint16]1); $writer.Write([uint16]$frames.Count)
        $offset = 6 + (16 * $frames.Count)
        foreach ($frame in $frames) {
            $writer.Write([byte]$(if ($frame.Width -ge 256) { 0 } else { $frame.Width }))
            $writer.Write([byte]$(if ($frame.Height -ge 256) { 0 } else { $frame.Height }))
            $writer.Write([byte]0); $writer.Write([byte]0); $writer.Write([uint16]1); $writer.Write([uint16]32)
            $writer.Write([uint32]$frame.Bytes.Length); $writer.Write([uint32]$offset)
            $offset += $frame.Bytes.Length
        }
        foreach ($frame in $frames) { $writer.Write($frame.Bytes) }
    }
    finally { $writer.Dispose(); $stream.Dispose() }
}

function New-ComponentLockup {
    param(
        [Parameter(Mandatory)] [string] $Component,
        [Parameter(Mandatory)] [string] $Output
    )
    $sourceImage = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $approved.Lockup).Path)
    try {
        $targetImage = [System.Drawing.Bitmap]::new(1200, 400, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($targetImage)
            try {
                Set-HighQualityGraphics -Graphics $graphics
                $graphics.Clear([System.Drawing.Color]::Transparent)
                Draw-FittedImage -Graphics $graphics -Image $sourceImage -SourceCrop $crops.Lockup -TargetBox ([System.Drawing.Rectangle]::new(0, 0, 1200, 315))
                $font = [System.Drawing.Font]::new('Segoe UI', 34, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
                $brush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#00539B'))
                try {
                    $graphics.DrawString($Component.ToUpperInvariant(), $font, $brush, 432, 306)
                }
                finally { $font.Dispose(); $brush.Dispose() }
            }
            finally { $graphics.Dispose() }
            $targetImage.Save([System.IO.Path]::GetFullPath($Output), [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally { $targetImage.Dispose() }
    }
    finally { $sourceImage.Dispose() }
}

function New-RemoteHeaderLockup {
    param([Parameter(Mandatory)] [string] $Output)

    $sourceImage = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $approved.Lockup).Path)
    try {
        $targetImage = [System.Drawing.Bitmap]::new(450, 66, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($targetImage)
            try {
                Set-HighQualityGraphics -Graphics $graphics
                $graphics.Clear([System.Drawing.Color]::Transparent)
                Draw-FittedImage -Graphics $graphics -Image $sourceImage -SourceCrop $crops.Lockup -TargetBox ([System.Drawing.Rectangle]::new(0, 0, 215, 66))
                $font = [System.Drawing.Font]::new('Segoe UI', 18, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
                $brush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#00539B'))
                try { $graphics.DrawString('REMOTE', $font, $brush, 215, 23) }
                finally { $font.Dispose(); $brush.Dispose() }
            }
            finally { $graphics.Dispose() }
            $targetImage.Save([System.IO.Path]::GetFullPath($Output), [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally { $targetImage.Dispose() }
    }
    finally { $sourceImage.Dispose() }
}

$navy = [System.Drawing.ColorTranslator]::FromHtml('#003366')
$cyan = [System.Drawing.ColorTranslator]::FromHtml('#00B0FF')
$white = [System.Drawing.Color]::White

# Large production marks. These preserve the approved geometry exactly.
Copy-Item -LiteralPath $approved.FullColor -Destination (Join-Path $brandRoot 'PNG\Brand\beacon-mark-full-color-transparent-1254.png') -Force
Copy-Item -LiteralPath $approved.Simplified -Destination (Join-Path $brandRoot 'PNG\Brand\beacon-mark-simplified-transparent-1254.png') -Force
Copy-Item -LiteralPath $approved.Reversed -Destination (Join-Path $brandRoot 'PNG\Brand\beacon-mark-reversed-dark-1254.png') -Force
New-FittedPng -Source $approved.Navy -SourceCrop $crops.Navy -Output (Join-Path $brandRoot 'PNG\Brand\beacon-mark-one-color-navy-1254.png') -Width 1254 -Height 1254 -Padding 100 -Recolor $navy
New-FittedPng -Source $approved.Navy -SourceCrop $crops.Navy -Output (Join-Path $brandRoot 'PNG\Brand\beacon-mark-one-color-white-1254.png') -Width 1254 -Height 1254 -Padding 100 -Recolor $white
Set-SolidRgb -Path (Join-Path $brandRoot 'PNG\Brand\beacon-mark-one-color-navy-1254.png') -Color $navy
Set-SolidRgb -Path (Join-Path $brandRoot 'PNG\Brand\beacon-mark-one-color-white-1254.png') -Color $white

# Application icon: exact simplified shape recolored cyan on the approved navy field.
$appMaster = Join-Path $brandRoot 'PNG\Application\beacon-app-512.png'
New-FittedPng -Source $approved.Simplified -SourceCrop $crops.Simplified -Output $appMaster -Width 512 -Height 512 -Padding 38 -Recolor $cyan -Background $navy -CornerRadius 92
$applicationSizes = @(16, 24, 32, 48, 64, 128, 256, 512)
foreach ($size in $applicationSizes | Where-Object { $_ -ne 512 }) {
    Resize-Png -Source $appMaster -Output (Join-Path $brandRoot "PNG\Application\beacon-app-$size.png") -Width $size -Height $size
}

# Browser icon family.
foreach ($size in @(16, 32, 48, 180, 192, 512)) {
    Resize-Png -Source $appMaster -Output (Join-Path $brandRoot "Browser\favicon-$size.png") -Width $size -Height $size
}
Write-Ico -PngPaths @(16, 32, 48 | ForEach-Object { Join-Path $brandRoot "Browser\favicon-$_.png" }) -Output (Join-Path $brandRoot 'Browser\favicon.ico')
$manifest = @'
{
  "name": "Beacon Remote",
  "short_name": "Beacon Remote",
  "icons": [
    { "src": "favicon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "favicon-512.png", "sizes": "512x512", "type": "image/png" }
  ],
  "theme_color": "#003366",
  "background_color": "#003366",
  "display": "standalone"
}
'@
[System.IO.File]::WriteAllText((Join-Path $brandRoot 'Browser\site.webmanifest'), $manifest, [System.Text.UTF8Encoding]::new($false))

$icoPaths = foreach ($size in @(16, 24, 32, 48, 64, 128, 256)) { Join-Path $brandRoot "PNG\Application\beacon-app-$size.png" }
Write-Ico -PngPaths $icoPaths -Output (Join-Path $brandRoot 'beacon.ico')

# Tray and notification variants use the exact no-beam one-color shape.
$trayNavyMaster = Join-Path $brandRoot 'Tray\beacon-tray-navy-512.png'
$trayWhiteMaster = Join-Path $brandRoot 'Tray\beacon-tray-white-512.png'
New-FittedPng -Source $approved.Navy -SourceCrop $crops.Navy -Output $trayNavyMaster -Width 512 -Height 512 -Padding 20 -Recolor $navy
New-FittedPng -Source $approved.Navy -SourceCrop $crops.Navy -Output $trayWhiteMaster -Width 512 -Height 512 -Padding 20 -Recolor $white
Set-SolidRgb -Path $trayNavyMaster -Color $navy
Set-SolidRgb -Path $trayWhiteMaster -Color $white
foreach ($size in @(16, 20, 24, 32, 48)) {
    $navyTray = Join-Path $brandRoot "Tray\beacon-tray-navy-$size.png"
    $whiteTray = Join-Path $brandRoot "Tray\beacon-tray-white-$size.png"
    Resize-Png -Source $trayNavyMaster -Output $navyTray -Width $size -Height $size
    Resize-Png -Source $trayWhiteMaster -Output $whiteTray -Width $size -Height $size
    Set-SolidRgb -Path $navyTray -Color $navy
    Set-SolidRgb -Path $whiteTray -Color $white
}
foreach ($size in @(32, 48, 64)) {
    Resize-Png -Source $appMaster -Output (Join-Path $brandRoot "Tray\beacon-notification-$size.png") -Width $size -Height $size
}

# Approved horizontal lockup and consistent component labels.
New-FittedPng -Source $approved.Lockup -SourceCrop $crops.Lockup -Output (Join-Path $brandRoot 'Lockups\beacon-lockup-1200x400.png') -Width 1200 -Height 400 -Padding 8
foreach ($component in @('Remote', 'Agent', 'Assistant')) {
    New-ComponentLockup -Component $component -Output (Join-Path $brandRoot "Lockups\beacon-$($component.ToLowerInvariant())-lockup-1200x400.png")
}

# Web surfaces.
$remoteLockup = Join-Path $brandRoot 'Lockups\beacon-remote-lockup-1200x400.png'
Copy-Item -LiteralPath $remoteLockup -Destination (Join-Path $brandRoot 'Web\beacon-header-light-1200x400.png') -Force
Resize-Png -Source (Join-Path $brandRoot 'Web\beacon-header-light-1200x400.png') -Output (Join-Path $brandRoot 'Web\beacon-header-light-600x200.png') -Width 600 -Height 200
New-RemoteHeaderLockup -Output (Join-Path $brandRoot 'Web\beacon-header-450x66.png')
New-FittedPng -Source $remoteLockup -SourceCrop ([System.Drawing.Rectangle]::new(0, 0, 1200, 400)) -Output (Join-Path $brandRoot 'Web\beacon-header-dark-1200x400.png') -Width 1200 -Height 400 -Padding 8 -Recolor $white
Resize-Png -Source (Join-Path $brandRoot 'Web\beacon-header-dark-1200x400.png') -Output (Join-Path $brandRoot 'Web\beacon-header-dark-600x200.png') -Width 600 -Height 200
Set-SolidRgb -Path (Join-Path $brandRoot 'Web\beacon-header-dark-1200x400.png') -Color $white
Set-SolidRgb -Path (Join-Path $brandRoot 'Web\beacon-header-dark-600x200.png') -Color $white
New-FittedPng -Source $remoteLockup -SourceCrop ([System.Drawing.Rectangle]::new(0, 0, 1200, 400)) -Output (Join-Path $brandRoot 'Web\beacon-login-light-512.png') -Width 512 -Height 171 -Padding 4
New-FittedPng -Source $remoteLockup -SourceCrop ([System.Drawing.Rectangle]::new(0, 0, 1200, 400)) -Output (Join-Path $brandRoot 'Web\beacon-login-dark-512.png') -Width 512 -Height 171 -Padding 4 -Recolor $white
Set-SolidRgb -Path (Join-Path $brandRoot 'Web\beacon-login-dark-512.png') -Color $white

# Installer and uninstall-entry artwork.
Copy-Item -LiteralPath (Join-Path $brandRoot 'beacon.ico') -Destination (Join-Path $brandRoot 'Installer\beacon-installer.ico') -Force
Copy-Item -LiteralPath (Join-Path $brandRoot 'beacon.ico') -Destination (Join-Path $brandRoot 'Installer\beacon-uninstall-entry.ico') -Force
Copy-Item -LiteralPath (Join-Path $brandRoot 'PNG\Application\beacon-app-256.png') -Destination (Join-Path $brandRoot 'Installer\beacon-installer-256.png') -Force
Copy-Item -LiteralPath $appMaster -Destination (Join-Path $brandRoot 'Installer\beacon-installer-512.png') -Force
$sidebarPng = Join-Path $brandRoot 'Installer\beacon-installer-sidebar-164x314.png'
$sidebar = [System.Drawing.Bitmap]::new(164, 314, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
try {
    $graphics = [System.Drawing.Graphics]::FromImage($sidebar)
    try {
        Set-HighQualityGraphics -Graphics $graphics
        $graphics.Clear($navy)
        $reversedImage = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $approved.Reversed).Path)
        try {
            Draw-FittedImage -Graphics $graphics -Image $reversedImage -SourceCrop $crops.Reversed -TargetBox ([System.Drawing.Rectangle]::new(16, 20, 132, 132))
        }
        finally { $reversedImage.Dispose() }
        $titleFont = [System.Drawing.Font]::new('Segoe UI', 27, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
        $labelFont = [System.Drawing.Font]::new('Segoe UI', 11, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
        $whiteBrush = [System.Drawing.SolidBrush]::new($white)
        $cyanBrush = [System.Drawing.SolidBrush]::new($cyan)
        try {
            $titleFormat = [System.Drawing.StringFormat]::new()
            $titleFormat.Alignment = [System.Drawing.StringAlignment]::Center
            $graphics.DrawString('Beacon', $titleFont, $whiteBrush, [System.Drawing.RectangleF]::new(0, 172, 164, 42), $titleFormat)
            $graphics.DrawString('REMOTE', $labelFont, $cyanBrush, [System.Drawing.RectangleF]::new(0, 214, 164, 24), $titleFormat)
            $titleFormat.Dispose()
        }
        finally { $titleFont.Dispose(); $labelFont.Dispose(); $whiteBrush.Dispose(); $cyanBrush.Dispose() }
    }
    finally { $graphics.Dispose() }
    $sidebar.Save($sidebarPng, [System.Drawing.Imaging.ImageFormat]::Png)
    $sidebar.Save((Join-Path $brandRoot 'Installer\beacon-installer-sidebar-164x314.bmp'), [System.Drawing.Imaging.ImageFormat]::Bmp)
}
finally { $sidebar.Dispose() }

Write-Output "Beacon assets rebuilt from tracked approved masters in $brandRoot"
