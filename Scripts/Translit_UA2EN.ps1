function translit {
    param (
        [Parameter(Mandatory = $true)]
        [String]$inString
    )
    $ua2en = [Ordered]@{
        [char]'а' = "a";	[char]'А' = "A";
        [char]'б' = "b";	[char]'Б' = "B";
        [char]'в' = "v";	[char]'В' = "V";
        [char]'г' = "h";	[char]'Г' = "H";
        [char]'ґ' = "g";	[char]'Ґ' = "G";
        [char]'д' = "d";	[char]'Д' = "D";
        [char]'е' = "e";	[char]'Е' = "E";
        [char]'є' = "ie";	[char]'Є' = "Ye";
        [char]'ж' = "zh";	[char]'Ж' = "Zh";
        [char]'з' = "z";	[char]'З' = "Z";
        [char]'и' = "y";	[char]'И' = "Y";
        [char]'і' = "i";	[char]'І' = "I";
        [char]'ї' = "i";	[char]'Ї' = "Yi";
        [char]'й' = "i";	[char]'Й' = "Y";
        [char]'к' = "k";	[char]'К' = "K";
        [char]'л' = "l";	[char]'Л' = "L";
        [char]'м' = "m";	[char]'М' = "M";
        [char]'н' = "n";	[char]'Н' = "N";
        [char]'о' = "o";	[char]'О' = "O";
        [char]'п' = "p";	[char]'П' = "P";
        [char]'р' = "r";	[char]'Р' = "R";
        [char]'с' = "s";	[char]'С' = "S";
        [char]'т' = "t";	[char]'Т' = "T";
        [char]'у' = "u";	[char]'У' = "U";
        [char]'ф' = "f";	[char]'Ф' = "F";
        [char]'х' = "kh";	[char]'Х' = "Kh";
        [char]'ц' = "ts";	[char]'Ц' = "Ts";
        [char]'ч' = "ch";	[char]'Ч' = "Ch";
        [char]'ш' = "sh";	[char]'Ш' = "Sh";
        [char]'щ' = "shch";	[char]'Щ' = "Shch";
        [char]'ь' = ""; [char]'Ь' = "";
        [char]'ю' = "iu";	[char]'Ю' = "Yu";
        [char]'я' = "ia";	[char]'Я' = "Ya";
        [char]' ' = " "
    }

    $inChars = $inString.ToCharArray()

    for ($i = 0; $i -lt $inChars.Count; $i++) {

        if ($inChars[$i] -eq 'з' -and $inChars[$i + 1] -eq 'г' ) {
            $outChars += "zgh"

        }
        else {
            $outChars += $ua2en[$inChars[$i]]
        }
    }

    $outChars = $outChars -replace ('hh', 'h')
    return (Get-Culture).TextInfo.ToTitleCase($outChars)
}



translit "Юркевич Геннадій"
