Function New-PatchworkSource
{
    param(
        [String]$Author,
        [String]$Source,
        [String]$Target
    )
    new-object psobject -Property @{
        Author=$Author
        Source=$Source
        Target=$Target
    }
}
import-module "$PSScriptRoot\Bin\DeepZoomTools.DLL"

$sources = @(
    #New-PatchworkSource -Target "Stars" -Author "PixInsight" -Source "https://www.darkflats.com/PatchworkCepheus/PatchworkCepheus.Stars.png"
    #New-PatchworkSource -Target "Annotated" -Author "PixInsight" -Source "https://www.darkflats.com/PatchworkCepheus/Sources/eigenVector.Mosaic.2x2.Full.Crop.Annotations.png"
    #New-PatchworkSource -Target "Background.Draft1c" -Author "eigenVector" -Source "https://www.darkflats.com/PatchworkCepheus/Sources/eigenVector.Mosaic.2x2.Full.Crop.Draft1b.jpg"
    #New-PatchworkSource -Target "LDN 1251" -Author "Rogue" -Source "https://live.staticflickr.com/65535/52237871876_ef916ccfdc_o.jpg"
    #New-PatchworkSource -Target "LBN 468" -Author "Rogue" -Source "https://live.staticflickr.com/65535/52269653534_2ee03e9e10_o.jpg"
    #New-PatchworkSource -Target "vdb140" -Author "Shinpah" -Source "https://cdn.astrobin.com/thumbs/y36YQPRayPSA_16536x0_b9muqi8S.jpg"
    #New-PatchworkSource -Target "CED-214.Draft1" -Author "eigenVector" -Source "https://www.darkflats.com/Widefield/Ced-214/Cassiopeia%20on%20HD%20443%20with%20CED%20214.RGB.R.54x90s.G.74x90s.B.70x90s.Draft1.jpg"    
    #New-PatchworkSource -Target "Polaris Flare" -Author "Rogue" -Source "https://live.staticflickr.com/65535/52394102732_9dc253c3ce_o.jpg"
)
$sources|foreach-object {
    $i = $_
    if(([string]::IsNullOrWhiteSpace($_.Source) )){
        write-warning "Unable create DZI for $($_.Author)'s target $($_.Target): could not locate file $($_.Source)"
        return;
    }
    $imageList = new-object System.Collections.Generic.List[Microsoft.DeepZoomTools.Image]
    $imageList.Add(
        (new-object Microsoft.DeepZoomTools.Image ($i.Source)))

    
    try
    {
        $sparse = [Microsoft.DeepZoomTools.SparseImageCreator]::new()
        $sparse.MaxLevel=14
        $sparse.UseOptimizations=$true
        #$sparse.ConversionTileFormat = [Microsoft.DeepZoomTools.ImageFormat]::Png
        #$sparse.TileFormat = [Microsoft.DeepZoomTools.ImageFormat]::Png
        $sparse.TileFormat = [Microsoft.DeepZoomTools.ImageFormat]::Jpg
        $sparse.Create($imageList,"$PSScriptRoot\src\$($i.Author).$($i.Target).xml")
    }
    catch
    {
        write-warning $_.Exception.ToString()
        throw
    }
}