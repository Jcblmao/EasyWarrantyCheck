function Write-WarrantyNinjaRMM {
    <#
        .SYNOPSIS
        Function to write details to NinjaRMM
    
        .DESCRIPTION
        This function will write details to NinjaRMM
    
        .EXAMPLE
        Write-WarrantyNinjaRMM -Warrantystart 'value' -WarrantyExpiry 'value' -WarrantyStatus 'value' -Invoicenumber 'value'
    
        .PARAMETER Serial
        Manually set serial
    
        .PARAMETER Manufacture
        Manually set Manufacture
    
    #>
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Mandatory = $false)]
            [String]$Warrantystart= '',
            [Parameter(Mandatory = $false)]
            [String]$WarrantyExpiry= '',
            [Parameter(Mandatory = $false)]
            [String]$WarrantyStatus = '',
            [Parameter(Mandatory = $false)]
            [String]$Invoicenumber= '',
            [Parameter(Mandatory = $false)]
            [String]$dateformat= 'dd-MM-yyyy'
        )
        if(Get-WarrantyNinjaRMM -eq $true -and ($ForceUpdate -eq $false)){
            return "Warranty details already in NinjaRMM"
        } else {
                if($Warrantystart){
                    $Warrantystart = [DateTime]::ParseExact($Warrantystart, $dateformat, $null)
                    $Warrantystartutc = Get-Date $Warrantystart -Format "yyyy-MM-dd"
                }
                if($WarrantyExpiry){
                    $WarrantyExpiry = [DateTime]::ParseExact($WarrantyExpiry, $dateformat, $null)
                    $WarrantyExpiryutc = Get-Date $WarrantyExpiry -Format "yyyy-MM-dd"
                }
                if($Warrantystartutc){Ninja-Property-Set $ninjawarrantystart $Warrantystartutc}
                if($WarrantyExpiryutc){Ninja-Property-Set $ninjawarrantyexpiry $WarrantyExpiryutc}
                if($WarrantyStatus){Ninja-Property-Set $ninjawarrantystatus $WarrantyStatus}
                if($Invoicenumber){Ninja-Property-Set $ninjainvoicenumber $Invoicenumber}
                return "Warranty details saved to NinjaRMM"
                }
    }