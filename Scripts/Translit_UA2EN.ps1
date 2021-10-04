function UA2EN {
    param(
        [Parameter(Mandatory = $true)][string]$inString
    )
    $tText = ""
    #Создаём хеш-таблицу соответствия символов
    $t = New-Object system.collections.hashtable

    $t.'А' = "A";    $t.'а' = "а"
    $t.'Б' = "B";    $t.'б' = "b"
    $t.'В' = "V";    $t.'в' = "v"
    $t.'Г' = "H";    $t.'г' = "h"
    $t.'Ґ' = "G";	 $t.'ґ' = "g"
    $t.'Д' = "D";	 $t.'д' = "d"
    $t.'Е' = "E";	 $t.'е' = "е"
    $t.'Є' = "Ye";	 $t.'є' = "ie"
    $t.'Ж' = "Zh";	 $t.'ж' = "zh"
    $t.'З' = "Z";	 $t.'з' = "z"
    $t.'И' = "Y";	 $t.'и' = "y"
    $t.'І' = "I";	 $t.'і' = "i"
    $t.'Ї' = "Yi";	 $t.'ї' = "i"
    $t.'Й' = "Y";	 $t.'й' = "i"
    $t.'К' = "K";	 $t.'к' = "k"
    $t.'Л' = "L";	 $t.'л' = "l"
    $t.'М' = "M";	 $t.'м' = "m"
    $t.'Н' = "N";	 $t.'н' = "n"
    $t.'О' = "O";	 $t.'о' = "o"
    $t.'П' = "P";	 $t.'п' = "p"
    $t.'Р' = "R";	 $t.'р' = "r"
    $t.'С' = "S";	 $t.'с' = "s"
    $t.'Т' = "T";	 $t.'т' = "t"
    $t.'У' = "U";	 $t.'у' = "u"
    $t.'Ф' = "F";	 $t.'ф' = "f"
    $t.'Х' = "Kh";	 $t.'х' = "kh"
    $t.'Ц' = "Ts";	 $t.'ц' = "ts"
    $t.'Ч' = "Ch";	 $t.'ч' = "ch"
    $t.'Ш' = "Sh";	 $t.'ш' = "sh"
    $t.'Щ' = "Shch"; $t.'щ' = "shch"
    $t.'Ь' = "";	 $t.'ь' = ""
    $t.'Ю' = "Yu";	 $t.'ю' = "іu"
    $t.'Я' = "Ya";	 $t.'я' = "ia"
    $t."’" = ""#;     $t.' ' = " " # Пробел

    foreach ($CHR in $inCHR = $inString.ToCharArray()) {
        if ($null -ne $t["$CHR"])
            { $tText += $t["$CHR"] }
        else
            { $tText += "$CHR" }
    }
    return $tText
}
# Test
Clear-Host
UA2EN "Йосипівка Олексій Єнакієве Короп’є Яготин Костянтин Asdfg 1234"
