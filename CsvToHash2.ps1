[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 

function CsvToHash2 {
    param (
        [String]$csv,
        [String]$encoding = "Shift_JIS"
    )
    
    if (Test-Path $csv -include *.csv) {
        $csv = Convert-Path $csv
        $enc = [System.Text.Encoding]::GetEncoding($encoding)
        $parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($csv, $enc)
        $parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
        $parser.SetDelimiters(",")
        
        $header = $parser.ReadFields()
        $hash_all = @{}
        while(!$parser.EndOfData){
            $hash_line = @{}
            $line = $parser.ReadFields()
            for ($j = 1; $j -lt $line.length; $j++) {
                $key_line = $header[$j]
                $hash_line.$key_line = $line[$j]
            }
            $key_all = $line[0]
            $hash_all.$key_all = $hash_line
        }
        $parser.Close()
        return $hash_all
    } else { Write-Host "Specified file does not exist or is not csv format."}
}
