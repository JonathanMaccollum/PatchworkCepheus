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
    #New-PatchworkSource -Target "Background" -Author "eigenVector" -Source "https://www.darkflats.com/PatchworkCepheus/Sources/eigenVector.Mosaic.2x2.Full.Crop.STFOnly.jpg"
    #New-PatchworkSource -Target "LDN 1251" -Author "Rogue" -Source "https://flic.kr/p/2nA5Kno"
    New-PatchworkSource -Target "vdb140" -Author "Shinpah" -Source "https://cdn.astrobin.com/thumbs/y36YQPRayPSA_16536x0_b9muqi8S.jpg"
    
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
        $sparse.TileFormat = [Microsoft.DeepZoomTools.ImageFormat]::Png
        $sparse.Create($imageList,"$PSScriptRoot\src\$($i.Author).$($i.Target).xml")
    }
    catch
    {
        write-warning $_.Exception.ToString()
        throw
    }
}