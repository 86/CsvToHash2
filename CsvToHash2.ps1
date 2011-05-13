function CsvToHash2 {
    param (
        [String]$csv,
        [String]$encoding = "Shift_JIS"
    )
    
    if (Test-Path $csv -include *.csv) {
        $csv = Convert-Path $csv
        $enc = [Text.Encoding]::GetEncoding($encoding)
        $reader = New-Object IO.StreamReader($csv, $enc)
        $header = $reader.Readline() -split ","
        for ($i = 0; $i -lt $header.length; $i++) {
            if ($header[$i] -match "`".*`"") {
                $header[$i] = $header[$i] -replace "`"(.*)`"", "`$1"
            }
        }
        $hash_all = @{}
        while(!$reader.EndOfStream){
            $hash_line = @{}
            $line = $reader.Readline() -split ","
            for ($j = 1; $j -lt $line.length; $j++) {
                $key_line = $header[$j]
                $hash_line.$key_line = $line[$j]
            }
            if ($line[0] -match "`".*`"") {
                $line[0] = $line[0] -replace "`"(.*)`"", "`$1"
            }
            $key_all = $line[0]
            $hash_all.$key_all = $hash_line
        }
        $reader.Close()
        return $hash_all
    } else { Write-Host "Specified file does not exist or is not csv format."}
}
