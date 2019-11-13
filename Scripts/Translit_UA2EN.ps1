function translit {
    param (
        [Parameter(Mandatory = $true)]
        [String]$inString
    )
    $ua2en = [Ordered]@{
        [char]'�' = "a";	[char]'�' = "A";
        [char]'�' = "b";	[char]'�' = "B";
        [char]'�' = "v";	[char]'�' = "V";
        [char]'�' = "h";	[char]'�' = "H";
        [char]'�' = "g";	[char]'�' = "G";
        [char]'�' = "d";	[char]'�' = "D";
        [char]'�' = "e";	[char]'�' = "E";
        [char]'�' = "ie";	[char]'�' = "Ye";
        [char]'�' = "zh";	[char]'�' = "Zh";
        [char]'�' = "z";	[char]'�' = "Z";
        [char]'�' = "y";	[char]'�' = "Y";
        [char]'�' = "i";	[char]'�' = "I";
        [char]'�' = "i";	[char]'�' = "Yi";
        [char]'�' = "i";	[char]'�' = "Y";
        [char]'�' = "k";	[char]'�' = "K";
        [char]'�' = "l";	[char]'�' = "L";
        [char]'�' = "m";	[char]'�' = "M";
        [char]'�' = "n";	[char]'�' = "N";
        [char]'�' = "o";	[char]'�' = "O";
        [char]'�' = "p";	[char]'�' = "P";
        [char]'�' = "r";	[char]'�' = "R";
        [char]'�' = "s";	[char]'�' = "S";
        [char]'�' = "t";	[char]'�' = "T";
        [char]'�' = "u";	[char]'�' = "U";
        [char]'�' = "f";	[char]'�' = "F";
        [char]'�' = "kh";	[char]'�' = "Kh";
        [char]'�' = "ts";	[char]'�' = "Ts";
        [char]'�' = "ch";	[char]'�' = "Ch";
        [char]'�' = "sh";	[char]'�' = "Sh";
        [char]'�' = "shch";	[char]'�' = "Shch";
        [char]'�' = ""; [char]'�' = "";
        [char]'�' = "iu";	[char]'�' = "Yu";
        [char]'�' = "ia";	[char]'�' = "Ya";
        [char]' ' = " "
    }

    $inChars = $inString.ToCharArray()

    for ($i = 0; $i -lt $inChars.Count; $i++) {

        if ($inChars[$i] -eq '�' -and $inChars[$i + 1] -eq '�' ) {
            $outChars += "zgh"

        }
        else {
            $outChars += $ua2en[$inChars[$i]]
        }
    }

    $outChars = $outChars -replace ('hh', 'h')
    return (Get-Culture).TextInfo.ToTitleCase($outChars)
}



translit "������� �������"
