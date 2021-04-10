Add-Type -AssemblyName 'System.Windows.Forms'

$fileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter           = 'Images (*.jpg, *.bmp, *.png)|*.jpg;*.bmp;*.png|All files|*.*'
    Title            = 'Select the input image...'
}
$fileBrowser.ShowDialog()

[System.IO.FileInfo] $file = $fileBrowser.FileName
$image = [System.Drawing.Image]::Fromfile($file.FullName)

[int] $r = $image.Width
[int] $c = $image.Height
[int] $x = [Math]::Round([Math]::Tan([Math]::PI / 8) * $r / 2)
[int] $y = [Math]::Round([Math]::Tan([Math]::PI / 8) * $c / 2)
[int] $rp = [Math]::Round($r / 2)
[int] $cp = [Math]::Round($c / 2)
[int] $min = [Math]::Min($r, $c)
[int] $penThickness = 3
if ($min -le 300)
{
    $penThickness = 1
}

$coordinates = @((0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0));

$coordinates[0][1] = $cp - $x
$coordinates[1][1] = $cp + $x
$coordinates[2][0] = $rp - $y
$coordinates[2][1] = $c
$coordinates[3][0] = $rp + $y
$coordinates[3][1] = $c
$coordinates[4][0] = $r
$coordinates[4][1] = $cp + $x
$coordinates[5][0] = $r
$coordinates[5][1] = $cp - $x
$coordinates[6][0] = $rp + $y
$coordinates[7][0] = $rp - $y

[System.Drawing.Graphics] $drawingSurface = [System.Drawing.Graphics]::FromImage($Image)
$pen = [System.Drawing.Pen]::new('Black', $penThickness)
$drawingSurface.DrawLine($pen, $coordinates[0][0], $coordinates[0][1], $coordinates[4][0], $coordinates[4][1]);
$drawingSurface.DrawLine($pen, $coordinates[1][0], $coordinates[1][1], $coordinates[5][0], $coordinates[5][1]);
$drawingSurface.DrawLine($pen, $coordinates[2][0], $coordinates[2][1], $coordinates[6][0], $coordinates[6][1]);
$drawingSurface.DrawLine($pen, $coordinates[3][0], $coordinates[3][1], $coordinates[7][0], $coordinates[7][1]);
$drawingSurface.DrawArc($pen, $rp - $min / 6, $cp - $min / 6, $min * 1 / 3, $min * 1 / 3, 0, 360);
$drawingSurface.DrawArc($pen, $rp - $min / 3, $cp - $min / 3, $min * 2 / 3, $min * 2 / 3, 0, 360);
$drawingSurface.DrawArc($pen, $rp - $min / 2, $cp - $min / 2, $min, $min, 0, 360);
#$greyPen = [System.Drawing.Pen]::new('Grey', $penThickness)
#$drawingSurface.DrawLine($greyPen, $rp, 0, $rp, $c);

$fileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter           = 'Images (*.jpg, *.bmp, *.png)|*.jpg;*.bmp;*.png|All files|*.*'
    Title            = 'Save image with PaKua as...'
}
$fileBrowser.ShowDialog()

[System.IO.FileInfo] $file = $fileBrowser.FileName
$image.Save($file.FullName, [System.Drawing.Imaging.ImageFormat]::Jpeg)