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
    New-PatchworkSource -Target "Stars" -Author "PixInsight" -Source ""
    New-PatchworkSource -Target "Annotated" -Author "PixInsight" -Source ""
)
$sources|foreach-object {
    $i = $_
    if(([string]::IsNullOrWhiteSpace($_.Source) ) -or (-not (test-path $_.Source))){
        write-warning "Unable create DZI for $($_.Author)'s target $($_.Target): could not locate file $($_.Source)"
        return;
    }
    $imageList = new-object System.Collections.Generic.List[Microsoft.DeepZoomTools.Image]
    $imageList.Add(
        (new-object Microsoft.DeepZoomTools.Image ($i.Source)))

    
    try
    {
        $sparse = [Microsoft.DeepZoomTools.SparseImageCreator]::new()
        $sparse.MaxLevel=20
        #$sparse.ConversionTileFormat = [Microsoft.DeepZoomTools.ImageFormat]::Png
        $sparse.TileFormat = [Microsoft.DeepZoomTools.ImageFormat]::Png
        $sparse.Create($imageList,"$PSScriptRoot\$($i.Author).$($i.Target).xml")
    }
    catch
    {
        write-warning $_.Exception.ToString()
        throw
    }
}