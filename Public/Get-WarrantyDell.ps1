function Get-WarrantyDell {
    <#
        .SYNOPSIS
        Function to get Dell Warranty
    
        .DESCRIPTION
        This function will get Dell Warranty
    
        .EXAMPLE
        Get-WarrantyDell -Serial "SerialNumber"
    
        .PARAMETER Serial
        Set Serial

        .PARAMETER DateFormat
        Set DateFormat
    
    #>
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Mandatory = $true)]
            [String]$Serial,
            [Parameter(Mandatory = $false)]
            [String]$DateFormat = 'dd-MM-yyyy'
        )
        Get-WebDriver
        Get-SeleniumModule
        $URL = "https://www.dell.com/support/productsmfe/en-us/productdetails?selection=$serial&assettype=svctag&appname=warranty&inccomponents=false&isolated=false"
        $WebDriverPath = "C:\temp\chromedriver-win64"
        $chromeOptions = [OpenQA.Selenium.Chrome.ChromeOptions]::new()
        $chromeOptions.AddArgument("headless")
        # Start a new browser session with headless mode
        try{
            $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($WebDriverPath, $chromeOptions)
        }catch{
            Write-Output "Chrome Not Installed or old version"
            $WarObj = [PSCustomObject]@{
                'Serial' = $Serial
                'Warranty Product name' = $null
                'StartDate' = $null
                'EndDate' = $null
                'Warranty Status' = 'Could not get warranty information'
                'Client' = $null
                'Product Image' = $null
                'Warranty URL' = $null
            }
            Remove-Module Selenium
            return $warObj
        }
        # Navigate to the warranty check URL
        $driver.Navigate().GoToUrl("$URL")
        Start-Sleep -Seconds 25
        
        # Find all elements on the page
        $AllElements = $driver.FindElementsByTagName("body")
        
        # Get inner text of the page
        $PageText = $AllElements[0].Text
        
        # Regular expression pattern to match "Expired" or "Expires" followed by a date
        $DateRegex = [regex]::Matches($PageText, '(Expired|Expires)\s(\d{1,2}\s[A-Z]{3}\s\d{4})')
        
        if ($DateRegex.Success) {
            # Extract the matched date
            $MatchedText = $DateRegex.Value
            $StatusDate = ($MatchedText -split " ")[1..3] -join " "
        
            # Convert date format (from "dd MMM yyyy" to "dd-MM-yyyy")
            $WarrantyEndDate = [datetime]::ParseExact($StatusDate, "dd MMM yyyy", [System.Globalization.CultureInfo]::InvariantCulture)
            $FormattedDate = $WarrantyEndDate.ToString($dateformat)
        
            # Check if it's expired or not
            if ($MatchedText -like "*Expired*") {
                $warEndDate = $FormattedDate
                $warrantystatus = "Expired"
            } else {
                $warEndDate = $FormattedDate
                $warrantystatus = "In Warranty"
            }
        } else {
            Write-Output "No matching text found for warranty status"
        }
        # Close the browser
        $driver.Quit()
        Remove-Module Selenium

        if ($warrantystatus) {
            $WarObj = [PSCustomObject]@{
                'Serial' = $serial
                'Warranty Product name' = $null
                'StartDate' = $null
                'EndDate' = $warEndDate
                'Warranty Status' = $warrantystatus
                'Client' = $null
                'Product Image' = $null
                'Warranty URL' = $null
            }
        } else {
            $WarObj = [PSCustomObject]@{
                'Serial' = $serial
                'Warranty Product name' = $null
                'StartDate' = $null
                'EndDate' = $null
                'Warranty Status' = 'Could not get warranty information'
                'Client' = $null
                'Product Image' = ""
                'Warranty URL' = ""
            }
        } 
    return $WarObj
}